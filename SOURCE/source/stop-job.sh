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

source /opt/sbu/source/functions
source /opt/sbu/source/header

if [[ $(checkStatus $NAME) -gt 0 ]]; then

	PID1=$(pgrep -f "/opt/sbu/source/create-new-job.sh ${SOURCE}")
	PID2=$(pgrep -f "/opt/sbu/source/run-job.sh $NAME")

	if [[ "$PID1" > 0 ]]; then
		PTREE=$(pstree -p $PID1)
		PIDS=$(echo $PTREE | awk -vRS=")" -vFS="(" '{print $2}')
		kill -SIGKILL $PIDS
	fi

	if [[ "$PID2" > 0 ]]; then
		PTREE=$(pstree -p $PID2)
		PIDS=$(echo $PTREE | awk -vRS=")" -vFS="(" '{print $2}')
		kill -SIGKILL $PIDS
		
		if [ -e /opt/sbu/jobs/$NAME/$NAME-searching ]; then
			rm -rf /opt/sbu/jobs/$NAME/$NAME-searching
		fi
		
		if [ -e /opt/sbu/jobs/$NAME/$NAME-currently-taking-snapshot ]; then
			rm -rf /opt/sbu/jobs/$NAME/$NAME-currently-taking-snapshot
		fi
		
		if [ -e /opt/sbu/jobs/$NAME/$NAME-syncing-changes ]; then
			rm -rf /opt/sbu/jobs/$NAME/$NAME-syncing-changes
		fi
		
	fi
	sbu --status $NAME
else
	echo "$NAME is already stopped"
fi
