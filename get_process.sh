#!/bin/bash

if [ $# != 1 ]; then
  echo "Usage: $0 pid"
  exit 1
fi

pid=$1
adb shell ps -t ${pid} > ${pid}.ps
adb shell debuggerd -b ${pid} > ${pid}.debuggerd
adb shell cat /proc/${pid}/maps > ${pid}.maps
adb shell procrank > procrank
adb shell dumpsys meminfo ${pid} > ${pid}.meminfo
