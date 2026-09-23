# SBU 0.5.0 Data Safety Fixes, Distribution rsync & Cleanup

Changes since 0.4.5. Existing 0.4.5 backups and job configs are used as they are.

## Data safety
- Change detection no longer writes into the newest snapshot. Snapshot history is no longer rewritten, and deleted files are recorded in the next snapshot.
- Snapshots keep symlinks as symlinks instead of copying what they point to.
- FullSync=off jobs capture changes during the day again (they were written to a nested path and only corrected by the nightly full sync).
- Jobs created without `--retention` or `--interval` get the documented defaults (30 days, 60 minutes). Previously the settings shifted into the wrong config keys and no snapshot history was kept.

## Job management
- `--stop` stops the whole job, including a running rsync, and no longer needs psmisc (`pstree`). Stopping job `web` no longer affects job `web2`.
- `--clean` stops a running job before removing it.
- Changing a job's interval no longer stops it from taking snapshots.
- Config values containing `=` are read in full, and config edits are written atomically.
- `--force`, `--version`, `--no-perms` and `--help` no longer swallow the next argument. `--help` works without `less`.
- `sbu --create` warns about a non-numeric `--set-perms` or a `--set-owner` / `--set-group` given without the other.

## Installation & upgrade
- rsync (3.1.2 or later) comes from the distribution's package manager (apt, dnf, yum, zypper, pacman) instead of being compiled from source. SBU finds it on the PATH.
- New bundle sbu-0.5.0-install.tar. upgrade-sbu.sh upgrades an existing installation in place: it waits for each job to be idle, backs up /opt/sbu, leaves backups and configs untouched, replaces the compiled rsync with the distribution's, and restarts the jobs. Supports `--check` and `--rollback`.

## Removed
- `--stop --soft` (never worked), `restart-on-idle.sh`, `check-config.sh`, `load-config.sh`, the unused "rotating backup" status and the undocumented `<job>-first-run-tasks.sh` hook.

## Documentation
- usage.txt lists `--dest` (not `--destination`) and documents `--name`, `--show-config` and `--clean`.

## Known limitations (unchanged from 0.4.5)
- A permission or ownership change alone does not trigger a snapshot; it is applied with the next content change. Because unchanged files are hard links shared between snapshots, it also changes that file's permissions/ownership in older snapshots. File contents are not affected.
- Job names that are prefixes of other job names (`web`, `web2`) can confuse `--start` and `--status`.

# SBU 0.4.5 Installation Bug Fixes & Added Compatibility with SystemD Unit Files
- Installation script now detects CentOS/RHEL 6/7 and Ubuntu 16/17 distributions and installs all required dependencies. 
- Installation script creates unit file for SystemD on CentOS/RHEL 7 or Ubuntu 16/17 servers, no need to do it manually.
- Manual installation instructions for other distributions were added to INSTALL.txt.
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
