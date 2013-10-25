#!/bin/bash

########################## tools related ##########################

# bucheck: 
#	check if subboard need to be updated.

# mtype:
#	return the type of subboard.

# mdevcheck:
# 	return the usb device number of specific location.

# modud:
#	open ud service on subboard for ux400 client access.
# 	parameters:  1. target IP 2. source IP 3. port number.

# client:
#	subboard upgrade routine.

########################## variables ##############################

# for mtype
UNKNOW=0
UX400_10G=1
UX400_100GE=2
UX400_2P5G=3
UX400_40G=4
UX400_1GE=5
UX400_40GE=6
UX400_16G=7

# for mdevcheck 
USB0=1
USB1=2
USB2=3
USB3=4
USB4=5
USB5=6

USB0_5=(1 2 3 4 5 6)
slot_arr=("LA" "LB" "LC" "RA" "RB" "RC")

udport=8030
DELAY_SD=20

export ifupgrade=0
uret=0

display_dev=/dev/tty7
clear > ${display_dev}
/sbin/ux400cset

echo -e '\033[9;0]' > ${display_dev}

########################### functions ##############################

# check if it's a usb device
function isusb()
{
	local var
	for var in "${@:2}"; do
		[[ "$var" == "$1" ]] && return 0
	done
	return 1
}

