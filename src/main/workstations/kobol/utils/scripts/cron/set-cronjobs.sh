#!/bin/bash
# @file set-cronjobs.sh
# @brief Set cronjobs for current user.
#
# @description The script configures a bunch of cronjobs for the crontab of the current user.
#
# ==== Arguments
#
# The script does not accept any parameters.


# Delete users crontab
echo -e "$LOG_INFO Clear crontab (removed all entries) for $USER"
crontab -r

JOBS_PATH="$HOME/work/repos/sebastian-sommerfeld-io/infrastructure/src/main/workstations/kobol/utils/scripts/cron/jobs"
cronjobs=(
  "0 11 * * * $JOBS_PATH/backup-ssh-keys.sh" # Each day at 11:00am
  "0 * * * * $JOBS_PATH/cleanup-filesystem.sh" # Each hour at minute 0
)

# Add all jobs to crontab
for job in "${cronjobs[@]}"
do
  echo -e "$LOG_INFO Add cronjob -> $job"
  (crontab -u "$USER" -l ; echo "$job") | crontab -u "$USER" -
done

echo -e "$LOG_DONE Added cron jobs"
