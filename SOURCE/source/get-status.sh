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

#$1 backup name
NAME=$1

if [ -z "$NAME" ]; then
	# No job name used, get all jobs:
	if [ "$(ls -A /opt/sbu/jobs/)" ]; then
		#echo "Jobs Exist!"
		cd /opt/sbu/jobs
		for d in * ; do
			if [[ $(checkStatus $d) -gt 0 ]]; then
				echo $(getCurrentStatus $d)
			else
				echo "$d is stopped"
			fi
		done
		# List jobs:
	else
		echo "No jobs found!"
		exit
	fi
else
	if [ -s "/opt/sbu/jobs/$NAME/$NAME.conf" ]; then
		# Job exists:
		if [[ $(checkStatus $NAME) -gt 0 ]]; then
			echo $(getCurrentStatus $NAME)
		else
			echo "$NAME is stopped"
		fi
	else
		echo "$NAME does not exist!"
		exit
	fi
fi