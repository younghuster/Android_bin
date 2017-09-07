#!/bin/bash
adb root
sleep 2
adb remount
sleep 2

#adb push bin/dalvikvm32 /system/bin/
#adb push bin/dalvikvm64  /system/bin/
adb push bin/dex2oat /system/bin/
adb push bin/oatdump /system/bin/

adb push lib/libart.so /system/lib/
adb push lib/libart-compiler.so /system/lib/

adb push lib64/libart.so /system/lib64
adb push lib64/libart-compiler.so /system/lib64
adb push lib64/libart-disassembler.so /system/lib64

