#!/bin/bash

#check priviledge
if [ "$UID" != "0" ]; then
        echo "Failed, Please run with root priviledge."
        exit 1
fi

cd /

mount / -o remount,rw
mount /usr/local -o remount,rw

cd /tmp/

if [ -f /tmp/ux400-veex-rootfs-x86.tar.gz -a -f /tmp/ux400-veex-rootfs-x86.tar.gz.md5 ]; then
	md5sum -c ux400-veex-rootfs-x86.tar.gz.md5
	if [ $? -eq "0" ]; then
		tar xf ux400-veex-rootfs-x86.tar.gz -C /
		if [ $? -eq "0" ]; then
			echo "upgrade ux400 rootfs succeed."
		else
			echo "tar ux400-veex-rootfs-x86.tar.gz failed."
		fi
	else 
		echo "ux400-veex-rootfs-x86.tar.gz is bad, please load it again."
	fi
else
	echo "no ux400-veex-rootfs-x86.tar.gz or ux400-veex-rootfs-x86.tar.gz.md5 found."
fi


