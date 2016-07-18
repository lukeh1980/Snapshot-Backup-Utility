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
RETENTION=$5
AUTOSTART=$6
SETPERMS=$7
SETOWNER=$8
SETGROUP=$9

# Create config file:
echo "#### SNAPSHOT BACKUP UTILITY ####" > /opt/sbu/jobs/$NAME/$NAME.conf
echo "#################################" >> /opt/sbu/jobs/$NAME/$NAME.conf
echo "" >> /opt/sbu/jobs/$NAME/$NAME.conf

echo "# Backup name should be unique, changing this may disrupt the backup jobs. Backup names should be renamed using the --rename option." >> /opt/sbu/jobs/$NAME/$NAME.conf
echo "Name="$NAME >> /opt/sbu/jobs/$NAME/$NAME.conf
echo "" >> /opt/sbu/jobs/$NAME/$NAME.conf

echo "# Source directory should be in this format: /my/source/directory" >> /opt/sbu/jobs/$NAME/$NAME.conf
echo "Source="$SOURCE >> /opt/sbu/jobs/$NAME/$NAME.conf
echo "" >> /opt/sbu/jobs/$NAME/$NAME.conf

echo "# Destination should be in this format: /my/destination/directory" >> /opt/sbu/jobs/$NAME/$NAME.conf
echo "Dest="$DEST >> /opt/sbu/jobs/$NAME/$NAME.conf
echo "" >> /opt/sbu/jobs/$NAME/$NAME.conf

echo "# Interval is the number of minutes between snapshots, 60 minutes is the default." >> /opt/sbu/jobs/$NAME/$NAME.conf
echo "Interval="$INTERVAL >> /opt/sbu/jobs/$NAME/$NAME.conf
echo "" >> /opt/sbu/jobs/$NAME/$NAME.conf

echo "# Retention is the number of days to keep backup history, backups will be rolled into the full backup after this number of days, 30 days is the default." >> /opt/sbu/jobs/$NAME/$NAME.conf
echo "Retention="$RETENTION >> /opt/sbu/jobs/$NAME/$NAME.conf
echo "" >> /opt/sbu/jobs/$NAME/$NAME.conf

if [ -z "$AUTOSTART" ]; then
	AUTOSTART="on"
fi 

echo "# Autostart sets backup to start on bootup, default is on." >> /opt/sbu/jobs/$NAME/$NAME.conf
echo "Autostart="$AUTOSTART >> /opt/sbu/jobs/$NAME/$NAME.conf
echo "" >> /opt/sbu/jobs/$NAME/$NAME.conf

echo "# FullSync will check for deleted files each interval, this may cause snapshots to be slower on very large directories. If turned off SBU will delete files only at midnight." >> /opt/sbu/jobs/$NAME/$NAME.conf
echo "FullSync=on" >> /opt/sbu/jobs/$NAME/$NAME.conf
echo "" >> /opt/sbu/jobs/$NAME/$NAME.conf

