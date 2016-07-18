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

# To help speed up snapshots it only syncs changed files leaving deleted files intact, once a day we do another rsync to clean out delete files from new snapshot:
CURRTIME=$(date +"%D %T")
LASTFULL=$(tail -1 /opt/sbu/jobs/$NAME/$NAME-last-full-sync)
NUMDAYS=$(( ( $(date -ud "$CURRTIME" +'%s') - $(date -ud "$LASTFULL" +'%s') )/60/60/24 ))
FILESFROM="${DEST}/$NAME/tmp/$INTERVAL-min"

# GET PERMISSION SETTINGS:
if [ "$SETPERMS" == "copy" ]; then
	PERMS=" --perms "		
else
	if [[ $SETPERMS -gt 0 ]]; then
		PERMS=" --chmod=$SETPERMS -og"
	else
		PERMS=" --perms "
	fi
fi
	
GROUPCOPY=""; OWNERCOPY=""; OWNER=0; GROUP=0
	
if [ "$SETGROUP" == "copy" ]; then
	GROUPCOPY=" -g "	
else
	GROUP=$SETGROUP
fi
	
if [ "$SETOWNER" == "copy" ]; then
	OWNERCOPY=" -o "	
else
	OWNER=$SETOWNER
fi
	
CHOWN=""
	
if [ "$GROUPCOPY" == "" ];then
		
	if [[ $OWNER -ne 0 ]]; then
		if [[ $GROUP -ne 0 ]]; then
			CHOWN="--chown=$OWNER:$GROUP"
		fi
	fi
	
fi
	
if [ "$SETPERMS" == "no-perms" ]; then
		PERMS=""
		CHOWN=""
		GROUPCOPY=""
		OWNERCOPY=""
fi

echo $GROUPCOPY$OWNERCOPY$PERMS$CHOWN

# Do a full sync (removes deleted files) if one day has passed since last full sync:
if [[ $NUMDAYS -gt 0 ]]; then
	echo "Starting full sync..."
	echo $(date "+%Y-%m-%d %H:%M:%S")" -------STARTING RSYNC (DELETE FLAG)-------" >> /var/log/sbu/$NAME/sbulog
	echo $(date "+%Y-%m-%d %H:%M:%S")" - Starting full sync: rsync -rltD $GROUPCOPY$OWNERCOPY$PERMS$CHOWN --delete ${SOURCE}/ ${DEST}/$NAME/tmp/.$NAME.snapshot${SOURCE}/" >> /var/log/sbu/$NAME/sbulog
	echo $(date "+%Y-%m-%d %H:%M:%S") > /opt/sbu/jobs/$NAME/$NAME-syncing-changes
	rsync -rltD $GROUPCOPY$OWNERCOPY$PERMS$CHOWN --delete "${SOURCE}/" "${DEST}/$NAME/tmp/.$NAME.snapshot${SOURCE}/" 2>> /var/log/sbu/$NAME/sbulog
	
	echo $(date +"%D") 00:00:00 > /opt/sbu/jobs/$NAME/$NAME-last-full-sync
	rm -rf /opt/sbu/jobs/$NAME/$NAME-syncing-changes
else
	if [ "$FULLSYNC" == "on" ]; then
		# If full sync is on then the $FILESFROM will only be a partial list of changes since it's not used.
		echo "Starting full sync..."
		echo $(date "+%Y-%m-%d %H:%M:%S")" -------STARTING RSYNC (DELETE FLAG)-------" >> /var/log/sbu/$NAME/sbulog
		echo $(date "+%Y-%m-%d %H:%M:%S")" - Starting full sync: rsync -rltD $GROUPCOPY$OWNERCOPY$PERMS$CHOWN --delete ${SOURCE}/ ${DEST}/$NAME/tmp/.$NAME.snapshot${SOURCE}/" >> /var/log/sbu/$NAME/sbulog
		echo $(date "+%Y-%m-%d %H:%M:%S") > /opt/sbu/jobs/$NAME/$NAME-syncing-changes
		
		rsync -rltD $GROUPCOPY$OWNERCOPY$PERMS$CHOWN --delete "${SOURCE}/" "${DEST}/$NAME/tmp/.$NAME.snapshot${SOURCE}/" 2>> /var/log/sbu/$NAME/sbulog
		
		echo $(date +"%D") 00:00:00 > /opt/sbu/jobs/$NAME/$NAME-last-full-sync
		rm -rf /opt/sbu/jobs/$NAME/$NAME-syncing-changes
	else
		echo "Syncing changed files only..."
		echo $(date "+%Y-%m-%d %H:%M:%S")" -------STARTING RSYNC (CHANGES ONLY)-------" >> /var/log/sbu/$NAME/sbulog
		echo $(date "+%Y-%m-%d %H:%M:%S")" - Starting full sync: rsync -rltD $GROUPCOPY$OWNERCOPY$PERMS$CHOWN --files-from=${FILESFROM} / ${DEST}/$NAME/tmp/.$NAME.snapshot${SOURCE}/" >> /var/log/sbu/$NAME/sbulog
		echo $(date "+%Y-%m-%d %H:%M:%S") > /opt/sbu/jobs/$NAME/$NAME-syncing-changes
		
		rsync -rltD $GROUPCOPY$OWNERCOPY$PERMS$CHOWN --files-from="${FILESFROM}" / "${DEST}/$NAME/tmp/.$NAME.snapshot${SOURCE}/"
		
		rm -rf /opt/sbu/jobs/$NAME/$NAME-syncing-changes
	fi
fi
