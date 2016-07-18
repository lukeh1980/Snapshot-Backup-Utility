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
