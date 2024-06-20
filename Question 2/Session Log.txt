petro@petro-VirtualBox:~/Container/Q2$ sudo python3 container_runtime.py myhostname
[sudo] password for petro: 
Extracting base filesystem to /mycontainers/container6...
Base filesystem extracted to /mycontainers/container6.
Unsharing namespaces and entering container...
root@myhostname:/# ps
    PID TTY          TIME CMD
      1 ?        00:00:00 bash
      6 ?        00:00:00 ps
root@myhostname:/# ps fax
    PID TTY      STAT   TIME COMMAND
      1 ?        S      0:00 /bin/bash
      7 ?        R+     0:00 ps fax
root@myhostname:/# lsns
        NS TYPE   NPROCS PID USER COMMAND
4026531835 cgroup      2   1 root /bin/bash
4026531837 user        2   1 root /bin/bash
4026531839 ipc         2   1 root /bin/bash
4026532253 mnt         2   1 root /bin/bash
4026532254 uts         2   1 root /bin/bash
4026532255 pid         2   1 root /bin/bash
4026532256 net         2   1 root /bin/bash
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
dr-xr-xr-x 291 root root    0 Jun 20 10:00 proc
drwx------   2 root root 4096 Jun 30  2023 root
drwxr-xr-x   4 root root 4096 Jun 30  2023 run
lrwxrwxrwx   1 root root    8 Jun 30  2023 sbin -> usr/sbin
-rwxr-xr-x   1 root root   73 Jun 20 10:00 setup.sh
drwxr-xr-x   2 root root 4096 Jun 30  2023 srv
drwxr-xr-x   2 root root 4096 Apr 15  2020 sys
drwxrwxrwt   2 root root 4096 Jun 30  2023 tmp
drwxr-xr-x  13 root root 4096 Jun 30  2023 usr
drwxr-xr-x  11 root root 4096 Jun 30  2023 var
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
root@myhostname:/# touch /testfile
root@myhostname:/# ls /testfile
/testfile
root@myhostname:/# exit
exit
petro@petro-VirtualBox:~/Container/Q2$ ls /testfile
ls: cannot access '/testfile': No such file or directory
petro@petro-VirtualBox:~/Container/Q2$ sudo python3 container_runtime.py myhostname 512
Extracting base filesystem to /mycontainers/container7...
Base filesystem extracted to /mycontainers/container7.
Setting memory limit to 512 MB for container 7
Unsharing namespaces and entering container...
root@myhostname:/# ps
    PID TTY          TIME CMD
      1 ?        00:00:00 bash
      7 ?        00:00:00 ps
root@myhostname:/# ps fax
    PID TTY      STAT   TIME COMMAND
      1 ?        S      0:00 /bin/bash
      8 ?        R+     0:00 ps fax
root@myhostname:/# lsns
        NS TYPE   NPROCS PID USER COMMAND
4026531835 cgroup      2   1 root /bin/bash
4026531837 user        2   1 root /bin/bash
4026531839 ipc         2   1 root /bin/bash
4026532253 mnt         2   1 root /bin/bash
4026532254 uts         2   1 root /bin/bash
4026532255 pid         2   1 root /bin/bash
4026532256 net         2   1 root /bin/bash
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
root@myhostname:/# cat /sys/fs/cgroup/memory/container7/memory.limit_in_bytes
536870912
root@myhostname:/# touch /testfile
root@myhostname:/# ls /testfile
/testfile
root@myhostname:/# exit
exit
petro@petro-VirtualBox:~/Container/Q2$ ls /testfile
ls: cannot access '/testfile': No such file or directory
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

