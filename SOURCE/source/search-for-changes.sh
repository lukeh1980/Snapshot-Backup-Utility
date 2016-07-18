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

#MINUTES=$(($INTERVAL))
echo $(date "+%Y-%m-%d %H:%M:%S") > /opt/sbu/jobs/$NAME/$NAME-searching
echo $(date "+%Y-%m-%d %H:%M:%S") > /opt/sbu/jobs/$NAME/$NAME-last-file-search

NEWSOURCE="${SOURCE}/"
NEWDEST="${DEST}/$NAME/snapshots/$NAME.0${SOURCE}/"
FILEDEST="${DEST}/$NAME/tmp/$INTERVAL-min"

if [ "$FULLSYNC" == "on" ]; then
	echo $(date "+%Y-%m-%d %H:%M:%S")" - Starting Search: rsync -rltDn --delete --out-format=\"%f\" ${NEWSOURCE} ${NEWDEST}" >> /var/log/sbu/$NAME/sbulog
	echo "Starting Search..."
	RSYNCSTARTED=0
	nohup rsync -rltDn --delete --out-format="%f" "${NEWSOURCE}" "${NEWDEST}" > "${FILEDEST}" 2> /dev/null &
	#sleep 1
	while :
	do	
		PID=$(pgrep -f "rsync -rltDn --delete --out-format=%f ${NEWSOURCE} ${NEWDEST}")
		if [ -n "$PID" ]; then
			if [[ "$PID" > 0 ]]; then
				RSYNCSTARTED=1
				if [ -s "${FILEDEST}" ]; then
					echo "----------------Stopping Search"
					PID=$(pgrep -f "rsync -rltDn --delete --out-format=%f ${NEWSOURCE} ${NEWDEST}")
					if [[ "$PID" > 0 ]]; then
						echo "Killing "$PID
						echo "-------"
						/usr/bin/kill -SIGKILL $PID
					fi
					rm -rf /opt/sbu/jobs/$NAME/$NAME-searching
					break
				fi
			fi
			sleep 0.1
		else
			sleep 0.1
		fi
		if [[ $RSYNCSTARTED -gt 0 ]]; then
			PID=$(pgrep -f "rsync -rltDn --delete --out-format=%f ${NEWSOURCE} ${NEWDEST}")
			if [ ! -n "$PID" ]; then
				# Rsync has started and stopped:
				# Assume the search started and finished:
				echo "STOPPING SEARCH"
				rm -rf /opt/sbu/jobs/$NAME/$NAME-searching
				break
			fi
		fi
	done
	
else
	echo $(date "+%Y-%m-%d %H:%M:%S")" - Full Sync Off, Starting Search: rsync -rltDn --out-format=\"%f\" ${NEWSOURCE} ${NEWDEST}" >> /var/log/sbu/$NAME/sbulog
	rsync -rltDn --out-format="%f" "${NEWSOURCE}" "${NEWDEST}" > "${FILEDEST}"
	grep -v "${SOURCE:1}/\." "${FILEDEST}" > "${FILEDEST}.tmp"; mv "${FILEDEST}.tmp" "${FILEDEST}"
	rm -rf /opt/sbu/jobs/$NAME/$NAME-searching
fi
