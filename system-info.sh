#!/bin/bash
	  MUL=4096
        getmemused(){
                AP=$(vm_stat -c 1 5 | awk '{print $14}'|sed -n '3,3p')
                         RES=$(echo "$AP*$MUL" | bc)

                WI=$(vm_stat -c 1 5| awk '{print $6}'|sed -n '3,3p')
                        WRES=$(echo "$WI*$MUL" | bc)

                TOTAL=$(echo "$RES+$WRES" | bc )
                CV=$( echo "scale = 2;$TOTAL/1024/1024/1024"  | bc )
                echo  Memory Used:$CV GB
        }

        	


	echo Computer Name:"$(hostname -f)"
	echo User Name:"$(id -u -n)"
	echo Network Name:"$(networksetup -getairportnetwork en1 | cut -c 24-)" 
	echo RAM:"$(System_profiler SPHardwareDataType | grep " Memory:" | awk '{print $2,$3,$4}')"
	getmemused 
	echo Disk:"$(diskutil list| awk '{print $3,$4,$5,$6}' | sed -n '5,5p')"
	echo Disk Usage:"$(df -Hl | awk '{print $3,"/",$2}' | sed -n '2,2p')"
	echo CPU:"$(System_profiler SPHardwareDataType | grep "Processor Name:" | awk '{print $3,$4,$5}')"
	echo Cpu Usage:"$(ps -A -o %cpu | awk '{s+=$1} END {print s "%"}')"
	echo Top process"(PID)": "$(ps aux | awk '{print $2}' |head -n 2|sed -n '2,2p')"
		 

