# KNOWN ISSUES
- When --interval or --retention flags are not set jobs are not created properly.
- Jobs fail to reinitialize when interrupted.
- "sbu --status job-name" does not show the status of single jobs only "sbu --status" shows status of all jobs.

# ENHANCEMENTS
- Log rotation should be implemented.
- Add --soft feature to wait until a job is idle before stopping or restarting.
- Ability to create job groups in order to manage large sets of jobs.
- Add stop/start/restart all jobs feature.
