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

INCREMENT=()
DIR="${DEST}/$NAME/snapshots/"

cd "${DIR}"
echo ""
echo "------STARTING SNAPSHOT ROLLUP-----"
ls -v | grep -v '\.full$' | grep -v 'full-backup.index' | grep -v 'timestamp-full-backup' > "${DEST}/$NAME/tmp/$NAME-dir-list-rollup"
INCREMENT=$(tail -n 1 "${DEST}/$NAME/tmp/$NAME-dir-list-rollup" | cut -d '.' -f 2)

#echo "Getting timestamp of last snapshot..."
TIMESTAMP=$(tail -1 "${DIR}$NAME.$INCREMENT/timestamp")
NOW=$(date "+%Y-%m-%d %H:%M:%S")

# Get seconds of timestamp and now:
TIMESTAMP=$(date -d "$TIMESTAMP" +"%s")
NOW=$(date -d "$NOW" +"%s")

DIFF="$((NOW - TIMESTAMP))"

RETENTION=$((86400 * $RETENTION))

if [ $DIFF -gt $RETENTION ]; then

	echo "Rolling up backup..."
	echo $(date "+%Y-%m-%d %H:%M:%S")" - Rolling up backup: rsync -rltD ${DIR}$NAME.$INCREMENT/ ${DIR}$NAME.full/" >> /var/log/sbu/$NAME/sbulog
	rsync -rltD "${DIR}$NAME.$INCREMENT/" "${DIR}$NAME.full/" 2>> /var/log/sbu/$NAME/sbulog
	
	#mv "${DIR}$NAME.full/timestamp" "${DIR}$NAME.full/timestamp-full-backup"
	mv "${DIR}$NAME.$INCREMENT" "${DEST}/$NAME/tmp/.$NAME.$INCREMENT.deleting"
	rm -rf "${DIR}$NAME.full/snapshot-time"
		
	# create delete queue file:
	echo "#!/bin/bash" > /opt/sbu/delqueue/$NAME.$INCREMENT-snapshot-delfiles.sh
	echo "if [ ! -d \"${DEST}/$NAME/tmp/.$NAME.$INCREMENT.deleting\" ]; then" >> /opt/sbu/delqueue/$NAME.$INCREMENT-snapshot-delfiles.sh
	echo "rm -rf /opt/sbu/delqueue/$NAME.$INCREMENT-snapshot-delfiles.sh" >> /opt/sbu/delqueue/$NAME.$INCREMENT-snapshot-delfiles.sh
	echo "else" >> /opt/sbu/delqueue/$NAME.$INCREMENT-snapshot-delfiles.sh
	echo "nohup rm -rf \"${DEST}/$NAME/tmp/.$NAME.$INCREMENT.deleting\" &>/dev/null &" >> /opt/sbu/delqueue/$NAME.$INCREMENT-snapshot-delfiles.sh
	echo "fi" >> /opt/sbu/delqueue/$NAME.$INCREMENT-snapshot-delfiles.sh
		
	chmod a+x /opt/sbu/delqueue/*
		
	# fire off delete command:
	nohup rm -rf "${DEST}/$NAME/tmp/.$NAME.$INCREMENT.deleting" &>/dev/null &
	
fi

rm -rf "${DEST}/$NAME/tmp/$NAME-dir-list-rollup"

echo ""
echo "------SNAPSHOT ROLLUP CHECK COMPLETE-----"
echo ""