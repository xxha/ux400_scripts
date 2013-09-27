#!/bin/bash

echo "test start"

#/usr/local/v300/sbin/softupdate ux400

#setsid /usr/local/v300/sbin/softupdate ux400 &
 
(/usr/local/v300/sbin/softupdate ux400 &)  
echo "test stop"
