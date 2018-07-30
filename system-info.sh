#!/bin/bash

getmemused(){  #Method for computing the total memory used.
				AP=$(vm_stat -c 1 5 | awk '{print $14}'|sed -n '3,3p') #Formula for getting the total app memory
								 RES=$(echo "$AP*4096" | bc)

				WI=$(vm_stat -c 1 5| awk '{print $6}'|sed -n '3,3p')  #Formula for getting the total wired memory
								WRES=$(echo "$WI*4096" | bc)

				TOTAL=$(echo "$RES+$WRES" | bc )
				CV=$( echo "scale = 2;$TOTAL/1024/1024/1024"  | bc ) #Formula for getting the total memory used
				echo  Memory Used:$CV GB
	}
	echo "============================="
	echo "      System Infomation"
	echo "============================="
	echo Computer Name:"$(hostname -f)" #Hostname
	echo User Name:"$(id -u -n)" #usename
	echo Network Name:"$(networksetup -getairportnetwork en1 | cut -c 24-)" #networkname
	echo RAM:"$(System_profiler SPHardwareDataType | grep " Memory:" | awk '{print $2,$3,$4}')" #RAMInfo
	getmemused #method call for showing memory used
	echo Disk:"$(diskutil list| awk '{print $3,$4,$5,$6}' | sed -n '5,5p')" #Diskinfo
	echo Disk Usage:"$(df -Hl | awk '{print $3,"/",$2}' | sed -n '2,2p')" #Disk Usage info
	echo -n CPU:"$(System_profiler SPHardwareDataType | grep "Processor Name:"  | awk '{print $3,$4,$5}')" "" #Cpuinfo Name
	echo $(sysctl -n machdep.cpu.brand_string  | awk '{print $6}') #Cpuinfo Speed
	echo Cpu Usage:"$(ps -A -o %cpu | awk '{s+=$1} END {print s "%"}')" #Cpu Usage
	echo Top process: "$(ps aux | awk '{print $2,$11}' |head -n 2|sed -n '2,2p')" #HighestProcess
	echo "============================="
#Condition for terminating the process
	while true; do
    read -p "Do you wish to close the top process? " yn
	echo "============================="
    case $yn in
        [Yy]* ) $(ps aux | awk '{print $2}'| head -n 2 | sed -n '2,2p' | xargs kill); break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
