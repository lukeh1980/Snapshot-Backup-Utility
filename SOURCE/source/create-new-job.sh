#!/bin/bash
### --------------------------------- ###
###     Copyright 2016 Luke Higgs     ###
### Contact: admin@aquariandesign.com ###
### --------------------------------- ###

# This file is part of SBU (Snapshot Backup Utility)

# SBU is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.

# SBU is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with SBU (located in /opt/sbu/docs/COPYING).  If not, see <http://www.gnu.org/licenses/>.
#################################################################################################

SOURCE=$1
DEST=$2
NAME=$3
INTERVAL=$4
DAYSTOKEEP=$5
AUTOSTART=$6
MARG=1

# /opt/sbu/source/create-new-job.sh /extdata/source /extdata/dest my-backup 1 1 on

# Create log file entries in /var/log:
if [ ! -d "/var/log/sbu/$NAME" ]; then
	mkdir -p /var/log/sbu/$NAME
	echo "------------Creating new backup job for $NAME------------" >> /var/log/sbu/$NAME/sbulog
else
	echo "ERROR CREATING JOB: /var/log/sbu/$NAME already exists! If you feel this is in error run \"sbu --clean $NAME\" to remove old job information then try again." >> /var/log/sbu/$NAME-job-creation-error
	exit
fi

# Start creating new job:
if [ ! -d "/opt/sbu/jobs/$NAME" ]; then
	
	echo "Creating jobs folder for $NAME..."
	mkdir -p "/opt/sbu/jobs/$NAME" >> /var/log/sbu/$NAME/sbulog
	echo $(date "+%Y-%m-%d %H:%M:%S")" - Creating jobs folder in /opt/sbu for $NAME" >> /var/log/sbu/$NAME/sbulog
	
	if [ ! -d "/opt/sbu/jobs/$NAME" ]; then
		echo $(date "+%Y-%m-%d %H:%M:%S")" - ERROR: Could not create jobs folder!" >> /var/log/sbu/$NAME/sbulog
		echo "ERROR: Could not create jobs folder!" >> /var/log/sbu/$NAME-job-creation-error
		exit
	fi
	
	# Create config file for new job:
	echo "Creating config file for $NAME..."
	echo $(date "+%Y-%m-%d %H:%M:%S")" - Creating config file for $NAME" >> /var/log/sbu/$NAME/sbulog
	/opt/sbu/source/create-config.sh "${SOURCE}" "${DEST}" $NAME $INTERVAL $DAYSTOKEEP $AUTOSTART $MARG
	
	if [ ! -s "/opt/sbu/jobs/$NAME/$NAME.conf" ]; then
		echo $(date "+%Y-%m-%d %H:%M:%S")" - ERROR: Could not create configuration file!" >> /var/log/sbu/$NAME/sbulog
		echo "ERROR: Could not create configuration file!" >> /var/log/sbu/$NAME-job-creation-error
		exit
	fi
else
	echo "ERROR: $NAME already exists! If this is in error try running \"sbu --clean $NAME\" to remove job information and try again." >> /var/log/sbu/$NAME-job-creation-error
	echo $(date "+%Y-%m-%d %H:%M:%S")" - ERROR: $NAME already exists!" >> /var/log/sbu/$NAME/sbulog
	exit
fi

# Check source and destination directories:
if [ ! -d "${SOURCE}" ]; then
	echo "ERROR: $SOURCE is invalid"
	echo $(date "+%Y-%m-%d %H:%M:%S")" - ERROR: $SOURCE is invalid" >> /var/log/sbu/$NAME/sbulog
	echo "ERROR: $SOURCE is invalid" >> /var/log/sbu/$NAME-job-creation-error
	exit
fi
	
if [ ! -d "${DEST}" ]; then
	echo "ERROR: $DEST is invalid"
	echo $(date "+%Y-%m-%d %H:%M:%S")" - ERROR: $DEST is invalid" >> /var/log/sbu/$NAME/sbulog
	echo "ERROR: $DEST is invalid" >> /var/log/sbu/$NAME-job-creation-error
	exit
fi

if [ -z "$INTERVAL" ]; then
	echo "Using default snapshot rotation of 60 minutes..."
	INTERVAL=60
fi

echo "Setting snapshot policy to $INTERVAL minutes..."
echo $(date "+%Y-%m-%d %H:%M:%S")" - Using a snapshot rotation of $INTERVAL minutes" >> /var/log/sbu/$NAME/sbulog

