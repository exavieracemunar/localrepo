#./bin/bash

	echo Computer Name:"$(hostname -f)"
	echo User Name:"$(id -u -n)"
	echo Network Name:"$(networksetup -getairportnetwork en1 | cut -c 24-)" 
	echo RAM:"$(hostinfo | grep memory)"
	echo Memory Usage:"$(top -l 1 | grep PhysMem:)" 
	echo Disk:"$(diskutil list)"
	echo Disk Usage:"$(df | awk '/ \/$/{print "HDD "$5}')"
	echo CPU:"$(sysctl -n machdep.cpu.brand_string)"
	echo Cpu Usage:"$(iostat -n cpu)"

	while true; do
    read -p "Do you wish to show top processes?" yn
    case $yn in
        [Yy]* ) top -n 10; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
		 

