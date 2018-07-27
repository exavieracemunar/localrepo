#./bin/bash

	echo Computer Name:"$(hostname -f)"
	echo User Name:"$(id -u -n)"
	echo Network Name:"$(networksetup -getairportnetwork en1 | cut -c 24-)" 
	echo RAM:"$(hostinfo | grep memory)"
	echo Memory Usage:"$(top -l 1 | grep PhysMem:)" 
	echo Disk:"$(diskutil list| awk '{print $3,$4}' | sed -n '5,5p')"
	echo Disk Usage:
	echo "$(df -Hl | awk '{print $2,$3,$4}')"
	echo CPU:"$(sysctl -n machdep.cpu.brand_string)"
	echo Cpu Usage:"$(ps -A -o %cpu | awk '{s+=$1} END {print s "%"}')"
	echo Top process:
	echo "$(ps aux | awk '{print $2,$11,$12}' |head -n 2)"
		 

