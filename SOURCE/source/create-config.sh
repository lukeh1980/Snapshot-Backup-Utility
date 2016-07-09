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
echo "Retention="$DAYSTOKEEP >> /opt/sbu/jobs/$NAME/$NAME.conf
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