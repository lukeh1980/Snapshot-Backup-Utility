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

echo "Creating $DEST/$NAME/tmp/.$NAME.snapshot..."
echo $(date "+%Y-%m-%d %H:%M:%S")" - Creating temporary snapshot directory" >> /var/log/sbu/$NAME/sbulog
mkdir -p "${DEST}/$NAME/tmp/.$NAME.snapshot"

cd "${DEST}/$NAME/snapshots/$NAME.0"

echo "Snapshot started at: " $(date "+%Y-%m-%d %H:%M:%S") > /opt/sbu/jobs/$NAME/$NAME-last-snapshot-start-time
echo $(date "+%Y-%m-%d %H:%M:%S")" - Creating snapshot: cp -rpl ./ ${DEST}/$NAME/tmp/.$NAME.snapshot/" >> /var/log/sbu/$NAME/sbulog
cp -rpl ./ "${DEST}/$NAME/tmp/.$NAME.snapshot/"

rm -rf /opt/sbu/jobs/$NAME/$NAME-currently-taking-snapshot
