#!/bin/bash

#here we assume all the upgrading image are copied to /tmp/ directory.

#check priviledge
if [ "$UID" != "0" ]; then
        echo "Failed, Please run with root priviledge."
        exit 1
fi

retval=0
reveal_local=/resv/v400/reveal_local.log
echo "review local log start:" > ${reveal_local}

mount /usr/local/ -o remount,rw
cd /tmp/

if [ -f /tmp/ux400-local-10g.tar.gz ]; then
	sub_board=10g

	tar -xf ux400-local-$sub_board.tar.gz
	if [ $? -eq "0" ]; then
		diff /tmp/$sub_board/lib/vendor-info.txt /usr/local/$sub_board/lib/vendor-info.txt > /dev/null 2>&1
		if [ $? -ne "0" ]; then
			echo "$sub_board version different, need upgrade." >> ${reveal_local}
			rm -rf /usr/local/$sub_board
			mv /tmp/$sub_board /usr/local/$sub_board
			sync
			echo "$sub_board upgrade done." >> ${reveal_local}
		else
			echo "$sub_board version is the same, needn't upgrade." >> ${reveal_local}
			rm -rf /tmp/$sub_board
		fi
	else
		echo "Bad ux400-local-$sub_board.tar.gz image, please load it again." >> ${reveal_local}
		retval=1
	fi
fi


if [ -f /tmp/ux400-local-2p5g.tar.gz ]; then
	sub_board=2p5g

	tar -xf ux400-local-$sub_board.tar.gz
	if [ $? -eq "0" ]; then
		diff /tmp/$sub_board/lib/vendor-info.txt /usr/local/$sub_board/lib/vendor-info.txt > /dev/null 2>&1
		if [ $? -ne "0" ]; then
			echo "$sub_board version different, need upgrade." >> ${reveal_local}
			rm -rf /usr/local/$sub_board
			mv /tmp/$sub_board /usr/local/$sub_board
			sync
			echo "$sub_board upgrade done." >> ${reveal_local}
		else
			echo "$sub_board version is the same, needn't upgrade." >> ${reveal_local}
			rm -rf /tmp/$sub_board
		fi
	else
		echo "Bad ux400-local-$sub_board.tar.gz image, please load it again." >> ${reveal_local}
		retval=1
	fi
fi

if [ -f /tmp/ux400-local-1ge.tar.gz ]; then
	sub_board=1ge

	tar -xf ux400-local-$sub_board.tar.gz
	if [ $? -eq "0" ]; then
		diff /tmp/$sub_board/lib/vendor-info.txt /usr/local/$sub_board/lib/vendor-info.txt > /dev/null 2>&1
		if [ $? -ne "0" ]; then
			echo "$sub_board version different, need upgrade." >> ${reveal_local}
			rm -rf /usr/local/$sub_board
			mv /tmp/$sub_board /usr/local/$sub_board
			sync
			echo "$sub_board upgrade done." >> ${reveal_local}
		else
			echo "$sub_board version is the same, needn't upgrade." >> ${reveal_local}
			rm -rf /tmp/$sub_board
		fi
	else
		echo "Bad ux400-local-$sub_board.tar.gz image, please load it again." >> ${reveal_local}
		retval=1
	fi
fi

if [ -f /tmp/ux400-local-40g.tar.gz ]; then
	sub_board=40g

	tar -xf ux400-local-$sub_board.tar.gz
	if [ $? -eq "0" ]; then
		diff /tmp/$sub_board/lib/vendor-info.txt /usr/local/$sub_board/lib/vendor-info.txt > /dev/null 2>&1
		if [ $? -ne "0" ]; then
			echo "$sub_board version different, need upgrade." >> ${reveal_local}
			rm -rf /usr/local/$sub_board
			mv /tmp/$sub_board /usr/local/$sub_board
			sync
			echo "$sub_board upgrade done." >> ${reveal_local}
		else
			echo "$sub_board version is the same, needn't upgrade." >> ${reveal_local}
			rm -rf /tmp/$sub_board
		fi
	else
		echo "Bad ux400-local-$sub_board.tar.gz image, please load it again." >> ${reveal_local}
		retval=1
	fi
fi

