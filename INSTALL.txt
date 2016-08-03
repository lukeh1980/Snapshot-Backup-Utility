# INSTALLATION

Follow these steps to install SBU:

Download the tar file named sbu-x.x.x-install.tar and extract it on your Linux system:
  
    tar -xaf sbu-x.x.x-install.tar
  
Change directory to extracted folder:

    cd sbu-x.x.x

You will find 3 files: sbu-x.x.x.tar, install-sbu.sh, uninstall-sbu.sh. CHMOD install/uninstall scripts to be executable:

    chmod +x install-sbu.sh uninstall-sbu.sh

Run install-sbu.sh:

    ./install-sbu.sh

SBU will prompt you to skip or install rsync version 3.1.2, keep in mind SBU will not work without rsync 3.1.2 installed. 
If you select y it will download rsync from samba.org and install it for you, if you select n it will continue the install without 
installing rsync but you will have to install it on your own to use SBU.

NOTE: If you already have an older rsync package installed via a package manager installing rsync 3.1.2 with this script may
cause a conflict.
