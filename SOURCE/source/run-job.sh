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

if [ ! -s /opt/sbu/jobs/$NAME/$NAME-initializing ]; then
	
	while :
	do	
		clear
		echo ""
		echo "-------------Starting Initialized Backup-------------"
		echo ""
		
		# Update config variables to avoid having to restart for some changes:
		/opt/sbu/source/check-config.sh	
		
		# Fire off creating a new snapshot in background:
		if [ ! -d "${DEST}/$NAME/tmp/.$NAME.snapshot" ]; then
			echo $(date "+%Y-%m-%d %H:%M:%S") > /opt/sbu/jobs/$NAME/$NAME-currently-taking-snapshot
			nohup /opt/sbu/source/create-snapshot.sh $NAME &>/dev/null &
		fi
			
		echo "Searching for changed files..."
		echo ""
				
		# Fire off search in background:
		echo $(date "+%Y-%m-%d %H:%M:%S") > /opt/sbu/jobs/$NAME/$NAME-searching
		echo $(date "+%Y-%m-%d %H:%M:%S")" - Searching for changes" >> /var/log/sbu/$NAME/sbulog
		nohup /opt/sbu/source/search-for-changes.sh $NAME &>/dev/null &
		
		# This may need to be moved to a better place, checks if snapshots have expired and need to be rolled up:
		/opt/sbu/source/snapshot-rollup.sh $NAME
		
		# Wait for file search and snapshot to complete then rotate if changes have been found:
		while :
		do
			if [ -s /opt/sbu/jobs/$NAME/$NAME-searching ]; then
				echo "searching..."
				sleep 1
			else
				if [ -s /opt/sbu/jobs/$NAME/$NAME-currently-taking-snapshot ]; then
					echo "Taking snapshot..."
					sleep 1
				else
					echo "Search and snapshot are complete..."
					sleep 1
					if [ -s "${DEST}/$NAME/tmp/$INTERVAL-min" ]; then
						echo "Rotating backups..."
						/opt/sbu/source/rotate-bu.sh $NAME
						/opt/sbu/source/sync-changes.sh $NAME
					fi
					break
				fi
			fi
		done
		
		# Check if changes have been found and sync them:
		if [ -s "${DEST}/$NAME/tmp/$INTERVAL-min" ]; then
			rm -rf "${DEST}/$NAME/tmp/$INTERVAL-min"		
			echo "Updating timestamp in latest snapshot..."
			rm -rf "${DEST}/$NAME/snapshots/$NAME.0/timestamp"
			echo $(date "+%Y-%m-%d %H:%M:%S") > "${DEST}/$NAME/snapshots/$NAME.0/timestamp"
					
			# Calculate number of minutes remaining in interval:
					
			CURRTIME=$(date +"%D %T")
			LASTFILESEARCH=$(tail -1 /opt/sbu/jobs/$NAME/$NAME-last-file-search)
			MINUTES=$(( ( $(date -ud "$CURRTIME" +'%s') - $(date -ud "$LASTFILESEARCH" +'%s') )/60 ))
			echo $MINUTES > "${DEST}/$NAME/snapshots/$NAME.0/snapshot-time"
			NEWINTERVAL=$(($INTERVAL - $MINUTES))
			if [[ $NEWINTERVAL -lt 0 ]]
			then
				INTERVAL=0
			else
				INTERVAL=$NEWINTERVAL
			fi
		
		else
			echo "No changes found..."
			echo ""
		fi
				
		echo "-------------Snapshot Check Complete-------------"
		echo ""
		echo "Sleeping for "$(($INTERVAL * 60))"..."
		sleep $(($INTERVAL * 60))

	done

else 
# REINITIALIZE BACKUP (if initialization did not finish last time job was started it will be reinitialized):
/opt/sbu/source/reinitialize-job.sh $NAME
fi
