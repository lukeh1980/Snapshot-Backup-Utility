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

if [ ! -s "/opt/sbu/jobs/$NAME/$NAME-currently-taking-snapshot" ]; then

	echo $(date "+%Y-%m-%d %H:%M:%S") > /opt/sbu/jobs/$NAME/$NAME-currently-taking-snapshot
	echo "Snapshot started at: " $(date "+%Y-%m-%d %H:%M:%S") > /opt/sbu/jobs/$NAME/$NAME-last-snapshot-start-time
	echo $(date "+%Y-%m-%d %H:%M:%S")" - Creating snapshot: cp -rpl ${DEST}/$NAME/snapshots/$NAME.0 ${DEST}/$NAME/tmp/" >> /var/log/sbu/$NAME/sbulog

	if [ ! -d "${DEST}/$NAME/tmp/$NAME.0" ]; then
		STARTTIME=$(date +"%D %T")
		cp -rpl "${DEST}/$NAME/snapshots/$NAME.0" "${DEST}/$NAME/tmp/" 2>> /var/log/sbu/$NAME/sbulog
		rm -rf "${DEST}/$NAME/tmp/$NAME.0/snapshot-time"
		ENDTIME=$(date +"%D %T")
		#sleep 1
		MINUTES=$(( ( $(date -ud "$ENDTIME" +'%s') - $(date -ud "$STARTTIME" +'%s') )/60 ))
		#echo $MINUTES > ${DEST}/$NAME/tmp/$NAME.0/snapshot-time-$(date +"%Y%m%d%H%M%S")-$MINUTES
		echo $MINUTES > ${DEST}/$NAME/tmp/$NAME.0/snapshot-time
		echo $MINUTES > /opt/sbu/jobs/$NAME/$NAME-last-snapshot-time
	fi
	
	rm -rf /opt/sbu/jobs/$NAME/$NAME-currently-taking-snapshot
	
fi
