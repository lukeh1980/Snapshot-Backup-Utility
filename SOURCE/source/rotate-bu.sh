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

clear
echo "-------------Starting Rotate-BU Script-------------"
echo ""

if [ -s "${DEST}/$NAME/tmp/$INTERVAL-min" ]; then
	
	CHECKSTARTTIME=$(date +"%D %T")
	
	INCREMENT=()
	DIR="${DEST}/$NAME/snapshots/"

	echo "Changing directory to "$DIR
	cd "${DIR}"
	echo ""
	echo "Getting list of rotated snapshots..."
	echo $(date "+%Y-%m-%d %H:%M:%S")" - Rotating Snapshots" >> /var/log/sbu/$NAME/sbulog
	ls -v | grep -v '\.full$' | grep -v 'full-backup.index' | grep -v 'timestamp-full-backup' > "${DEST}/$NAME/tmp/$NAME-dir-list"
	
	INCREMENT=$(tail -n 1 "${DEST}/$NAME/tmp/$NAME-dir-list" | cut -d '.' -f 2)

	while [ $INCREMENT -gt -1 ]; do
		
		if [ $INCREMENT -gt 0 ]; then
			#echo $(date "+%Y-%m-%d %H:%M:%S")" - Moving $DIR$NAME.$INCREMENT to $DIR$NAME.$((INCREMENT+1))" >> /var/log/sbu/$NAME/sbulog
			mv "${DIR}$NAME.$INCREMENT" "${DIR}$NAME.$((INCREMENT+1))"
			let "INCREMENT--"
		else
			#echo $(date "+%Y-%m-%d %H:%M:%S")" - Moving $DIR$NAME.$INCREMENT to $DIR$NAME.$((INCREMENT+1))" >> /var/log/sbu/$NAME/sbulog
			mv "${DIR}$NAME.$INCREMENT" "${DIR}$NAME.$((INCREMENT+1))"
			#echo $(date "+%Y-%m-%d %H:%M:%S")" - Moving $DEST/$NAME/tmp/.$NAME.snapshot to $DIR$NAME.$INCREMENT" >> /var/log/sbu/$NAME/sbulog
			mv "${DEST}/$NAME/tmp/$NAME.0" "${DIR}$NAME.$INCREMENT"
			
			echo "Updating timestamp in latest snapshot..."
			rm -rf "${DEST}/$NAME/snapshots/$NAME.0/timestamp"
			#echo $(date "+%Y-%m-%d %H:%M:%S") > "${DEST}/$NAME/snapshots/$NAME.0/timestamp-"$(date +"%Y%m%d%H%M%S")
			echo $(date "+%Y-%m-%d %H:%M:%S") > "${DEST}/$NAME/snapshots/$NAME.0/timestamp"
			
			let "INCREMENT--"
		fi
		
	done

	rm -rf "${DEST}/$NAME/tmp/$NAME-dir-list"
	
	CHECKENDTIME=$(date +"%D %T")
	CHECKMINUTES=$(( ( $(date -ud "$CHECKENDTIME" +'%s') - $(date -ud "$CHECKSTARTTIME" +'%s') )/60 ))
	#rm -rf "${DEST}/$NAME/snapshots/$NAME.0/rotation-time-*"
	#echo $CHECKMINUTES > ${DEST}/$NAME/snapshots/$NAME.0/rotation-time-$(date +"%Y%m%d%H%M%S")-$CHECKMINUTES
						
	echo ""
	echo "-------------END Rotate-BU Script-------------"
	echo ""

fi
