# Container Runtime

This repository contains a container runtime script that sets up and runs a basic container environment using namespaces.

## Requirements

To run the container runtime script successfully, ensure the following prerequisites are met:

- **Linux Environment**: Requires a Linux kernel with support for namespaces (`CONFIG_NAMESPACES` enabled).
- **Python 3**: The script is written in Python 3 and requires Python 3 to be installed (`python3` command available).
- **`unshare` Command**: This command is necessary for unsharing namespaces and is typically provided by the `util-linux` package.
- **`chroot` Command**: Required for changing the root directory of the container environment.
- **Docker Base Filesystem Archive**: Download the Ubuntu base filesystem archive into `/mycontainers/basefs`. You can do this using the following commands:

## Setup Instructions

### 1. Prepare Base Filesystem
Run these shell commands to create a base filesystem directory for the containers to get their filesystem from, and download ubuntu filesystem into it:

```bash
sudo mkdir -p /mycontainers/basefs
wget https://partner-images.canonical.com/core/focal/current/ubuntu-focal-core-cloudimg-amd64-root.tar.gz -O /mycontainers/basefs/ubuntu-base-20.04-base-amd64.tar.gz
```

# 2. Clone Repository
Clone this repository to get the container runtime script:

```bash
git clone https://github.com/pouyatoroghi/SDMN_Container_HW.git
cd SDMN_Container_HW/Question\ 2
```

# 3. Running the Container Runtime Script
There are two methods to run the container runtime script depending on whether you want to set a memory limit for the container:

Method 1: Without Memory Limitation
Run the container runtime script with the desired hostname:

```bash
python3 container_runtime.py <hostname>
```
Replace <hostname> with your desired hostname.

Example usage:

```bash
python3 container_runtime.py myhostname
```

Method 2: With Memory Limitation
Run the container runtime script with the desired hostname and memory limit (in MB):

```bash
python3 container_runtime.py <hostname> <memory_limit_MB>
```
Replace <hostname> with your desired hostname and <memory_limit_MB> with the memory limit in megabytes that you want to allocate to the container.

Example usage with a memory limit of 512 MB:

```bash
python3 container_runtime.py myhostname 512
```
