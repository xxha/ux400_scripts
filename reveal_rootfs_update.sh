#!/bin/bash

retval=0

# check priviledge
if [ "$UID" != "0" ]; then
        echo "Failed, Please run with root priviledge."
        exit 1
fi

cd /

mount / -o remount,rw
mount /usr/local -o remount,rw
sync

# remove old rootfs.md5
rm -rf /rootfs.md5

if [ -f /tmp/ux400-veex-rootfs-x86.tar.gz -a -f /tmp/ux400-veex-rootfs-x86.tar.gz.md5 ]; then
	mv /tmp/ux400-veex-rootfs-x86.tar.gz /
	mv /tmp/ux400-veex-rootfs-x86.tar.gz.md5 /
	sync
	md5sum -c ux400-veex-rootfs-x86.tar.gz.md5
	if [ $? -eq "0" ]; then
		tar xf ux400-veex-rootfs-x86.tar.gz -C /
		if [ $? -eq "0" ]; then
			echo "tar ux400 rootfs succeed."
			if [ -f /rootfs.md5 ]; then
				#checksum rootfs
				md5sum -c rootfs.md5 > /dev/null 2>&1
				if [ $? -eq "0" ]; then
					echo "check md5sum succeed."
					echo "ux400 rootfs upgrade succeed."
				else
					echo "check md5sum failed"
					mv /ux400-veex-rootfs-x86.tar.gz /tmp/
					mv /ux400-veex-rootfs-x86.tar.gz.md5 /tmp/
					retval=1
				fi
			else
				echo "no rootfs.md5 file, needn't check md5sum"
				echo "ux400 rootfs upgrade succeed."
			fi
		else
			echo "tar ux400-veex-rootfs-x86.tar.gz failed."
			retval=1
		fi
	else 
		echo "ux400-veex-rootfs-x86.tar.gz is bad, please load it again."
		retval=1
	fi
else
	echo "no ux400-veex-rootfs-x86.tar.gz or ux400-veex-rootfs-x86.tar.gz.md5 found under /tmp."
fi

mv /ux400-veex-rootfs-x86.tar.gz /tmp/
mv /ux400-veex-rootfs-x86.tar.gz.md5 /tmp/

return $retval
