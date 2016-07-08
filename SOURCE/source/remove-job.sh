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

DELFILES=$2

echo ""
echo "-------REMOVING $NAME BACKUP JOB-------"
echo ""

if [ -s "/opt/sbu/source/autostart.sh" ]; then
	grep -v "/opt/sbu/sbu --start $NAME" /opt/sbu/source/autostart.sh > /opt/sbu/source/autostart.tmp; mv /opt/sbu/source/autostart.tmp /opt/sbu/source/autostart.sh 
	chmod a+x /opt/sbu/source/*
fi

if [ ! -d "/var/log/sbu/$NAME" ]; then
	echo "Log directory /var/log/sbu/$NAME does not exist..."
	exit
else
	rm -rf /var/log/sbu/$NAME
fi

if [ ! -d "/opt/sbu/jobs/$NAME" ]; then
	echo "Job directory /opt/sbu/jobs/"$NAME" does not exist..."
	exit
else
	rm -rf /opt/sbu/jobs/$NAME
fi

PID1=$(pgrep -f "/opt/sbu/source/create-new-job.sh ${SOURCE}")
PID2=$(pgrep -f "/opt/sbu/source/run-job.sh ${NAME}")

if [[ "$PID1" > 0 ]]; then
	kill $PID1
fi

if [[ "$PID2" > 0 ]]; then
	kill $PID2
fi

if [[ $DELFILES -eq 1 ]]; then

	if [ ! -d "${DEST}/$NAME" ]; then
		echo "Job snapshots not found..."
		exit
	else
		
		mv "${DEST}/$NAME" "${DEST}/.$NAME.deleting"
		
		# create delete queue file:
		echo "#!/bin/bash" > /opt/sbu/delqueue/$NAME-delfiles.sh
		echo "if [ ! -d \""${DEST}/.$NAME.deleting"\" ]; then" >> /opt/sbu/delqueue/$NAME-delfiles.sh
		echo "rm -rf /opt/sbu/delqueue/$NAME-delfiles.sh" >> /opt/sbu/delqueue/$NAME-delfiles.sh
		echo "else" >> /opt/sbu/delqueue/$NAME-delfiles.sh
		echo "nohup rm -rf ${DEST}/.$NAME.deleting &>/dev/null &" >> /opt/sbu/delqueue/$NAME-delfiles.sh
		echo "fi" >> /opt/sbu/delqueue/$NAME-delfiles.sh
		
		chmod a+x /opt/sbu/delqueue/*
		
		# fire off delete command:
		nohup rm -rf "${DEST}/.$NAME.deleting" &>/dev/null &
		
	fi
	
fi

echo "$NAME backup job removed!"