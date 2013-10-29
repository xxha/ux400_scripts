#!/bin/bash

retval=0
reveal_rootfs=/resv/v400/reveal_rootfs.log
echo "reveal rootfs log starts:" > ${reveal_rootfs}

# check priviledge
if [ "$UID" != "0" ]; then
        echo "Failed, Please run with root priviledge." >> ${reveal_rootfs}
        exit 1
fi

cd /

mount / -o remount,rw
sync
mount /usr/local -o remount,rw
sync

# remove old rootfs.md5
rm -rf /rootfs.md5

if [ -f /tmp/ux400-veex-rootfs-x86.tar.gz -a -f /tmp/ux400-veex-rootfs-x86.tar.gz.md5 ]; then
	mv /tmp/ux400-veex-rootfs-x86.tar.gz /
	mv /tmp/ux400-veex-rootfs-x86.tar.gz.md5 /
	sync
	md5sum -c ux400-veex-rootfs-x86.tar.gz.md5 >> ${reveal_rootfs}
	if [ $? -eq "0" ]; then
		tar xf ux400-veex-rootfs-x86.tar.gz -C /
		if [ $? -eq "0" ]; then
			echo "tar ux400 rootfs succeed." >> ${reveal_rootfs}
			if [ -f /rootfs.md5 ]; then
				#checksum rootfs
				md5sum -c rootfs.md5 > /dev/null 2>&1
				if [ $? -eq "0" ]; then
					echo "check md5sum succeed." >> ${reveal_rootfs}
					echo "ux400 rootfs upgrade succeed." >> ${reveal_rootfs}
				else
					echo "check md5sum failed" >> ${reveal_rootfs}
					mv /ux400-veex-rootfs-x86.tar.gz /tmp/
					mv /ux400-veex-rootfs-x86.tar.gz.md5 /tmp/
					retval=1
				fi
			else
				echo "no rootfs.md5 file, needn't check md5sum" >> ${reveal_rootfs}
				echo "ux400 rootfs upgrade succeed." >> ${reveal_rootfs}
			fi
		else
			echo "tar ux400-veex-rootfs-x86.tar.gz failed." >> ${reveal_rootfs}
			retval=1
		fi
	else 
		echo "ux400-veex-rootfs-x86.tar.gz is bad, please load it again." >> ${reveal_rootfs}
		retval=1
	fi
else
	echo "no ux400-veex-rootfs-x86.tar.gz or ux400-veex-rootfs-x86.tar.gz.md5 found under /tmp." >> ${reveal_rootfs}
fi

mv /ux400-veex-rootfs-x86.tar.gz /tmp/
mv /ux400-veex-rootfs-x86.tar.gz.md5 /tmp/

echo "retval = $retval" >> ${reveal_rootfs}
exit $retval
