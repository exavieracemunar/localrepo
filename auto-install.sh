# !/bin/bash
# Description: Performs backup every 5 minutes and notify via gmail
# Author: SysAdTrainee (toro.exavierace.munar@gmail.com)
# Database backup to dump-backup folder
 backup=$(mysqldump -u important_files> /opt/dump-backup/important_files-$(date +%b-%d-%Y-%k:%M).sql))
 $(tar cvf /opt/dump-backup.tar /opt/dump-backup)
# Backup db to folders
 if [ "$backup == 0" ]; then
   TIMEDATE=$(date +%b-%d-%Y-%T)
   mkdir -p /opt/incremental-backup/$TIMEDATE
   rsync -ah /opt/dump-backup /opt/incremental-backup/$TIMEDATE
   rsync -ah /opt/dump-backup /opt/full-backup
# Email notification via gmail
   $(echo -e 'Subject: DB_Backup\n\nYour database have been backup successfully.' | ssmtp mexavierace@gmail.com)
 fi
# Checking services
 service_checker(){
   echo -e "\e[1;37mCHECKING SERVICES & SCHEDULES\e[0m"
   if [[ $(ps -ef | grep -v grep | grep crond | wc -l) > 0 ]];then
     printf "crond...[%s]\n" "running"
   else
     $(service crond start)
   fi
   if [[ $(ps -ef | grep -v grep | grep mysqld | wc -l) > 0 ]];then
    printf "mysqld...[%s]\n" "running"
   else
     $(service mysqld start)
   fi
 }
# Cron set job schedule
set(){
  path="PATH=/sbin:/bin:/usr/sbin:/usr/bin"
  croncmd="/usr/bin/bash /usr/bin/automatic-backup.sh"
  cronjob="*/5 * * * * $croncmd"
  service_checker
  $(crontab -l | grep -v -F "$croncmd" ; echo -e "$path\n$cronjob" | crontab - )
}
