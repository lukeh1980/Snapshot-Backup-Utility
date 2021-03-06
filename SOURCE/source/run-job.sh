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

	if [ -s /opt/sbu/jobs/$NAME/$NAME-first-run-tasks.sh ]; then
		/opt/sbu/jobs/$NAME/$NAME-first-run-tasks.sh $NAME
	fi
	if [ -e /opt/sbu/jobs/$NAME/$NAME-currently-taking-snapshot ]; then
		rm -rf /opt/sbu/jobs/$NAME/$NAME-currently-taking-snapshot
	fi
	if [ -e /opt/sbu/jobs/$NAME/$NAME-searching ]; then
		rm -rf /opt/sbu/jobs/$NAME/$NAME-searching
	fi
	if [ -e /opt/sbu/jobs/$NAME/$NAME-syncing-changes ]; then
		rm -rf /opt/sbu/jobs/$NAME/$NAME-syncing-changes
	fi
	
	while :
	do	
		#clear
		echo ""
		echo "-------------Starting Initialized Backup-------------"
		echo ""
		# Load config:
		#source /opt/sbu/source/load-config.sh $NAME
		
		CURRINTERVAL=$INTERVAL
		
		# Need to check if /opt/sbu/jobs/$NAME/$NAME-currently-taking-snapshot exists, if so snapshot was interrupted, need to start it over.
		# Search for changes should fire off without having to check.
		
		# Start Check Time:
		CHECKSTARTTIME=$(date +"%D %T")
		# This may need to be moved to a better place, checks if snapshots have expired and need to be rolled up:
		if [ ! -s /opt/sbu/jobs/$NAME/$NAME-rolling-up-backup ]; then
			nohup /opt/sbu/source/snapshot-rollup.sh $NAME &>/dev/null &
		fi
		
		# Fire off creating a new snapshot in background:
		if [ ! -d "${DEST}/$NAME/tmp/$NAME.0" ]; then
			if [ ! -s /opt/sbu/jobs/$NAME/$NAME-currently-taking-snapshot ]; then
				nohup /opt/sbu/source/create-snapshot.sh $NAME &>/dev/null &
				sleep 1
			fi
		fi
				
		# Fire off search in background:
		if [ ! -s /opt/sbu/jobs/$NAME/$NAME-searching ]; then
			nohup /opt/sbu/source/search-for-changes.sh $NAME &>/dev/null &
			# Adding a sleep here allows the search-for-changes.sh file to create the nessisary files and start searching before it goes on checking below, removing this may make it miss searches.
			sleep 1
		fi
		
		# Wait for file search and snapshot to complete then rotate if changes have been found:
		while :
		do
			if [ -s /opt/sbu/jobs/$NAME/$NAME-searching ]; then
				echo "searching..."
				sleep .5
			else
				if [ -s /opt/sbu/jobs/$NAME/$NAME-currently-taking-snapshot ]; then
					echo "Taking snapshot..."
					sleep .5
				else
					echo "Done searching and taking snapshot.."
					echo "${DEST}/$NAME/tmp/$INTERVAL-min"
					if [ -s "${DEST}/$NAME/tmp/$INTERVAL-min" ]; then
						echo "Syncing Changes..."
						
						/opt/sbu/source/sync-changes.sh $NAME
						/opt/sbu/source/rotate-bu.sh $NAME
						
						CHECKENDTIME=$(date +"%D %T")
						CHECKMINUTES=$(( ( $(date -ud "$CHECKENDTIME" +'%s') - $(date -ud "$CHECKSTARTTIME" +'%s') )/60 ))
						rm -rf "${DEST}/$NAME/snapshots/$NAME.0/last-rotation-time"
						#echo $CHECKMINUTES > ${DEST}/$NAME/snapshots/$NAME.0/full-check-time-$(date +"%Y%m%d%H%M%S")-$CHECKMINUTES
						echo $CHECKMINUTES > ${DEST}/$NAME/snapshots/$NAME.0/last-rotation-time
						
						# Fire off creating a new snapshot in background:
						if [ ! -d "${DEST}/$NAME/tmp/$NAME.0" ]; then
							if [ ! -s /opt/sbu/jobs/$NAME/$NAME-currently-taking-snapshot ]; then
								nohup /opt/sbu/source/create-snapshot.sh $NAME &>/dev/null &
								sleep 1
							fi
						fi
						break
					else
						break
					fi
				fi
			fi
		done
		
		# Calculate remaining time until next check:
		if [ -s "${DEST}/$NAME/tmp/$INTERVAL-min" ]; then
			
			echo "Changes needed to be synced so remove $INTERVAL-min file and calculate remaining sleep time..."
			rm -rf "${DEST}/$NAME/tmp/$INTERVAL-min"
			# Calculate number of minutes remaining in interval:		
			CURRTIME=$(date +"%D %T")
			LASTFILESEARCH=$(tail -1 /opt/sbu/jobs/$NAME/$NAME-last-file-search)
			MINUTES=$(( ( $(date -ud "$CURRTIME" +'%s') - $(date -ud "$LASTFILESEARCH" +'%s') )/60 ))
			NEWINTERVAL=$(($CURRINTERVAL - $MINUTES))
			if [[ $NEWINTERVAL -lt 0 ]]
			then
				CURRINTERVAL=0
			else
				CURRINTERVAL=$NEWINTERVAL
			fi
		
		else
			echo "No changes found..."
			echo ""
		fi
				
		echo "-------------Snapshot Check Complete-------------"
		echo ""
		echo "Sleeping for "$(($CURRINTERVAL * 60))"..."
		echo $(date "+%Y-%m-%d %H:%M:%S") > /opt/sbu/jobs/$NAME/$NAME-going-to-sleep
		sleep $(($CURRINTERVAL * 60))

	done

else 
# REINITIALIZE BACKUP (if initialization did not finish last time job was started it will be reinitialized):
nohup /opt/sbu/source/reinitialize-job.sh $NAME &>/dev/null &
fi
