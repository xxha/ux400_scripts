#!/bin/bash

########################## tools related ##########################

# bucheck_reveal:
#	reveal version of bucheck, no log output to screen.
#	bucheck: check if subboard need to be updated.

# mtype:
#	return the type of subboard.

# mdevcheck:
# 	return the usb device number of specific location.

# modud:
#	open ud service on subboard for ux400 client access.
# 	parameters:  1. target IP 2. source IP 3. port number.

# client_reveal:
#	subboard upgrade routine for reveal.

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

#display_dev=/dev/tty7
reveal_subboard_log=/resv/v400/reveal_subboard.log
echo "subboard upgrad start:" > ${reveal_subboard_log}
/sbin/ux400cset

echo -e '\033[9;0]' >> ${reveal_subboard_log}

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
	bucheck_reveal $1 >> ${reveal_subboard_log}
	local update="$?"
	echo -ne "    \r" >> ${reveal_subboard_log}
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
			echo "$1: SD card need upgrade" >> ${reveal_subboard_log}
		fi
	fi

	#get subboard type
	mtype $1 > /dev/null 2>&1
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
			echo "Can't find $imagename for board, in slot $1" >> ${reveal_subboard_log}
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
			echo "Can't find $imagename for board, in slot $1" >> ${reveal_subboard_log}
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
			echo "Can't find $imagename for board, in slot $1" >> ${reveal_subboard_log}
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
			echo "Can't find $imagename for board, in slot $1" >> ${reveal_subboard_log}
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
			echo "Can't find $imagename for board, in slot $1" >> ${reveal_subboard_log}
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
			echo "Can't find $imagename for board, in slot $1" >> ${reveal_subboard_log}
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
			echo "Can't find $imagename for board, in slot $1" >> ${reveal_subboard_log}
                        /sbin/ux400cset
                        return 2
                fi
	else
		echo "Unsupport machine" >> ${reveal_subboard_log}
		return 3
	fi

	echo "$1: $machine, $imagename, $machinename, $boardname" >> ${reveal_subboard_log}

        cp -rf /usr/bin/mdarms /resv/v400/
        cp -rf /usr/bin/kill-mods /resv/v400/
	cp -rf /usr/bin/ud /resv/v400/
	cp -rf /usr/bin/arm/mke2fs /resv/v400/
	cp -rf /usr/bin/arm/parted.sh /resv/v400/
	cp -rf /usr/bin/arm/veextmp.ko /resv/v400/

        chown v400:v400 /resv/v400/*
	
	/sbin/ux400cset
	mdevcheck $1 > /dev/null 2>&1
	local usbdev="$?"
	local locate=$1
	/sbin/ux400cset

	isusb "$usbdev" "${USB0_5[@]}"
	if [ $? -eq 0 ]; then
		local usbx=`expr $usbdev - 1`
		local host=`expr $usbx \* 4 + 1 + 100`
		local sub=`expr $usbx \* 4 + 2 + 100`
		local x86_ip="128.0.0.$host"
		local arm_ip="128.0.0.$sub"
		local usb_eth="usb$usbx"
		echo "$1: $usb_eth, x86_ip=$x86_ip, arm_ip=$arm_ip" >> ${reveal_subboard_log}

		rm -rf /resv/v400/$1fup.log
		ping $arm_ip -c 1 > /dev/null 2>&1
		if [ $? -ne 0 ]; then
			echo "Can't access $locate subboard." >> ${reveal_subboard_log}
		fi

		/usr/bin/modud $arm_ip $x86_ip $udport > /dev/null 2>&1
		sleep 5
		/usr/bin/client_reveal $arm_ip $udport $x86_ip $imagename $boardname /resv/v400/$1fup.log $locate >> ${reveal_subboard_log}
		grep -r "SUCCESS" /resv/v400/$1fup.log
	  	if [ $? -ne 0 ]; then
			echo "The $machinename module in slot $1 upgrade failed,please try again." >> ${reveal_subboard_log}
			echo "if you always see this, please contact customer service" >> ${reveal_subboard_log}
			/sbin/ux400cset
			return 3
	 	else
		        if [ -f /usr/local/$boardname/share/ux400-module-sd.tar.gz ]; then
				echo "Test Module $1: Flash upgrade done, find module SD card image, upgrade SD card." >> ${reveal_subboard_log}
				rm -rf /resv/v400/$1sdup.log
	                        sleep ${DELAY_SD}
				/usr/bin/client_reveal $arm_ip $udport $x86_ip ux400-module-sd.tar.gz $boardname /resv/v400/$1sdup.log $locate >> ${reveal_subboard_log}
                	        if [ $? -ne 0 ]; then
					/usr/bin/sdupfail > /dev/null 2>&1
					sleep 1
					return 3
                	        fi
	                fi

			echo "The $machinename module in slot $1 upgrade success" >> ${reveal_subboard_log}
			/usr/bin/modoff $arm_ip >> ${reveal_subboard_log}
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
	mtype $1 >> ${reveal_subboard_log}
	local machine="$?"
	if [ "$machine" == "$UNKNOW" ]; then
		echo -e "Can't find module board at slot $1\r" >> ${reveal_subboard_log}
	else
	        mupgrade $1
	        uret="$?"
	        touch /resv/v400/$1
	fi

	echo "uret = $uret" >> ${reveal_subboard_log}
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

echo "ifupgrade = $ifupgrade" >> ${reveal_subboard_log}

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
	sleep 3

	#reboot subboards
	/sbin/ux400mod 0 > /dev/null 2>&1
	sleep 5
	/sbin/ux400mod 1 > /dev/null 2>&1
	sleep 5

        exit 1
fi

#upgrade successfully process
if [ $ifupgrade -gt 0 ]; then
        echo -e "Upgrade finished.\r" >> ${reveal_subboard_log}
        ux400buzz 1
        sleep 0.3
        ux400buzz 0
        sleep 3

	#reboot subboards
	/sbin/ux400mod 0 > /dev/null 2>&1
	sleep 5
	/sbin/ux400mod 1 > /dev/null 2>&1
	sleep 5

        exit 0
fi

