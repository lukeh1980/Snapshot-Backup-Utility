# SBU (Snapshot Backup Utility) 0.4.5
SBU is an easy to use Linux command line utility designed to create automated snapshots using only bash scripting and rsync 3.1.2 or greater allowing it to run on most Linux distributions. You can have as many backup jobs running at different intervals as your system resources will allow. SBU can run on lightweight computers (It was developed on a Rasberry Pi 2 just for kicks) but large directory structures will require more processing power to take frequent snapshots.

Due to the use of hard links SBU requires the destination file system to be Linux based but not the source directory. There is no GUI interface but there are plans for a web interface and API in the future. Encryption of destination directories are also planned for a future release.

# INSTALLATION
The below steps are the easiest way to install SBU, it has been tested on CentOS/RHEL 6/7 and Ubuntu Server 16/17.

Download the tar file named sbu-x.x.x-install.tar and extract it on your Linux system:
	
	tar -xaf sbu-x.x.x-install.tar
	
Change directory to extracted folder:

	cd sbu-x.x.x
	
You will find 4 files: sbu-x.x.x.tar, install-sbu.sh, uninstall-sbu.sh and upgrade-sbu.sh. These scripts must have the executable bit set:
	
	chmod +x install-sbu.sh

Run install-sbu.sh:
		
	./install-sbu.sh

NOTE: 
The install-sbu.sh script will check for all packages that are needed to complete the installation and if any are missing they will be installed. The system package manager will be used for all packages with the exception of rsync version 3.1.2, SBU cannot run without this version of rsync installed and it needs to be built from source. The installation script will download and build this version of rsync from this location: https://download.samba.org/pub/rsync/src/rsync-3.1.2.tar.gz.

Manual installation instructions are available in INSTALL.txt.

# USAGE EXAMPLE
You can read usage instructions by typing "sbu --help" at the command prompt. Usage is meant to be simple and straight forward, for example to create a job type: 
	
	sbu --create job-name --source /my/source/directory --dest /my/backup/directory --interval 30 --retention 30

NOTE: --interval is in minutes and --retention is in days.

This will create a new directory for snapshots in /my/backup/directory/job-name/snapshots.
The initial full sync is named job-name.full, subsequent snapshots are named job-name.0, job-name.1, job-name.2, etc. The newest snapshot is always job-name.0, as snapshots reach the --retention limit they will be rolled into job-name.full. Each snapshot has a timestamp file and a snapshot-time file with the number of minutes the snapshot took to create.

# RESTORE SNAPSHOTS
Restoration tools are planned in the future but for now you can simply copy files from a snapshot directory to restore from SBU backups.

# RECONFIGURING JOBS
You can reconfigure some features of a running job, more are planned in the future.

Set autostart (default is on):
	
	sbu --autostart on/off --name job-name
		
You can also make changes to the config file for each job. Config files are located at /opt/sbu/jobs/job-name/job-name.conf. WARNING: This may have unpredictable results, use with caution. You should be able to change the Interval and Retention (days to keep) settings on running jobs, some settings will take affect on the next interval but you may need to restart the job for all settings to take effect. Changing source and destination directories will result in backup failures, a new job should be created to change these.

# REMOVING JOBS
You can remove jobs using (it will prompt to delete backup files): 

	sbu --remove job-name
	
To delete a job and backup files without prompting use:

	sbu --remove job-name --force
	
Since deleting many snapshots of large directories can take a long time (days even) the job-name directory is renamed to a temp name: .job-name.deleting. SBU will try to delete this directory as long as it exists even if it is interrupted or the server is rebooted before the delete is complete.

# VIEWING JOB STATUS
You can check job status by typing:

	sbu --status job-name
	
View all job statuses:

	sbu --status
	
Watch live status of jobs:

	watch sbu --status

# RESTARTING JOBS
If you need to restart, stop or start a job type:

	sbu --restart job-name
	sbu --stop job-name
	sbu --start job-name

# STARTING JOBS ON BOOTUP
By default any job you create will automatically start at bootup, you can turn this off by typing: 

	sbu --autostart off --name job-name

# SETTING PERMISSIONS
By default SBU will attempt to copy permissions from source to destination but you can set the permissions and ownership of backup files when creating jobs:

	--set-perms xxxx (e.g. --set-perms 0755)
	--set-owner ownername
	--set-group groupname
	
If you do not want SBU to do anything with file permissions (i.e. inherit permissions from destination filesystem settings) you can use "--set-perms no-perms" option when creating the job. You can also edit the config file and change the permissions to "no-perms" and it will not make any changes to permissions or ownership of files when transferring.

NOTE: If you are using an NFS share as a backup location you must use no_root_squash directive when exporting the share or SBU will not be able to change permissions.
