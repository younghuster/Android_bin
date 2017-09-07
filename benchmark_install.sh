#!/bin/sh

#adb root
#sleep 2

cd ~/tools/apk

#adb install cpu_z-1.08.apk
adb install system_tool/PerfMon-v1.21.apk

adb install benchmark/antutu/v6.1.4/AnTuTu_Benchmark_v6.1.4.apk
adb install benchmark/antutu/v6.1.4/antutu-3dbench_v6.0.4.apk
#adb install benchmark/geekbench3/Geekbench3_v3.3.2.apk
#adb install benchmark/Vellamo/Vellamo_Mobile_Benchmark_v3.1.apk

#adb install benchmark/MobileBench/MobileBench_v1.0.apk
adb install benchmark/Quadrant/QuadrantProfessional_V2.1.1.apk 
adb install benchmark/CF-Bench/CF-Bench_Pro_v1.3.apk 
adb install benchmark/LinpackForAndroid/Linpack.Pro.for.Android_v1.2.9.apk 
#adb install benchmark/BenchmarkPi/Benchmark_Pi_1.11.apk

cd -
