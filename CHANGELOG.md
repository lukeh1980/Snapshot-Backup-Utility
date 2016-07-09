# SBU 0.3.5 Change Log
- Improved error reporting when creating new jobs, fixed a bug that reported a job was successfully created when job creation failed.
- Job creation failures now clean up partially created job files so the job can be retried without further errors.
- Improved snapshot time by aborting the file change search as soon as a change is detected when full sync option is set to on.
