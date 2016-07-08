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

NAME=$1

echo "-----CLEANING FILES ASSOCIATED WITH $NAME-----"

PID1=$(pgrep -f "/opt/sbu/source/create-new-job.sh $SOURCE")
PID2=$(pgrep -f "/opt/sbu/source/run-job.sh $NAME")

if [[ "$PID1" > 0 ]]; then
	kill $PID1
fi

if [[ "$PID2" > 0 ]]; then
	kill $PID2
fi

rm -rf /var/log/sbu/$NAME
rm -rf /opt/sbu/jobs/$NAME
grep -v "/opt/sbu/sbu --start $NAME" /opt/sbu/source/autostart.sh > /opt/sbu/source/autostart.tmp; mv /opt/sbu/source/autostart.tmp /opt/sbu/source/autostart.sh 
chmod a+x /opt/sbu/source/*