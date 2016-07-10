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

cd /opt/sbu/jobs
ls -v  > /opt/sbu/source/jobs-list

while read NAME
do

    echo "Checking "/opt/sbu/jobs/$NAME/$NAME.conf
	
	if [ -e "/opt/sbu/jobs/$NAME/$NAME.conf" ]; then

		FILE="/opt/sbu/jobs/$NAME/$NAME.conf"
		
		while read -r line
		do
			[[ $line = \#* ]] && continue
			
			if [[ $line == *"Name"* ]]; then
				NAME=$(echo "$line" | cut -d '=' -f 2)
			fi
			
			if [[ $line == *"Source"* ]]; then
				SOURCE=$(echo "$line" | cut -d '=' -f 2)
			fi
			
			if [[ $line == *"Dest"* ]]; then
				DEST=$(echo "$line" | cut -d '=' -f 2)
			fi
			
			if [[ $line == *"Interval"* ]]; then
				INTERVAL=$(echo "$line" | cut -d '=' -f 2)
			fi
			
			if [[ $line == *"Retention"* ]]; then
				RETENTION=$(echo "$line" | cut -d '=' -f 2)
			fi
			
			if [[ $line == *"Autostart"* ]]; then
				AUTOSTART=$(echo "$line" | cut -d '=' -f 2)
			fi
			
			if [[ $line == *"FullSync"* ]]; then
				FULLSYNC=$(echo "$line" | cut -d '=' -f 2)
			fi
			
		done < "$FILE"

	else 
		echo "Could not find config file!"
		exit
	fi
	
	if [ "$AUTOSTART" == "off" ]; then
		echo "Setting $NAME autostart to off."
		sed -i -e 's/Autostart on/Autostart off/g' /opt/sbu/jobs/$NAME/$NAME.conf
		grep -v "/opt/sbu/sbu --start $NAME" /opt/sbu/source/autostart.sh > /opt/sbu/source/autostart.tmp; mv /opt/sbu/source/autostart.tmp /opt/sbu/source/autostart.sh
		chmod a+x /opt/sbu/source/*
		exit
	fi 
	
	if [ "$AUTOSTART" == "on" ]; then
		echo "Setting $NAME autostart to on."
		sed -i -e 's/Autostart off/Autostart on/g' /opt/sbu/jobs/$NAME/$NAME.conf
		grep -v "/opt/sbu/sbu --start $NAME" /opt/sbu/source/autostart.sh > /opt/sbu/source/autostart.tmp; mv /opt/sbu/source/autostart.tmp /opt/sbu/source/autostart.sh
		echo "/opt/sbu/sbu --start $NAME" >> /opt/sbu/source/autostart.sh
		chmod a+x /opt/sbu/source/*
		exit
	fi
	
done < /opt/sbu/source/jobs-list
