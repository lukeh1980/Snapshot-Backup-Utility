# KNOWN ISSUES
- When --interval or --retention flags are not set jobs are not created properly.
- snapshot-time is not reported correctly.
- Testing snapshots older than the retention policy has not been done, need to keep at least one snapshot.
- Jobs fail to reinitialize when interrupted.
- Jobs may get "stuck" on syncing or creating a snapshot if interrupted when not idle.

# ENHANCEMENTS
- Logging may be reworked ouput sync errors into one file for easier troubleshooting. 
- Log rotation should be implemented.
- Add upgrade feature.
- Add --soft feature to wait until a job is idle before stopping or restarting.
- Ability to create job groups in order to manage large sets of jobs.
