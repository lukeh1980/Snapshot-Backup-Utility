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

MINUTES=$(($INTERVAL))

echo $(date "+%Y-%m-%d %H:%M:%S") > /opt/sbu/jobs/$NAME/$NAME-last-file-search

NEWSOURCE="${SOURCE}/"
NEWDEST="${DEST}/$NAME/snapshots/$NAME.0${SOURCE}/"
FILEDEST="${DEST}/$NAME/tmp/$INTERVAL-min"

if [ "$FULLSYNC" == "on" ]; then

	nohup rsync -rltDn --delete --out-format="%f" "${NEWSOURCE}" "${NEWDEST}" > "${FILEDEST}" 2> /dev/null &
	
	while :
	do
		PID=$(pgrep -f "rsync -rltDn --delete --out-format="%f" ${NEWSOURCE} ${NEWDEST}")
		if [[ "$PID" > 0 ]]; then
			# If $FILEDEST has a size greater than 0 then a change was detected, kill the rsync search and go onto to doing a full sync:
			if [ -s "${FILEDEST}" ]; then
				kill $PID3
				rm -rf /opt/sbu/jobs/$NAME/$NAME-searching
				exit
			fi
		else
			rm -rf /opt/sbu/jobs/$NAME/$NAME-searching
			exit
		fi
		sleep 1
	done
	
else
	rsync -rltDn --out-format="%f" "${NEWSOURCE}" "${NEWDEST}" > "${FILEDEST}"
	grep -v "${SOURCE:1}/\." "${FILEDEST}" > "${FILEDEST}.tmp"; mv "${FILEDEST}.tmp" "${FILEDEST}"
	#find "${FILEDEST}" -type f -print -exec cat {} \; | grep deleting > "${DEST}/$NAME/tmp/delete-check"
	rm -rf /opt/sbu/jobs/$NAME/$NAME-searching
fi