if [ -z "$DAYSTOKEEP" ]; then
	echo "Using default retention of 30 days..."
	DAYSTOKEEP=30
fi

echo "Setting retention policy to $DAYSTOKEEP days..."
echo $(date "+%Y-%m-%d %H:%M:%S")" - Using retention policy of $DAYSTOKEEP days" >> /var/log/sbu/$NAME/sbulog

echo $(date "+%Y-%m-%d %H:%M:%S") > /opt/sbu/jobs/$NAME/$NAME-initializing
INITIALIZED=0

if [ $INITIALIZED -eq 0 ] 
then
	echo ""
	echo "--------STARTING BACKUP INITIALIZATION--------"
	echo ""
	
	echo $(date "+%Y-%m-%d %H:%M:%S")" - Initializing $NAME" >> /var/log/sbu/$NAME/sbulog
	echo "Initializing $NAME..."
	echo ""
	
	if [[ $AUTOSTART == "on" ]]; then
		echo "Creating autostart script for $NAME..."
		echo $(date "+%Y-%m-%d %H:%M:%S")" - Adding $NAME to autostart" >> /var/log/sbu/$NAME/sbulog
		grep -v "/opt/sbu/sbu --start $NAME" /opt/sbu/source/autostart.sh > /opt/sbu/source/autostart.tmp; mv /opt/sbu/source/autostart.tmp /opt/sbu/source/autostart.sh
		echo "/opt/sbu/sbu --start $NAME" >> /opt/sbu/source/autostart.sh
		chmod a+x /opt/sbu/source/*
	fi
	
	# Create destination folder:
	if [ ! -d "${DEST}/$NAME/snapshots" ]; then
		# Create snapshots directory:
		echo "Creating directory: $DEST/$NAME/tmp"
		echo $(date "+%Y-%m-%d %H:%M:%S")" - Creating directory: mkdir -p ${DEST}/$NAME/tmp" >> /var/log/sbu/$NAME/sbulog
		mkdir -p "${DEST}/$NAME/tmp" >> /var/log/sbu/$NAME/sbulog 2>&1
		
		# Create snapshots directory:
		echo "Creating directory: $DEST/$NAME/snapshots"
		echo $(date "+%Y-%m-%d %H:%M:%S")" - Creating directory: $DEST/$NAME/snapshots" >> /var/log/sbu/$NAME/sbulog
		mkdir -p "${DEST}/$NAME/snapshots" >> /var/log/sbu/$NAME/sbulog 2>&1
		
		# Create first snapshot directory:
		echo "Creating directory: $DEST/$NAME/snapshots/$NAME.0"
		echo $(date "+%Y-%m-%d %H:%M:%S")" - Creating directory: $DEST/$NAME/snapshots/$NAME.0" >> /var/log/sbu/$NAME/sbulog
		mkdir -p "${DEST}/$NAME/snapshots/$NAME.0" >> /var/log/sbu/$NAME/sbulog 2>&1
		
		# Create full directory:
		echo "Creating directory: $DEST/$NAME/snapshots/$NAME.full"
		echo $(date "+%Y-%m-%d %H:%M:%S")" - Creating directory: $DEST/$NAME/snapshots/$NAME.full" >> /var/log/sbu/$NAME/sbulog
		mkdir -p "${DEST}/$NAME/snapshots/$NAME.full" >> /var/log/sbu/$NAME/sbulog 2>&1
		
		# Need to create source directory inside each backup & snapshot directory:
		echo "Creating directory: $DEST/$NAME/snapshots/$NAME.full$SOURCE"
		echo $(date "+%Y-%m-%d %H:%M:%S")" - Creating directory: $DEST/$NAME/snapshots/$NAME.full$SOURCE" >> /var/log/sbu/$NAME/sbulog
		mkdir -p "${DEST}/$NAME/snapshots/$NAME.full${SOURCE}" >> /var/log/sbu/$NAME/sbulog 2>&1
		
		if [ ! -d "${DEST}/$NAME/snapshots/$NAME.full${SOURCE}" ]; then
			echo $(date "+%Y-%m-%d %H:%M:%S")" - ERROR: Could not create snapshot directories: ${DEST}/$NAME/snapshots/$NAME.full${SOURCE}" >> /var/log/sbu/$NAME/sbulog
			echo "ERROR: Could not create snapshot directories: ${DEST}/$NAME/snapshots/$NAME.full${SOURCE}" >> /var/log/sbu/$NAME-job-creation-error
			exit
		fi
	else
		echo $(date "+%Y-%m-%d %H:%M:%S")" - ERROR: Cannot create destination snapshots folder. Please check destination and permissions of folder." >> /var/log/sbu/$NAME/sbulog
		echo "ERROR: Cannot create destination snapshots folder. Please check destination and permissions of folder." >> /var/log/sbu/$NAME-job-creation-error
		exit
	fi
	
	FULLDEST="${DEST}/$NAME/snapshots/$NAME.full"
	
	echo "STARTING SYNC"
	echo "Syncing source and destination directories: $SOURCE/ $FULLDEST$SOURCE/"
	echo $(date "+%Y-%m-%d %H:%M:%S")" - Syncing source and destination directories: $SOURCE/ $FULLDEST$SOURCE/" >> /var/log/sbu/$NAME/sbulog
	rsync -rltD -e \""ssh -T -c arcfour -o Compression=no -x"\" "${SOURCE}/" "${FULLDEST}${SOURCE}/" 2>> /var/log/sbu/$NAME/sbulog
	echo ""
	echo "Setting timestamp of full backup..."
	echo $(date "+%Y-%m-%d %H:%M:%S")" - Setting timestamp of full backup" >> /var/log/sbu/$NAME/sbulog
	echo $(date "+%Y-%m-%d %H:%M:%S") > "${FULLDEST}/timestamp"
	
	# This sets the full sync date. To save sync time a full sync is done once a night. This results in deleted files remaining in the backup for up to a day.
	# Only changes are sync'd when snapshots are created, this cleans deleted files from midnight or next created snapshot. 
	echo "Logging full sync timestamp..."
	echo $(date "+%Y-%m-%d %H:%M:%S")" - Logging full sync timestamp" >> /var/log/sbu/$NAME/sbulog
	echo $(date +"%D") 00:00:00 > /opt/sbu/jobs/$NAME/$NAME-last-full-sync
	echo ""
	
	# Creating our first hard link snapshot into the .0 folder:
	echo "Changing directory to $FULLDEST"
	cd "${FULLDEST}"
	echo "Copying hard links of full backup into first iteration..."
	echo $(date "+%Y-%m-%d %H:%M:%S")" - Copying hard links of full backup into first iteration" >> /var/log/sbu/$NAME/sbulog
	cp -rlp ./ "${DEST}/$NAME/snapshots/$NAME.0/"
	
	# We log the timestamp of the new snapshot after it is complete:
	echo "Setting snapshot timestamp..."
	echo $(date "+%Y-%m-%d %H:%M:%S")" - Logging timestamp of first snapshot" >> /var/log/sbu/$NAME/sbulog
	echo $(date "+%Y-%m-%d %H:%M:%S") > "${DEST}/$NAME/snapshots/$NAME.0/timestamp"
	
	echo $(date "+%Y-%m-%d %H:%M:%S")" - $INTERVAL Minute Interval Backup for $NAME Initialized" >> /var/log/sbu/$NAME/sbulog
	echo $(date "+%Y-%m-%d %H:%M:%S")" - Starting job" >> /var/log/sbu/$NAME/sbulog
	
	if [ -s "${FULLDEST}/timestamp" ]; then
		CREATIONERROR=0
	else 
		CREATIONERROR=1
	fi
	
	if [ -s "/opt/sbu/jobs/$NAME/$NAME-last-full-sync" ]; then
		CREATIONERROR=0
	else
		CREATIONERROR=1
	fi
	
	if [ -s "${DEST}/$NAME/snapshots/$NAME.0/timestamp" ]; then
		CREATIONERROR=0
	else
		CREATIONERROR=1
	fi
	
	if [[ $CREATIONERROR -eq 0 ]]; then
		rm -rf /opt/sbu/jobs/$NAME/$NAME-initializing
		nohup /opt/sbu/source/run-job.sh $NAME &>/dev/null &
	else
		echo $(date "+%Y-%m-%d %H:%M:%S")" - ERROR 159: Could not initialize $NAME!" >> /var/log/sbu/$NAME/sbulog
		exit
	fi
	
	echo "------------------------------" >> /var/log/sbu/$NAME/sbulog
	exit
	
fi
