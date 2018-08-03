#!/bin/bash

		#5 minutes interval

		set(){
							 mail="MAILTO="
							 path="PATH=/sbin:/bin:/usr/sbin:/usr/bin"
               croncmd="/usr/bin/bash /usr/bin/automatic-backup.sh"
               cronjob="*/5 * * * * $croncmd"

	             s=$(service crond start)
               c=$(crontab -l | grep -v -F "$croncmd" ; echo -e "$mail\n$path\n$cronjob" | crontab - )

           }
	       set
				 echo -e "\e[4;32mUPDATING LOCAL FILE DATABASE..\e[0m"
		# Database backup to dump-backup folder
		pass="Toro_sysad1"
		backup=$(mysqldump -u root -p$pass --databases important_files > /opt/dump-backup/important_files.sql)

			$(tar cvf /opt/dump-backup.tar /opt/dump-backup) #Archive the folder dump-backup

			#backup
			setbackup(){
				#set dir with date and time stamp
				TIMEDATE=$(date +%b-%d-%Y-%T)

				#dir for the incremental backup
				mkdir -p /opt/incremental-backup/$TIMEDATE


				#incremental backup
				rsync -avr --numeric-ids /opt/dump-backup /opt/incremental-backup/$TIMEDATE
				#full backup
				rsync -avr /opt/dump-backup /opt/full-backup

		}
		echo -e "\e[0;32mUPDATED!\e[0m" "\n"
		#if db_backup was done
		if [ "$backup == 0" ]; then
			echo -e "\e[4;1;34mUPDATING BACKUP FOLDERS..\e[0m"
			setbackup #calls the backup
			#notif email
			echo -e "\e[1;34mUPDATED!\e[0m" "\n"
			echo -e "\e[1;33mSending email @gmail.com..\e[0m"
			sm=$(echo -e 'Subject: DB_Backup\n\nYour database have been backup successfully.' | ssmtp toro.exavierace.munar@gmail.com)
			echo -e "\e[1;33mSent!\e[0m" "\n"
		echo -e "The default schedule for the script to run is set to 5 minutes" "\n"

		setsched(){
			echo -e "\e[1;37mTASK SCHEDULER\e[0m"
			echo -e "\e[1;37m--------------\e[0m"
			echo "Set * for null. "
			read -p "(range: 0-59) Minute: " minute
			if ! [[("$minute" =~ ^[0-9]+$) || ("$minute" = "*")]]
			then
			echo "Sorry integers only"
			fi
			read -p "(range: 0-23) Hour: " hour
			if ! [[ ("$hour" =~ ^[0-9]+$ )|| ("$hour" = "*")]]
			then
			echo "Sorry integers only"
			fi
			read -p "(range: 1-31) Day of month: " dom
			if ! [[ ("$dom" =~ ^[0-9]+$)||( "$dom" = "*")]]
			then
			echo "Sorry integers only"
			fi
			read -p "(range: 1-12) Month: " month
			if ! [[( "$month" =~ ^[0-9]+$)||("$month" = "*")]]
			then
			echo "Sorry integers only"
			fi
			read -p "(range: 0-6, 0 standing for Sunday) Day of week: " dow
			if ! [[ ("$dow" =~ ^[0-9]+$ )|| ( "$dow" = "*")]]
			then
			echo "Sorry integers only"
			fi


			mail="MAILTO="
			path="PATH=/sbin:/bin:/usr/sbin:/usr/bin"
			croncmd="/usr/bin/bash /usr/bin/automatic-backup.sh"
			cronjob="$minute $hour $dom $month $dow $croncmd"

			s=$(service crond start)
			c=$(crontab -r | grep -v -F "$croncmd" ; echo -e "$mail\n$path\n$cronjob" | crontab - )
			echo -e "\e[1;37mUPDATED!\e[0m"
		}
		while true; do
    read -p "Do you wish to update the schedule? " yn
    case $yn in
        [Yy]* ) setsched; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
    done

		else
		echo "Failed."
		fi
