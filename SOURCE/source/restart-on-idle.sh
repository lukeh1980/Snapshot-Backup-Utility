#!/bin/bash
if [ "$(ls -A /opt/sbu/jobs/)" ]; then
	clear				
	cd /opt/sbu/jobs
					
	for d in * ; do
					
		i=1

		while [ $i -eq 1 ]
		do
								
			CURRSTATUS=$(/opt/sbu/sbu --status $d)
								
			if [ "$CURRSTATUS" == "$d - idle" ]; then
				#/opt/sbu/sbu --start $d
				echo $d" is restarting"
				/opt/sbu/sbu --restart $d
				i=0
				#exit
			else
				echo "$CURRSTATUS"
				sleep .5
				clear
				echo "$CURRSTATUS...waiting"
				sleep .5
				clear
			fi
			
			if [ "$CURRSTATUS" == "$d idle" ]; then
				#/opt/sbu/sbu --start $d
				echo $d" is restarting"
				/opt/sbu/sbu --restart $d
				i=0
				#exit
			else
				echo "$CURRSTATUS"
				sleep .5
				clear
				echo "$CURRSTATUS...waiting"
				sleep .5
				clear
			fi
							
		done
	
	done
	
else
	echo "No jobs found!"
	exit
fi
