# Import necessary modules
import os                  # For OS operations
import sys                 # For system-specific parameters and functions
import subprocess          # For subprocess management

# Function to mount the /proc filesystem inside the container
def mount_proc(new_root):
    """
    Mounts the /proc filesystem inside the container.

    Args:
        new_root (str): Path to the container root directory.
    """
    # Define the path to mount /proc
    proc_path = os.path.join(new_root, 'proc')
    # Create the directory if it doesn't exist
    os.makedirs(proc_path, exist_ok=True)
    # Print and execute the mount command
    print(f"Mounting /proc at {proc_path}")
    subprocess.run(['mount', '-t', 'proc', 'proc', proc_path], check=True)

# Function to set memory limits using cgroups for the container
def limit_memory(mem_limit, container_id):
    """
    Sets memory limits for the specified container using cgroups.

    Args:
        mem_limit (int): Memory limit in MB.
        container_id (int): Container ID.
    """
    # Define the base directory for cgroup memory
    cgroup_base_dir = '/sys/fs/cgroup/memory'
    # Path to the specific container's cgroup directory
    cgroup_dir = os.path.join(cgroup_base_dir, f'container{container_id}')
    # Create the directory if it doesn't exist
    os.makedirs(cgroup_dir, exist_ok=True)
    # Print and set the memory limit
    print(f"Setting memory limit to {mem_limit} MB for container {container_id}")
    with open(os.path.join(cgroup_dir, 'memory.limit_in_bytes'), 'w') as f:
        f.write(f'{mem_limit * 1024 * 1024}\n')
    # Write the current process ID to cgroup.procs to apply the limit
    with open(os.path.join(cgroup_dir, 'cgroup.procs'), 'w') as f:
        f.write(f'{os.getpid()}\n')

# Function to create the container root directory and extract base filesystem
def create_container_root():
    """
    Creates a new container root directory and extracts the base filesystem archive into it.

    Returns:
        new_root (str): Path to the newly created container root directory.
        next_number (int): The ID number of the new container.
    """
    # Path to the base filesystem archive
    base_fs = '/mycontainers/basefs/ubuntu-base-20.04-base-amd64.tar.gz'
    # Check if the base filesystem archive exists
    if not os.path.exists(base_fs):
        print("Base filesystem archive not found. Ensure the base filesystem archive is downloaded to /mycontainers/basefs")
        sys.exit(1)

    # Directory where containers are stored
    containers_dir = '/mycontainers'
    # List of existing containers
    existing_containers = [d for d in os.listdir(containers_dir) if os.path.isdir(os.path.join(containers_dir, d)) and d.startswith('container')]
    # Extract container numbers from existing containers
    existing_numbers = [int(d.replace('container', '')) for d in existing_containers if d.replace('container', '').isdigit()]
    # Determine the next container number
    next_number = max(existing_numbers, default=0) + 1
    # Path to the new container's root directory
    new_root = os.path.join(containers_dir, f'container{next_number}')

    # Create the new container root directory if it doesn't exist
    os.makedirs(new_root, exist_ok=True)
    # Extract the base filesystem archive into the new root directory
    print(f"Extracting base filesystem to {new_root}...")
    result = subprocess.run(['tar', '-xzf', base_fs, '-C', new_root])
    # Check if extraction was successful
    if result.returncode != 0:
        print(f"Failed to extract base filesystem to {new_root}")
        sys.exit(1)
    print(f"Base filesystem extracted to {new_root}.")

    return new_root, next_number

# Function to create a setup script inside the container root directory
def create_setup_script(hostname, new_root, mem_limit, container_id):
    """
    Creates a setup script inside the container root directory.

    Args:
        hostname (str): Hostname for the container.
        new_root (str): Path to the container root directory.
        mem_limit (int): Memory limit in MB (optional).
        container_id (int): Container ID.

    Returns:
        setup_script_path (str): Path to the created setup script.
    """
    # Path to the setup script file
    setup_script_path = os.path.join(new_root, 'setup.sh')
    # Open setup script file for writing
    with open(setup_script_path, 'w') as f:
        # Write basic setup commands to the script
        f.write(f"""#!/bin/bash
mount -t proc proc /proc
hostname {hostname}
""")
        # If memory limit is specified, write memory cgroup commands
        if mem_limit:
            f.write(f"""
mkdir -p /sys/fs/cgroup/memory/container{container_id}
echo {mem_limit * 1024 * 1024} > /sys/fs/cgroup/memory/container{container_id}/memory.limit_in_bytes
echo $$ > /sys/fs/cgroup/memory/container{container_id}/cgroup.procs
""")
        # Write the command to execute a bash shell in the container
        f.write("""
exec /bin/bash
""")
    # Make the setup script executable
    os.chmod(setup_script_path, 0o755)
    return setup_script_path

# Function to unshare namespaces and enter the container environment
def unshare_and_enter_container(hostname, new_root, container_id, mem_limit=None):
    """
    Unshares namespaces and enters the container using unshare and chroot.

    Args:
        hostname (str): Hostname for the container.
        new_root (str): Path to the container root directory.
        container_id (int): Container ID.
        mem_limit (int): Memory limit in MB (optional).
    """
    print(f"Unsharing namespaces and entering container...")

    # Create the setup script inside the container
    setup_script_path = create_setup_script(hostname, new_root, mem_limit, container_id)

    # Command to unshare namespaces and chroot into the container
    unshare_cmd = [
        'unshare',
        '--fork',
        '--pid',
        '--mount-proc',
        '--net',
        '--uts',
        '--mount',
        '--',
        'chroot', new_root, '/setup.sh'
    ]

    # Execute the unshare command to enter the container
    subprocess.run(unshare_cmd, check=True)

# Main function to initiate container creation and setup
def main():
    """
    Main function to parse command line arguments and initiate container creation.
    """
    # Check if hostname argument is provided
    if len(sys.argv) < 2:
        print(f"Usage: {sys.argv[0]} <hostname> [mem_limit_MB]")
        sys.exit(1)
    
    # Hostname for the container (first command line argument)
    hostname = sys.argv[1]
    # Memory limit for the container in MB (optional second command line argument)
    mem_limit = int(sys.argv[2]) if len(sys.argv) == 3 else None

    # Create the container root directory and get container ID
    new_root, container_id = create_container_root()
    # If memory limit is specified, set memory limits for the container
    if mem_limit:
        limit_memory(mem_limit, container_id)
    # Enter the container environment by unsharing namespaces
    unshare_and_enter_container(hostname, new_root, container_id, mem_limit)

# Standard Python code to execute main function if this script is run directly
if __name__ == "__main__":
    main()

