#!/bin/bash

#check priviledge
if [ "$UID" != "0" ]; then
        echo "Failed, Please run with root priviledge."
        exit 1
fi

stop-v400
sync

mount / -o remount,rw
sync
mount /usr/local -o remount,rw
sync

echo "kill app done\n"
