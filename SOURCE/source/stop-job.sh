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

# The job name is the argument, not the config's Name= value, so a job whose config
# is already gone can still be stopped.
NAME=$1

# kill_tree PID
#
# Signal PID and every descendant. Each process is frozen before its children
# are collected so it cannot start new ones mid-walk. Killing only direct
# children left the rsync started by sync-changes.sh / search-for-changes.sh
# running after "stopped", still writing into the snapshot being built.
# SIGTERM lets rsync remove its temporary files before it exits.
function kill_tree {
	local pid=$1 child
	kill -STOP "$pid" 2>/dev/null
	for child in $(pgrep -P "$pid"); do
		kill_tree "$child"
	done
	kill -TERM "$pid" 2>/dev/null
	kill -CONT "$pid" 2>/dev/null
}

if [[ $(checkStatus $NAME) -gt 0 ]]; then

	# Anchored so that stopping job "web" can never match job "web2".
	PID1=$(pgrep -f "/opt/sbu/source/create-new-job.sh ${SOURCE} ")
	PID2=$(pgrep -f "/opt/sbu/source/run-job.sh ${NAME}\$")

	for PID in $PID1; do
		kill_tree "$PID"
	done

	if [[ -n "$PID2" ]]; then
		for PID in $PID2; do
			kill_tree "$PID"
		done

		# Let the tree exit before clearing its state files.
		for i in 1 2 3 4 5 6 7 8 9 10; do
			pgrep -f "/opt/sbu/source/run-job.sh ${NAME}\$" >/dev/null || break
			sleep 0.5
		done
		
		if [ -e "${DEST}/$NAME/tmp/$NAME-changes" ]; then
			rm -rf "${DEST}/$NAME/tmp/$NAME-changes"
		fi
		
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
	/opt/sbu/sbu --status "$NAME"
else
	echo "$NAME is already stopped"
fi
