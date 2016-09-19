# SBU 0.4.4 Bug Fixes & Improvements
- Added better status reporting, will now show mutliple statuses for each job if the job is running multiple tasks.
- Improved snapshot information, will now log snapshot time, sync time, and full rotation time for each snapshot.
- Improved upgrade script to auto-restart jobs when they are idle (if the upgrade requires it).

# SBU 0.4.3 Bug Fixes & Improvements
- Added status checks to each task branch to prevent tasks from running over the top of each other.
- Added upgrade script for upgrading existing/running versions.

# SBU 0.4.2 Bug Fixes & Improvements
- Fixed bug that falsely reports changes when permissions are set to copy.
- improved rsync options array so whitespace will not generate errors.

# SBU 0.4.1 Bug Fixes & Improvements
- SBU now requires rsync 3.1.2 or higher to be installed.
- You can now set permissions of backups.
- Fixed bug in run-job.sh that sometimes doesn't catch changes and trigger a snapshot.

# SBU 0.3.6 Bug Fixes & Improvements
- Fixed bug in search-for-changes.sh that stops the search but doesn't start syncing changes.
- Updated --stop, --clean, and --remove functions to kill entire process tree then remove files.
- Optimized log output to not be so repetitive and "chatty"
- Added --set-interval function
- Added --set-retention function
- Renamed --days-to-keep to --retention
- Renamed --force-delete to --force to be used with other functions
