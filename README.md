# SBU (Snapshot Backup Utility)
SBU is a linux command line utility for creating automated backup jobs that generate snapshots using hard links and rsync. It is written using only bash and rsync so it should run on most Linux distributions. It was written on a Rasberry Pi 2 and tested taking snapshots every minute on a small directory, however its intended use was to take snapshots every 30 minutes of a heavily active directory structure consisting of about 1 million files (mostly office documents) and a total size of about 600 GB. SBU should work on larger data stores but the snapshot time will depend on number of files, changes, size etc. You can have as many backup jobs at different intervals as your system resources will allow but each backup job should be unique.

Due to the use of hard links SBU requires the destination file system to be Linux based but not the source directory. There is no GUI interface but there are plans for a web interface in the future. Encryption of destination directories are also planned for a future release.

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

SBU will prompt you to skip or install rsync. If you select y it will attempt to check for a redhat release and if not use apt-get to install rsync. If you get an error you can re run the install script without installing rsync and install it on your own. You will need to have rsync installed before using SBU.

# USAGE EXAMPLE
You can read full instructions by typing "sbu --help" at the command prompt. Usage is meant to be simple and straight forward, to create a job type: 
	
	sbu --create job-name --source /my/source/directory --dest /my/backup/directory --interval 30 --days-to-keep 30

NOTE: --interval is in minutes and --days-to-keep is in days. 
This will create a new directory for snapshots in /my/backup/directory/job-name/snapshots.
The initial full sync is named job-name.full, subsequent snapshots are named job-name.0, job-name.1, job-name.2, etc. The newest snapshot is always job-name.0, as snapshots reach the --days-to-keep limit they will be rolled into job-name.full. Each snapshot has a timestamp file and a snapshot-time file with the number of minutes the snapshot took to create.

# RESTORE SNAPSHOTS
Restoration tools are planned in the future but for now you can simply copy files from a snapshot directory to restore from SBU backups.

# RECONFIGURING JOBS
You can reconfigure some features of a running job, more are planned in the future.

Set autostart (default is on):
	
	sbu --autostart on/off --name job-name
	
Set full sync option (default is on):

	sbu --full-sync on/off --name job-name
		
You can also make changes to the config file for each job. Config files are located at /opt/sbu/jobs/job-name/job-name.conf. WARNING: This may have unpredictable results, use with caution. You should be able to change the Interval and Retention (days to keep) settings on running jobs, settings will take affect on the next interval. Changing source and destination directories will result in backup failures, a new job should be created to change these.

# REMOVING JOBS
You can remove jobs using (it will prompt to delete backup files): 

	sbu --remove job-name
	
To delete a job and backup files without prompting use:

	sbu --remove job-name --force-delete
	
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

# FULL SYNC MODE
By default FullSync is set to on. If this is turned off snapshot time may be decreased but SBU will not delete files that have been deleted at the source until the first snapshot done after midnight. This may not be desirable if it's important that deleted files are not restored in the event of a recovery. Deleted files will only be retained for a maximum of 1 day when FullSync is off, when FullSync is on deleted files at the source will be reflected in the next snapshot.
