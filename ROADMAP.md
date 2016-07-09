# SBU 0.3.5 Roadmap
- Optimize snapshot time by aborting the file change search and starting the sync as soon as changes are detected when full sync is set    to on. This may save time on snapshots when a temp snapshot has already been made.

- Fix a bug that reports jobs successfully created when destination storage is invalid and no job is created. Need to create better error    reporting.

- Add --clean feature to remove all files associated with a job when job is not properly created, to be used during testing.

- Change --force-delete option to just --force to be used with other option.
