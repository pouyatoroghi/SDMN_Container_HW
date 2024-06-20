Upon reviewing the session log provided, it is evident that each container instance operates with its own distinct root filesystem on the host machine. This ensures isolation and independence from the host's root filesystem, a fundamental characteristic of containerization.

### Analysis of Session Log:

1. **Invocation and Namespace Management**:
   - **Requirement**: Upon executing `sudo python3 container_runtime.py myhostname`, the container runtime should initiate a new environment with isolated namespaces, where `myhostname` denotes the container's hostname.
   - **Verification**: The log demonstrates that running this command results in the creation of new namespaces (`net`, `mnt`, `pid`, `uts`) and successfully enters a bash shell with `myhostname` as the hostname within these isolated namespaces. The part of the log that verifies it:
   
```
petro@petro-VirtualBox:~/Container/Q2$ sudo python3 container_runtime.py myhostname
[sudo] password for petro: 
Extracting base filesystem to /mycontainers/container6...
Base filesystem extracted to /mycontainers/container6.
Unsharing namespaces and entering container...
root@myhostname:/#
```

2. **Process Management within Container**:
   - **Requirement**: Running `ps fax` inside the container should display the bash process as PID 1, indicating the primary process within the container's environment.
   - **Verification**: The session log confirms that `ps fax` shows the bash process as PID 1, which aligns with the expected behavior of a containerized environment.  The part of the log that verifies it:
   
```
root@myhostname:/# ps
    PID TTY          TIME CMD
      1 ?        00:00:00 bash
      6 ?        00:00:00 ps
root@myhostname:/# ps fax
    PID TTY      STAT   TIME COMMAND
      1 ?        S      0:00 /bin/bash
      7 ?        R+     0:00 ps fax
```

3. **Namespace Isolation**:
   - **Requirement**: The container runtime script must isolate critical namespaces (`net`, `mnt`, `pid`, `uts`) to ensure process and filesystem isolation.
   - **Verification**: Analysis of the `lsns` command output reveals the presence of all required namespaces (`net`, `mnt`, `pid`, `uts`), demonstrating effective namespace isolation for each container instance. The part of the log that verifies it:
   
```
root@myhostname:/# lsns
        NS TYPE   NPROCS PID USER COMMAND
4026531835 cgroup      2   1 root /bin/bash
4026531837 user        2   1 root /bin/bash
4026531839 ipc         2   1 root /bin/bash
4026532253 mnt         2   1 root /bin/bash
4026532254 uts         2   1 root /bin/bash
4026532255 pid         2   1 root /bin/bash
4026532256 net         2   1 root /bin/bash
```

```
petro@petro-VirtualBox:~/Container/Q2$ lsns
        NS TYPE   NPROCS   PID USER  COMMAND
4026531835 cgroup     80  2159 petro /lib/systemd/systemd --user
4026531836 pid        80  2159 petro /lib/systemd/systemd --user
4026531837 user       80  2159 petro /lib/systemd/systemd --user
4026531838 uts        80  2159 petro /lib/systemd/systemd --user
4026531839 ipc        80  2159 petro /lib/systemd/systemd --user
4026531840 net        80  2159 petro /lib/systemd/systemd --user
4026531841 mnt        79  2159 petro /lib/systemd/systemd --user
4026532489 mnt         1  2662 petro /snap/snap-store/638/usr/bin/snap-store --gapplication-service
```
We can see that NS are different for pid, mnt, uts, net namespaces from container to host.



4. **Root Filesystem Isolation**:
   - **Requirement**: Each container instance should possess its own distinct root filesystem on the host, independent of the host's root filesystem.
   - **Verification**: Inspection of the root directory (`/`) contents within the container environment shows directories (`bin`, `boot`, `dev`, `etc`, etc.), indicating a separate root filesystem for each container instance, thereby meeting the isolation requirement. The part of the log that verifies it:
   
```
root@myhostname:/# ls -l /
total 60
lrwxrwxrwx   1 root root    7 Jun 30  2023 bin -> usr/bin
drwxr-xr-x   2 root root 4096 Apr 15  2020 boot
drwxr-xr-x   2 root root 4096 Jun 30  2023 dev
drwxr-xr-x  30 root root 4096 Jun 30  2023 etc
drwxr-xr-x   2 root root 4096 Apr 15  2020 home
lrwxrwxrwx   1 root root    7 Jun 30  2023 lib -> usr/lib
lrwxrwxrwx   1 root root    9 Jun 30  2023 lib32 -> usr/lib32
lrwxrwxrwx   1 root root    9 Jun 30  2023 lib64 -> usr/lib64
lrwxrwxrwx   1 root root   10 Jun 30  2023 libx32 -> usr/libx32
drwxr-xr-x   2 root root 4096 Jun 30  2023 media
drwxr-xr-x   2 root root 4096 Jun 30  2023 mnt
drwxr-xr-x   2 root root 4096 Jun 30  2023 opt
dr-xr-xr-x 292 root root    0 Jun 20 10:02 proc
drwx------   2 root root 4096 Jun 30  2023 root
drwxr-xr-x   4 root root 4096 Jun 30  2023 run
lrwxrwxrwx   1 root root    8 Jun 30  2023 sbin -> usr/sbin
-rwxr-xr-x   1 root root  244 Jun 20 10:02 setup.sh
drwxr-xr-x   2 root root 4096 Jun 30  2023 srv
drwxr-xr-x   3 root root 4096 Jun 20 10:02 sys
drwxrwxrwt   2 root root 4096 Jun 30  2023 tmp
drwxr-xr-x  13 root root 4096 Jun 30  2023 usr
drwxr-xr-x  11 root root 4096 Jun 30  2023 var
```
We can see that it contains the Ubuntu 20.04 filesystem as it should have.

We can check for specific files and directories that are typical in an Ubuntu 20.04 filesystem as follows:
```
root@myhostname:/# cat /etc/os-release
NAME="Ubuntu"
VERSION="20.04.6 LTS (Focal Fossa)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 20.04.6 LTS"
VERSION_ID="20.04"
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
VERSION_CODENAME=focal
UBUNTU_CODENAME=focal
```

We now verify that the root filesystem is isolated from the host. Knowing that creating files within the container’s root should not affect the host’s filesystem. We check it as follows:
```
root@myhostname:/# touch /testfile
root@myhostname:/# ls /testfile
/testfile
root@myhostname:/# exit
exit
petro@petro-VirtualBox:~/Container/Q2$ ls /testfile
ls: cannot access '/testfile': No such file or directory
```

5. **Memory Limitation Support**:
   - **Requirement**: The container runtime script should support an optional memory limit for containers, specified in megabytes.
   - **Verification**: The session log includes an example where the container is started with a memory limit (`512 MB`). Checking the memory limit file (`/sys/fs/cgroup/memory/container7/memory.limit_in_bytes`) confirms that the specified limit is applied successfully. The part of the log that verifies it:(when the container was run by method 2)
   
```
root@myhostname:/# cat /sys/fs/cgroup/memory/container7/memory.limit_in_bytes
536870912
```

### Conclusion:

Based on the comprehensive analysis of the provided session log, it is clear that the container runtime script effectively implements the required containerization features. Each container instance operates with its own separate root filesystem on the host, ensuring robust isolation and independence.
