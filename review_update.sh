#!/bin/bash

#here we assume all the upgrading image are copied to /tmp/ directory.


#check priviledge
if [ "$UID" != "0" ]; then
        echo "Failed, Please run with root priviledge."
        exit 1
fi

mount /usr/local/ -o remount,rw
cd /tmp/

if [ -f /tmp/ux400-local-10g.tar.gz ]; then
	sub_board=10g

	tar -xf ux400-local-$sub_board.tar.gz
	if [ $? -eq "0" ]; then
		diff /tmp/$sub_board/lib/vendor-info.txt /usr/local/$sub_board/lib/vendor-info.txt
		if [ $? -ne "0" ]; then
			echo "$sub_board version different, need upgrade."
			rm -rf /usr/local/$sub_board
			mv /tmp/$sub_board /usr/local/$sub_board
			sync
			echo "$sub_board upgrade done."
		else
			echo "$sub_board version is the same, needn't upgrade."
			rm -rf /tmp/$sub_board
		fi
	else
		echo "Bad ux400-local-$sub_board.tar.gz image, please load it again."
	fi
fi


if [ -f /tmp/ux400-local-2p5g.tar.gz ]; then
	sub_board=2p5g

	tar -xf ux400-local-$sub_board.tar.gz
	if [ $? -eq "0" ]; then
		diff /tmp/$sub_board/lib/vendor-info.txt /usr/local/$sub_board/lib/vendor-info.txt
		if [ $? -ne "0" ]; then
			echo "$sub_board version different, need upgrade."
			rm -rf /usr/local/$sub_board
			mv /tmp/$sub_board /usr/local/$sub_board
			sync
			echo "$sub_board upgrade done."
		else
			echo "$sub_board version is the same, needn't upgrade."
			rm -rf /tmp/$sub_board
		fi
	else
		echo "Bad ux400-local-$sub_board.tar.gz image, please load it again."
	fi
fi

if [ -f /tmp/ux400-local-1ge.tar.gz ]; then
	sub_board=1ge

	tar -xf ux400-local-$sub_board.tar.gz
	if [ $? -eq "0" ]; then
		diff /tmp/$sub_board/lib/vendor-info.txt /usr/local/$sub_board/lib/vendor-info.txt
		if [ $? -ne "0" ]; then
			echo "$sub_board version different, need upgrade."
			rm -rf /usr/local/$sub_board
			mv /tmp/$sub_board /usr/local/$sub_board
			sync
			echo "$sub_board upgrade done."
		else
			echo "$sub_board version is the same, needn't upgrade."
			rm -rf /tmp/$sub_board
		fi
	else
		echo "Bad ux400-local-$sub_board.tar.gz image, please load it again."
	fi
fi

if [ -f /tmp/ux400-local-40g.tar.gz ]; then
	sub_board=40g

	tar -xf ux400-local-$sub_board.tar.gz
	if [ $? -eq "0" ]; then
		diff /tmp/$sub_board/lib/vendor-info.txt /usr/local/$sub_board/lib/vendor-info.txt
		if [ $? -ne "0" ]; then
			echo "$sub_board version different, need upgrade."
			rm -rf /usr/local/$sub_board
			mv /tmp/$sub_board /usr/local/$sub_board
			sync
			echo "$sub_board upgrade done."
		else
			echo "$sub_board version is the same, needn't upgrade."
			rm -rf /tmp/$sub_board
		fi
	else
		echo "Bad ux400-local-$sub_board.tar.gz image, please load it again."
	fi
fi

if [ -f /tmp/ux400-local-16g.tar.gz ]; then
	sub_board=16g

	tar -xf ux400-local-$sub_board.tar.gz
	if [ $? -eq "0" ]; then
		diff /tmp/$sub_board/lib/vendor-info.txt /usr/local/$sub_board/lib/vendor-info.txt
		if [ $? -ne "0" ]; then
			echo "$sub_board version different, need upgrade."
			rm -rf /usr/local/$sub_board
			mv /tmp/$sub_board /usr/local/$sub_board
			sync
			echo "$sub_board upgrade done."
		else
			echo "$sub_board version is the same, needn't upgrade."
			rm -rf /tmp/$sub_board
		fi
	else
		echo "Bad ux400-local-$sub_board.tar.gz image, please load it again."
	fi
fi

if [ -f /tmp/ux400-local-100ge.tar.gz ]; then
	sub_board1=100ge
	sub_board2=40ge

	tar -xf ux400-local-$sub_board1.tar.gz
	if [ $? -eq "0" ]; then
		diff /tmp/$sub_board1/lib/vendor-info.txt /usr/local/$sub_board1/lib/vendor-info.txt
		if [ $? -ne "0" ]; then
			echo "$sub_board1 version different, need upgrade."
			rm -rf /usr/local/$sub_board1
			mv /tmp/$sub_board1 /usr/local/$sub_board1
			sync
			echo "$sub_board1 upgrade done."
		else
			echo "$sub_board1 version is the same, needn't upgrade."
			rm -rf /tmp/$sub_board1
		fi

		diff /tmp/$sub_board2/lib/vendor-info.txt /usr/local/$sub_board2/lib/vendor-info.txt
		if [ $? -ne "0" ]; then
			echo "$sub_board2 version different, need upgrade."
			rm -rf /usr/local/$sub_board2
			mv /tmp/$sub_board2 /usr/local/$sub_board2
			sync
			echo "$sub_board2 upgrade done."
		else
			echo "$sub_board2 version is the same, needn't upgrade."
			rm -rf /tmp/$sub_board2
		fi

	else
		echo "Bad ux400-local-$sub_board1.tar.gz image, please load it again."
	fi


fi

if [ -f /tmp/ux400-local-v300.tar.gz ]; then
	sub_board=v300

	tar -xf ux400-local-$sub_board.tar.gz
	if [ $? -eq "0" ]; then
		diff /tmp/$sub_board/lib/vendor-info.txt /usr/local/$sub_board/lib/vendor-info.txt
		if [ $? -ne "0" ]; then
			echo "$sub_board version different, need upgrade."
			rm -rf /usr/local/$sub_board
			tar xf ux400-local-$sub_board.tar.gz -C /usr/local
			if [ $? -eq "0" ]; then
				echo "tar $sub_board to /usr/local succeed"
				pushd /usr/local
				if [ -f /usr/local/$sub_board.md5 ]; then
					md5sum -c --quiet $sub_board.md5
					if [ $? -eq "0" ]; then
						echo "$subboard md5sum suceed."
					else
						echo "$subboard md5sum failed."
					fi
				else
					echo "no md5 file, needn't check."
				fi
				popd
			else
				echo "tar $sub_board to /usr/local failed."
			fi
			sync
			echo "$sub_board upgrade done."
		else
			echo "$sub_board version is the same, needn't upgrade."
			rm -rf $subboard $subboard.md5 etc share
		fi
	else
		rm -rf $subboard $subboard.md5 etc share
		echo "Bad ux400-local-$sub_board.tar.gz image, please load it again."
	fi
fi

echo "All sub-board upgrade done."
