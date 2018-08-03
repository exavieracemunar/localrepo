#!/bin/bash

		#5 minutes interval

		set(){
	       mail="MAILTO="
	       path="PATH=/sbin:/bin:/usr/sbin:/usr/bin"
               croncmd="/usr/bin/bash /usr/bin/automatic-backup.sh"
               cronjob="*/5 * * * * $croncmd"

		# s=$(service crond start)
                c=$(crontab -l | grep -v -F "$croncmd" ; echo -e "$mail\n$path\n$cronjob" | crontab - )

           }
	set

	# Database backup to dump-backup folder
		pass="Toro_sysad1"
		backup=$(mysqldump -u root -p$pass --databases important_files > /opt/dump-backup/important_files.sql)

			$(tar cvf /opt/dump-backup.tar /opt/dump-backup) #Archive the folder dump-backup

			#backup
			setbackup(){
				#set dir with date and time stamp
				TIMEDATE=$(date +%b-%d-%Y-%T)

				#dir for the incremental backup
				mkdir -p $/opt/incremental-backup/$TIMEDATE


				#incremental backup
				rsync -avr --numeric-ids /opt/dump-backup /opt/incremental-backup/$TIMEDATE
				#full backup
				rsync -avr /opt/dump-backup /opt/full-backup

		}
	#if db_backup was done
	if [ "$backup == 0" ]; then
		setbackup #calls the backup
		#notif email
		sm=$(echo -e 'Subject: DB_Backup\n\nYour database have been backup successfully.' | ssmtp -v toro.exavierace.munar@gmail.com)

		 echo "Success."
	else
		echo "Failed."
	fi