if [ "$SETPERMS" != "no-perms" ]; then

	if [ "$SETPERMS" == "copy" ]; then
		echo "# Destination permissions are set here. If set to copy rsync will attempt to retain permissions, errors will show in the sbulog for the job." >> /opt/sbu/jobs/$NAME/$NAME.conf
		echo "# You may set numerical permissions here instead, all files for the job will inherit these permissions." >> /opt/sbu/jobs/$NAME/$NAME.conf
		echo "# If set to no-perms then rsync will not attempt to do anything with permissions and the destination will inherit permissions set by the storage device. Default setting is copy." >> /opt/sbu/jobs/$NAME/$NAME.conf
		echo "DestPerms=copy" >> /opt/sbu/jobs/$NAME/$NAME.conf
		echo "" >> /opt/sbu/jobs/$NAME/$NAME.conf
	else
		if [[ $SETPERMS -gt 0 ]]; then
			echo "# Destination permissions are set here. If set to copy rsync will attempt to retain permissions, errors will show in the sbulog for the job." >> /opt/sbu/jobs/$NAME/$NAME.conf
			echo "# You may set numerical permissions here instead, all files for the job will inherit these permissions." >> /opt/sbu/jobs/$NAME/$NAME.conf
			echo "# If set to no-perms then rsync will not attempt to do anything with permissions and the destination will inherit permissions set by the storage device. Default setting is copy." >> /opt/sbu/jobs/$NAME/$NAME.conf
			echo "DestPerms=$SETPERMS" >> /opt/sbu/jobs/$NAME/$NAME.conf
			echo "" >> /opt/sbu/jobs/$NAME/$NAME.conf
		else
			echo "# Destination permissions are set here. If set to copy rsync will attempt to retain permissions, errors will show in the sbulog for the job." >> /opt/sbu/jobs/$NAME/$NAME.conf
			echo "# You may set numerical permissions here instead, all files for the job will inherit these permissions." >> /opt/sbu/jobs/$NAME/$NAME.conf
			echo "# If set to no-perms then rsync will not attempt to do anything with permissions and the destination will inherit permissions set by the storage device. Default setting is copy." >> /opt/sbu/jobs/$NAME/$NAME.conf
			echo "DestPerms=copy" >> /opt/sbu/jobs/$NAME/$NAME.conf
			echo "" >> /opt/sbu/jobs/$NAME/$NAME.conf
		fi
	fi

	if [ "$SETOWNER" == "copy" ]; then
		echo "# Destination owner permissions are set here. If set to copy rsync will attempt to retain permissions, errors will show in the sbulog for the job. If DestPerms is set to no-perms or copy then Owner and Group settings are ignored." >> /opt/sbu/jobs/$NAME/$NAME.conf
		echo "DestOwner=copy" >> /opt/sbu/jobs/$NAME/$NAME.conf
		echo "" >> /opt/sbu/jobs/$NAME/$NAME.conf
	else
		echo "# Destination owner permissions are set here. If set to copy rsync will attempt to retain permissions, errors will show in the sbulog for the job. If DestPerms is set to no-perms or copy then Owner and Group settings are ignored." >> /opt/sbu/jobs/$NAME/$NAME.conf
		echo "DestOwner=$SETOWNER" >> /opt/sbu/jobs/$NAME/$NAME.conf
		echo "" >> /opt/sbu/jobs/$NAME/$NAME.conf
	fi

	if [ "$SETGROUP" == "copy" ]; then
		echo "# Destination group permissions are set here. If set to copy rsync will attempt to retain permissions, errors will show in the sbulog for the job. If DestPerms is set to no-perms or copy then Owner and Group settings are ignored." >> /opt/sbu/jobs/$NAME/$NAME.conf
		echo "DestGroup=copy" >> /opt/sbu/jobs/$NAME/$NAME.conf
		echo "" >> /opt/sbu/jobs/$NAME/$NAME.conf
	else
		echo "# Destination group permissions are set here. If set to copy rsync will attempt to retain permissions, errors will show in the sbulog for the job. If DestPerms is set to no-perms or copy then Owner and Group settings are ignored." >> /opt/sbu/jobs/$NAME/$NAME.conf
		echo "DestGroup=$SETGROUP" >> /opt/sbu/jobs/$NAME/$NAME.conf
		echo "" >> /opt/sbu/jobs/$NAME/$NAME.conf
	fi
	
else
	echo "# Destination permissions are set here. If set to copy rsync will attempt to retain permissions, errors will show in the sbulog for the job." >> /opt/sbu/jobs/$NAME/$NAME.conf
	echo "# You may set numerical permissions here instead, all files for the job will inherit these permissions." >> /opt/sbu/jobs/$NAME/$NAME.conf
	echo "# If set to no-perms then rsync will not attempt to do anything with permissions and the destination will inherit permissions set by the storage device." >> /opt/sbu/jobs/$NAME/$NAME.conf
	echo "DestPerms=no-perms" >> /opt/sbu/jobs/$NAME/$NAME.conf
	echo "" >> /opt/sbu/jobs/$NAME/$NAME.conf
	echo "# Destination owner permissions are set here. If set to copy rsync will attempt to retain permissions, errors will show in the sbulog for the job. If DestPerms is set to no-perms or copy then Owner and Group settings are ignored." >> /opt/sbu/jobs/$NAME/$NAME.conf
	echo "DestOwner=no-perms" >> /opt/sbu/jobs/$NAME/$NAME.conf
	echo "" >> /opt/sbu/jobs/$NAME/$NAME.conf
	echo "# Destination group permissions are set here. If set to copy rsync will attempt to retain permissions, errors will show in the sbulog for the job. If DestPerms is set to no-perms or copy then Owner and Group settings are ignored." >> /opt/sbu/jobs/$NAME/$NAME.conf
	echo "DestGroup=no-perms" >> /opt/sbu/jobs/$NAME/$NAME.conf
	echo "" >> /opt/sbu/jobs/$NAME/$NAME.conf
fi
