#!/bin/bash

# check parameter
if [ "$#" -ne 1 ]; then
echo "usage: $0 process_name"
exit 1
fi
# get process name and pid
process_name=`adb shell ps|grep "$1"|awk '{print $9}'`
pid=`adb shell ps|grep "$1"|awk '{print $2}'`
echo "process name: "$process_name
echo "pid:"$pid 

# get thread count of process
while :
do
adb shell cat /proc/$pid/status|grep Threads

fd_num=`adb shell ls -l /proc/$pid/fd|wc -l`
echo "fd count:       "$fd_num
echo
sleep 1
done
