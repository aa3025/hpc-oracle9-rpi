# Oracle Linux 9 PXE Network installer on Raspberry Pi
for deployment of x86_64 machines from Raspberry Pi [4] board running Oracle Linux 9 (aarch64)

This project is collection of bash scripts and config files to automatically deploy rhel9-based HPC with PXE-install and kickstart files. Supports both BIOS-based and EFI PXE scenarios. Project's webpage is here: https://centoshpc.wordpress.com/

Please do not e-mail me asking for support. These scripts are not guaranteed to work and are provided for your self-development. However if you are interested, you can join this project and contribute to its development on GitHub.

Terms: 
    - master is the headnode of HPC, it must be installed first from official Oracle Linux 8 dvd
    - node(s) are compute nodes which reside in a pivate network of the master (on the 2nd LAN adapter)

Deployment steps:

1) Flash Oracle Linux 9 to a Raspberry Pi 4 board, boot it, expand root fs if needed (will need space for DVD image), make sure the network is up, proceed further from its terminal. Oracle Linux 9 RPi image and x86_64 DVD, which can be downloaded free of charge from Oracle Linux website: https://yum.oracle.com/ISOS/OracleLinux/OL9/u1/x86_64/OracleLinux-R9-U1-x86_64-dvd.iso.

2) get the updated version of this repository

    2.1 From  https://github.com/aa3025/hpc-oracle9-rpi

    2.2 Uncompress the archive or clone our project's git repository "git clone https://github.com/aa3025/hpc-oracle9-rpi.git"

    2.3 If you failed to do above steps do not proceed further.


3) Your installed master node (RPi) must have the external network adapter configured, up and running, e.g. with NetworkManager or any other way. 

4) The 2nd network adapter must be connected to the internal network of HPC (i.e. via switch or hub), where all the "compute" nodes will be booting up from. All compute nodes must be connected to the same hub with their (not necessarily) 1st network adapter and configured to boot from LAN (PXE boot).

5) Download OL9 install DVD

6) ''cd hpc_oracle9-rpi'' and execute "./install.sh ../OL9.iso" from this folder (where ../OL9.iso is relative path to OL9 iso file). You will be prompted in a minute to enter internal and external LAN interface names. This is the only input required form user.

5) Once install.sh finishes, go and power up all your compute nodes (its better to do it one-by-one in an orderly fasion, their hostnames will be based on their DHCP addresses (node1, node2...), so if you want any kind of "system" in their naming make sure they boot with interval, so that previous one already obtained IP before the next one boots). They must be BIOS-configured to boot from network (PXE boot).

6) The nodes will install, post-configure themselves, and each will modify the master's dhcpd.conf, /etc/hosts file, /etc/pdsh/machines file and add their grub.cfg-xxx and xx-xx-xx-xx-xx (macs) to /tftpboot on master, so that on the next boot they don't go into PXE install again, but boot form local drive /dev/sda instead.

7) Once PXE-install finishes, the nodes will reboot themselves and will mount /home and /share from server via NFS. If you want to share pre-existing /home folder with user files inside, its better rename in before this installation, and when deployment finishes, rename it back to /home and restart nfs-server service.

8) Check if HPC is deployed by doing e.g. "pdsh hostname" -> the nodes must report back their hostnames. Its a good idea to restart dhcpd on master for it to swallow /etc/dhcp/dhcpd.conf the modified by nodes (service dhcpd restart).
If you want to repeat install of a node already deployed previosly, you just need to delete its /tftpboot/grub.cfg-01-xx-xx-xx-xx-xx-xx and /tftpboot/xx-xx-xx-xx-xx-xx files and its records from /etc/pdsh/machines and /etc/dhcp/dhcpd.conf and reset the node(s) without re-running ./install.sh ! Server configuration is permanent, so it still must be able to serve new deployments after reboot (the only thing you need to ensure is that OL8 dvd iso file is mounted after reboot of the master in /var/www/html/OL8).

9) Then you can run optional "./postinstall_from_server.sh" script to add additional rpm's on the master and compute nodes and sync "/etc/hosts" file between the nodes" (not tested yet with OL8, some package names may have been changed since rhel7)

10) New users can be deployed with the script (cd ./configs)  './newuser username "real user name (comments)". Script will create a local user and group on the master and nodes, create ssh-keys for paswordless connection to the nodes.

11) You can use pdsh to install missing packages on the nodes in parallel or mass-copying files etc.

12) addedd UEFI PXE boot support, September, 2018. #centos7hpc (not tested with OL8 yet)

Alex Pedcenko, September 2019,  aa3025(at)live.co.uk , http://centoshpc.wordpress.com 



