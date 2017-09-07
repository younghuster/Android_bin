#!/bin/bash

rm -rf info
mkdir info 
mkdir -p info/bin
mkdir -p info/lib
mkdir -p info/lib64
mkdir -p info/jar

adb shell getprop > info/prop.info
adb shell mount > info/mount.info

# TODO: Do this in a for loop
adb shell cp /system/bin/dex2oat /data/local/tmp/
adb pull /data/local/tmp/dex2oat info/bin
adb pull /system/bin/oatdump info/bin
adb pull /system/bin/dalvikvm32 info/bin
# adb pull /system/bin/patchoat info/bin
adb shell cp /system/bin/patchoat /data/local/tmp/
adb pull /data/local/tmp/patchoat info/bin
adb pull /system/bin/app_process32 info/bin
adb pull /system/bin/linker info/bin
# adb pull /system/bin/installd info/bin
adb shell cp /system/bin/installd /data/local/tmp/
adb pull /data/local/tmp/installd info/bin

# TODO: Do this in a for loop
adb pull /system/lib/libc.so info/lib
adb pull /system/lib/libm.so info/lib
adb pull /system/lib/libz.so info/lib
adb pull /system/lib/libskia.so info/lib
adb pull /system/lib/libart.so info/lib
adb pull /system/lib/libart-compiler.so info/lib
adb pull /system/lib/libvixl.so info/lib
#adb pull /system/lib/libart-disassembler.so info/lib

adb pull /system/lib64/libc.so info/lib64
adb pull /system/lib64/libm.so info/lib64
adb pull /system/lib64/libz.so info/lib64
adb pull /system/lib64/libskia.so info/lib64
adb pull /system/lib64/libart.so info/lib64
adb pull /system/lib64/libart-compiler.so info/lib64
adb pull /system/lib64/libart-disassembler.so info/lib64
adb pull /system/lib64/libvixl.so info/lib64


# jar
adb pull /system/framework/core-oj.jar info/jar
adb pull /system/framework/core-libart.jar info/jar
