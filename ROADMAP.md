# SBU 0.3.5 Roadmap
- Optimize snapshot time by aborting the search and starting the sync as soon as changes are detected when full sync is set to on.
  This would save time on snapshots when a temp snapshot has already been made.

- Fix bug that reports jobs successfully created when destination storage is invalid and no job is created. Need to create better error    reporting.

- Add --clean feature to remove all files associated with a job when job is not properly created, to be used during testing.
