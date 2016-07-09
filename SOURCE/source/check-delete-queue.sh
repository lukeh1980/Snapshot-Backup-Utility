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

# Loop through delqueue for delete scripts. 
# When directories or files are marked to delete a "queue" file is created so the delete will continue if interrupted. 
# Files in the queue will delete themselves when the delete is finished.

for QUEUE in /opt/sbu/delqueue/*
do
	if [ -f $QUEUE -a -x $QUEUE ]; then
		
		# execute the file in directory:
		$QUEUE
		
	fi
done
