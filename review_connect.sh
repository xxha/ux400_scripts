#! /bin/bash

PROGRAM="softupdate"

while true ; do
	PRO_NOW=`ps aux | grep $PROGRAM | grep -v grep | wc -l`
	if [ $PRO_NOW -lt 1 ]; then
		(/usr/local/v300/sbin/softupdate ux400 &)
		echo "softupdate restart 1"
	fi

	PRO_STAT=`ps aux|grep $PROGRAM |grep T|grep -v grep|wc -l`
	if [ $PRO_STAT -gt 0 ]; then
		killall -9 $PROGRAM
		sleep 2
		(/usr/local/v300/sbin/softupdate ux400 &)
		echo "softupdate restart 2"
	fi
	sleep 10
done