if [ -f /tmp/ux400-local-16g.tar.gz ]; then
	sub_board=16g

	tar -xf ux400-local-$sub_board.tar.gz
	if [ $? -eq "0" ]; then
		diff /tmp/$sub_board/lib/vendor-info.txt /usr/local/$sub_board/lib/vendor-info.txt > /dev/null 2>&1
		if [ $? -ne "0" ]; then
			echo "$sub_board version different, need upgrade." >> ${reveal_local}
			rm -rf /usr/local/$sub_board
			mv /tmp/$sub_board /usr/local/$sub_board
			sync
			echo "$sub_board upgrade done." >> ${reveal_local}
		else
			echo "$sub_board version is the same, needn't upgrade." >> ${reveal_local}
			rm -rf /tmp/$sub_board
		fi
	else
		echo "Bad ux400-local-$sub_board.tar.gz image, please load it again." >> ${reveal_local}
		retval=1
	fi
fi

if [ -f /tmp/ux400-local-100ge.tar.gz ]; then
	sub_board1=100ge
	sub_board2=40ge

	tar -xf ux400-local-$sub_board1.tar.gz
	if [ $? -eq "0" ]; then
		diff /tmp/$sub_board1/lib/vendor-info.txt /usr/local/$sub_board1/lib/vendor-info.txt > /dev/null 2>&1
		if [ $? -ne "0" ]; then
			echo "$sub_board1 version different, need upgrade." >> ${reveal_local}
			rm -rf /usr/local/$sub_board1
			mv /tmp/$sub_board1 /usr/local/$sub_board1
			sync
			echo "$sub_board1 upgrade done." >> ${reveal_local}
		else
			echo "$sub_board1 version is the same, needn't upgrade." >> ${reveal_local}
			rm -rf /tmp/$sub_board1
		fi

		diff /tmp/$sub_board2/lib/vendor-info.txt /usr/local/$sub_board2/lib/vendor-info.txt > /dev/null 2>&1
		if [ $? -ne "0" ]; then
			echo "$sub_board2 version different, need upgrade." >> ${reveal_local}
			rm -rf /usr/local/$sub_board2
			mv /tmp/$sub_board2 /usr/local/$sub_board2
			sync
			echo "$sub_board2 upgrade done." >> ${reveal_local}
		else
			echo "$sub_board2 version is the same, needn't upgrade." >> ${reveal_local}
			rm -rf /tmp/$sub_board2
		fi

	else
		echo "Bad ux400-local-$sub_board1.tar.gz image, please load it again." >> ${reveal_local}
		retval=1
	fi
fi

if [ -f /tmp/ux400-local-v300.tar.gz ]; then
	sub_board=v300

	tar -xf ux400-local-$sub_board.tar.gz
	if [ $? -eq "0" ]; then
		diff /tmp/$sub_board/lib/vendor-info.txt /usr/local/$sub_board/lib/vendor-info.txt > /dev/null 2>&1
		if [ $? -ne "0" ]; then
			echo "$sub_board version different, need upgrade." >> ${reveal_local}
			rm -rf /usr/local/$sub_board
			tar xf ux400-local-$sub_board.tar.gz -C /usr/local
			if [ $? -eq "0" ]; then
				echo "tar $sub_board to /usr/local succeed" >> ${reveal_local}
				pushd /usr/local >> ${reveal_local}
				if [ -f /usr/local/$sub_board.md5 ]; then
					md5sum -c --quiet $sub_board.md5
					if [ $? -eq "0" ]; then
						echo "$sub_board md5sum suceed." >> ${reveal_local}
					else
						echo "$sub_board md5sum failed." >> ${reveal_local}
						retval=1
					fi
				else
					echo "no md5 file, needn't check." >> ${reveal_local}
				fi
				popd >> ${reveal_local}
			else
				echo "tar $sub_board to /usr/local failed." >> ${reveal_local}
				retval=1
			fi
			sync
			echo "$sub_board upgrade done." >> ${reveal_local}
		else
			echo "$sub_board version is the same, needn't upgrade." >> ${reveal_local}
			rm -rf $sub_board $sub_board.md5 etc share
		fi
	else
		rm -rf $sub_board $su_bboard.md5 etc share
		echo "Bad ux400-local-$sub_board.tar.gz image, please load it again." >> ${reveal_local}
		retval=1
	fi
fi

echo "All sub-board upgrade done." >> ${reveal_local}
echo "retval = $retval" >> ${reveal_local}
exit $retval
