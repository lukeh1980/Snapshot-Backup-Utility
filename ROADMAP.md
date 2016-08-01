# KNOWN ISSUES
- When --interval or --retention flags are not set jobs are not created properly.
- snapshot-time is not reported correctly.
- Testing snapshots older than the retention policy has not been done, need to keep at least one snapshot.

# ENHANCEMENTS
- Logging should be reworked to combine all jobs into one file.
- Log rotation should be implemented.
- Ability to create job groups in order to manage large sets of jobs.
