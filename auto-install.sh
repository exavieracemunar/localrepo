#!/bin/bash
# Description: Performs backup every 5 minutes and notify via gmail
# Author: SysAdTrainee (toro.exavierace.munar@gmail.com)
# Checking services
 service_checker(){
  if pgrep -c crond > /dev/null;then
   echo "[ INFO ] crond is running."
  else
   echo "[ INFO ] Starting crond service."
   service crond start
  fi
  if pgrep -c mysqld > /dev/null;then
   echo "[ INFO ] mysqld is running."
  else
   echo "[ INFO ] Starting mysqld service."
   service mysqld start
  fi
 }
# Database backup to dump-backup folder
 mysqldump -u important_files> /opt/dump-backup/important_files-date +%b-%d-%Y-%k:%M.sql
 tar cvf /opt/dump-backup.tar /opt/dump-backup
# Backup db to folders
 mkdir -p /opt/incremental-backup/date +%b-%d-%Y-%T
 rsync -ah /opt/dump-backup /opt/incremental-backup/date +%b-%d-%Y-%T
 rsync -ah /opt/dump-backup /opt/full-backup
# Email notification via gmail
 echo -e 'Subject: DB_Backup\n\nYour database have been backup successfully.' | ssmtp mexavierace@gmail.com
# Cron set job schedule
 set(){
  path="PATH=/sbin:/bin:/usr/sbin:/usr/bin"
  croncmd="/usr/bin/bash /usr/bin/automatic-backup.sh"
  cronjob="*/5 * * * * $croncmd"
  service_checker
  crontab -l | grep -v -F "$croncmd" ; echo -e "$path\n$cronjob" | crontab -
 }