# subboard upgrade routine
# parameter:
#	slot location
# return value:
# 	0: needn't upgrade
#	1: upgrade succeed
#	2, 3: upgrade failed
function mupgrade()
{
	/sbin/ux400cset

	#check specified subboard need upgrade or not.
	bucheck $1
	local update="$?"
	echo -ne "    \r" > ${display_dev}
	if [ $update -eq 0 ]; then
		#check specified subboard sd card need upgrade or not.
		local sdup="0"
		if [ -f /resv/v400/$1sdup.log ]; then
			grep -r "SUCCESS" /resv/v400/$1sdup.log
			sdup="$?"
		fi
		if [ $sdup -eq 0 ]; then
			return 0
		else
			echo "$1: SD card need upgrade" > ${display_dev}
		fi
	fi

	#get subboard type
	mtype $1
	local machine="$?"
	local imagename=""
	local machinename=""
	local boardname=""

	rm -rf /resv/v400/ux400-module-sd.tar.gz
	#determine variable name from subboard type
	if [ "$machine" == "$UX400_10G" ]; then
		if [ -f /usr/local/10g/share/ux400-module-10g.tar.gz ]; then
			imagename="ux400-module-10g.tar.gz"
			machinename="10G"
			boardname="10g"
			rm -rf /resv/v400/ux400-module-10g.tar.gz
			ln -s /usr/local/10g/share/ux400-module-10g.tar.gz /resv/v400/ux400-module-10g.tar.gz
			if [ -f /usr/local/10g/share/ux400-module-sd.tar.gz ]; then
				ln -s /usr/local/10g/share/ux400-module-sd.tar.gz /resv/v400/ux400-module-sd.tar.gz
			fi
		else
			echo -n "Can't find the software for board" > ${display_dev}
			echo -n $imagename > ${display_dev}
			echo -n "in slot" > ${display_dev}
			echo $1
			/sbin/ux400cset
			return 2
		fi
	elif [ "$machine" == "$UX400_100GE" ]; then
		if [ -f /usr/local/100ge/share/ux400-module-100ge.tar.gz ]; then
			imagename="ux400-module-100ge.tar.gz"
			machinename="100GE"
			boardname="100ge"
			rm -rf /resv/v400/ux400-module-100ge.tar.gz
			ln -s /usr/local/100ge/share/ux400-module-100ge.tar.gz /resv/v400/ux400-module-100ge.tar.gz
			
                        if [ -f /usr/local/100ge/share/ux400-module-sd.tar.gz ]; then
                                ln -s /usr/local/100ge/share/ux400-module-sd.tar.gz /resv/v400/ux400-module-sd.tar.gz
                        fi
		else
			echo -n "Can't find the software for board" > ${display_dev}
			echo -n $imagename > ${display_dev}
			echo -n "in slot" > ${display_dev}
			echo $1
			/sbin/ux400cset
			return 2
		fi
	elif [ "$machine" == "$UX400_2P5G" ]; then
		if [ -f /usr/local/2p5g/share/ux400-module-2p5g.tar.gz ]; then
			imagename="ux400-module-2p5g.tar.gz"
			machinename="2.5G"
			boardname="2p5g"
			rm -rf /resv/v400/ux400-module-2p5g.tar.gz
			ln -s /usr/local/2p5g/share/ux400-module-2p5g.tar.gz /resv/v400/ux400-module-2p5g.tar.gz
		else
			echo -n "Don't need upgrade module software for board" > ${display_dev}
			echo -n $imagename > ${display_dev}
			echo -n "in slot" > ${display_dev}
			echo $1
			/sbin/ux400cset
			return 2
		fi
	elif [ "$machine" == "$UX400_1GE" ]; then
		if [ -f /usr/local/1ge/share/ux400-module-1ge.tar.gz ]; then
			imagename="ux400-module-1ge.tar.gz"
			machinename="1GE"
			boardname="1ge"
			rm -rf /resv/v400/ux400-module-1ge.tar.gz
			ln -s /usr/local/1ge/share/ux400-module-1ge.tar.gz /resv/v400/ux400-module-1ge.tar.gz
                        if [ -f /usr/local/1ge/share/ux400-module-sd.tar.gz ]; then
                                ln -s /usr/local/1ge/share/ux400-module-sd.tar.gz /resv/v400/ux400-module-sd.tar.gz
                        fi
		else
			echo -n "Can't find the software for board" > ${display_dev}
			echo -n $imagename > ${display_dev}
			echo -n "in slot" > ${display_dev}
			echo $1
			/sbin/ux400cset
			return 2
		fi
	elif [ "$machine" == "$UX400_40GE" ]; then
		if [ -f /usr/local/40ge/share/ux400-module-40ge.tar.gz ]; then
			imagename="ux400-module-40ge.tar.gz"
			machinename="40GE"
			boardname="40ge"
			rm -rf /resv/v400/ux400-module-40ge.tar.gz
			ln -s /usr/local/40ge/share/ux400-module-40ge.tar.gz /resv/v400/ux400-module-40ge.tar.gz
                        if [ -f /usr/local/40ge/share/ux400-module-sd.tar.gz ]; then
                                ln -s /usr/local/40ge/share/ux400-module-sd.tar.gz /resv/v400/ux400-module-sd.tar.gz
                        fi
		else
			echo -n "Can't find the software for board" > ${display_dev}
			echo -n $imagename > ${display_dev}
			echo -n "in slot" > ${display_dev}
			echo $1
			/sbin/ux400cset
			return 2
		fi
        elif [ "$machine" == "$UX400_40G" ]; then
                if [ -f /usr/local/40g/share/ux400-module-40g.tar.gz ]; then
                        imagename="ux400-module-40g.tar.gz"
                        machinename="40G"
			boardname="40g"
                        rm -rf /resv/v400/ux400-module-40g.tar.gz
                        ln -s /usr/local/2p5g/share/ux400-module-40g.tar.gz /resv/v400/ux400-module-40g.tar.gz
                else
                        echo -n "Don't need upgrade module software for board" > ${display_dev}
                        echo -n $imagename > ${display_dev}
                        echo -n "in slot" > ${display_dev}
                        echo $1
                        /sbin/ux400cset
                        return 2
                fi
        elif [ "$machine" == "$UX400_16G" ]; then
                if [ -f /usr/local/16g/share/ux400-module-16g.tar.gz ]; then
                        imagename="ux400-module-16g.tar.gz"
                        machinename="16G"
			boardname="16g"
                        rm -rf /resv/v400/ux400-module-16g.tar.gz
                        ln -s /usr/local/16g/share/ux400-module-16g.tar.gz /resv/v400/ux400-module-16g.tar.gz
                else
                        echo -n "Don't need upgrade module software for board" > ${display_dev}
                        echo -n $imagename > ${display_dev}
                        echo -n "in slot" > ${display_dev}
                        echo $1
                        /sbin/ux400cset
                        return 2
                fi
	else
		echo -n "Unsupport machine" > ${display_dev}
		echo -r "\r" > ${display_dev}
		return 3
	fi

	echo "$1: $machine, $imagename, $machinename, $boardname" > ${display_dev}

        cp -rf /usr/bin/mdarms /resv/v400/
        cp -rf /usr/bin/kill-mods /resv/v400/
	cp -rf /usr/bin/ud /resv/v400/
	cp -rf /usr/bin/arm/mke2fs /resv/v400/
	cp -rf /usr/bin/arm/parted.sh /resv/v400/
	cp -rf /usr/bin/arm/veextmp.ko /resv/v400/

        chown v400:v400 /resv/v400/*
	
	/sbin/ux400cset
	mdevcheck $1
	local usbdev="$?"
	local locate=$1
	/sbin/ux400cset
#	ifconfig eth0 up

	isusb "$usbdev" "${USB0_5[@]}"
	if [ $? -eq 0 ]; then
		local usbx=`expr $usbdev - 1`
		local host=`expr $usbx \* 4 + 1 + 100`
		local sub=`expr $usbx \* 4 + 2 + 100`
		local x86_ip="128.0.0.$host"
		local arm_ip="128.0.0.$sub"
		local usb_eth="usb$usbx"
		echo "$1: $usb_eth, x86_ip=$x86_ip, arm_ip=$arm_ip" > ${display_dev}

		rm -rf /resv/v400/$1fup.log
		ping $arm_ip -c 1
		if [ $? -ne 0 ]; then
			echo -e "Can't access $locate subboard." > ${display_dev}
		fi

		/usr/bin/modud $arm_ip $x86_ip $udport
		sleep 5
		/usr/bin/client $arm_ip $udport $x86_ip $imagename $boardname /resv/v400/$1fup.log $locate > ${display_dev}
		grep -r "SUCCESS" /resv/v400/$1fup.log
	  	if [ $? -ne 0 ]; then
			echo -n "The " > ${display_dev}
			echo -n $machinename > ${display_dev}
			echo -n " module in slot " > ${display_dev}
			echo -n "$1" > ${display_dev}
			echo -e " upgrade failed, please try again, if you always see this, please contact customer service\r" > ${display_dev}
			/sbin/ux400cset
			return 3
	 	else
		        if [ -f /usr/local/$boardname/share/ux400-module-sd.tar.gz ]; then
				echo "Test Module $1: Flash upgrade done, find module SD card image, upgrade SD card." > ${display_dev}
				rm -rf /resv/v400/$1sdup.log
	                        sleep ${DELAY_SD}
				/usr/bin/client $arm_ip $udport $x86_ip ux400-module-sd.tar.gz $boardname /resv/v400/$1sdup.log $locate > ${display_dev}
                	        if [ $? -ne 0 ]; then
					/usr/bin/sdupfail > ${display_dev}
					sleep 1
					return 3
                	        fi
	                fi

			echo -n "The " > ${display_dev}
			echo -n $machinename > ${display_dev}
			echo -n " module in slot " > ${display_dev}
			echo -n "$1" > ${display_dev}
			echo -e " upgrade success\r" > ${display_dev}
			/usr/bin/modoff $arm_ip
			/sbin/ux400cset
			return 1
	  	fi
	else
		echo -e "Unsupport USB device"
	fi
}

#upgrade begin
function multiup()
{
	mtype $1
	local machine="$?"
	if [ "$machine" == "$UNKNOW" ]; then
	        sleep 1
	        mtype $1
	        machine="$?"
	        if [ "$machine" == "$UNKNOW" ]; then
	        	echo -e "Can't find module board at slot $1\r"
	        else
	                mupgrade $1
	                uret="$?"
	                touch /resv/v400/$1
	        fi
	else
	        mupgrade $1
	        uret="$?"
	        touch /resv/v400/$1
	fi

	echo "uret = $uret"
	return $uret
}

###################################################################

#upgrade subboards parallel
for location in ${slot_arr[@]}
do
	multiup $location &

done

for pid in $(jobs -p)
do
	wait $pid
	retval=$?

	if [ $retval -gt $ifupgrade ]; then
		ifupgrade=$retval
	fi
done

echo "ifupgrade = $ifupgrade"

#upgrade failed process
if [ $ifupgrade -gt 2 ]; then
        ux400buzz 1
        sleep 0.3
        ux400buzz 0
        sleep 0.3
        ux400buzz 1
        sleep 0.3
        ux400buzz 0
        sleep 0.3
        ux400buzz 1
        sleep 0.3
        ux400buzz 0
        exit 1
fi

#upgrade successfully process
if [ $ifupgrade -gt 0 ]; then
        echo -e "Upgrade finished, halt\r" > ${display_dev}
        ux400buzz 1
        sleep 0.3
        ux400buzz 0
        sleep 3
        exit 0
fi

