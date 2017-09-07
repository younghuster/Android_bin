#!/bin/bash

#mypath=`pwd`
#echo $mypath

#adb root
#adb remount
#adb reboot bootloader

sleep 3

fastboot flash boot boot.img
fastboot flash cache cache.img
fastboot flash recovery recovery.img
fastboot flash userdata userdata.img
fastboot flash system system.img
#fastboot flash vendor vendor.img

fastboot reboot
