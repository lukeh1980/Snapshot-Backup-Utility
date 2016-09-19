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

source /opt/sbu/source/header

NEWSOURCE=$SOURCE
NEWDEST=$DEST
NEWNAME=$NAME
NEWINTERVAL=$INTERVAL
NEWRETENTION=$RETENTION
NEWSETPERMS=$SETPERMS
NEWSETOWNER=$SETOWNER
NEWSETGROUP=$SETGROUP
NEWEXCLUDEFILE=$EXCLUDEFILE

echo ""
echo "--------STARTING BACKUP INITIALIZATION--------"
echo ""

echo $(date "+%Y-%m-%d %H:%M:%S")" - Re-Initializing $NAME" >> /var/log/sbu/$NAME/sbulog
echo "Re-Initializing $NAME..."
echo ""

/opt/sbu/sbu --remove $NAME --force
sleep 1

/opt/sbu/sbu --create $NEWNAME --source "${NEWSOURCE}" --dest "${NEWDEST}" --interval $NEWINTERVAL --retention $NEWRETENTION --set-perms $NEWSETPERMS --set-owner $NEWSETOWNER --set-group $NEWSETGROUP --exclude-file $NEWEXCLUDEFILE
