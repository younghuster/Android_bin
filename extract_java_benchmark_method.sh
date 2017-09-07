#!/bin/bash

# Features
# - This script can extract the binary code of specified java methods from device to speedup performance analysis.
# - Support Android 6.0/7.0.
# - Support 32bit/64bit of both benchmarks and devices.
# - Recognize the version of java benchmark(both regular and pro) automatically.

# Precondition
# - The host is connected with device through usb.
# - The apks for java benchmark are already installed.

# TODO
# - Add more java benchmarks.
# - Test on reference devices(user version).
# - Support other architectures, such as x86/x86_64.

# Check Android release version.
release_version=$(adb shell getprop ro.build.version.release)

# Get the package name according to filter.
# $1: package filter
get_pkg_name() {
  local bin

  if [ "${release_version}" = "7.0" ]; then
    bin="cmd package"
  else
    bin="pm"
  fi

  pkg_name=$(adb shell $bin list packages|grep $1|awk -F ":" '{print $2}')

  # We need to remove the trailing CR.
  pkg_name=$(echo -n ${pkg_name}|tr -d '\r')
  echo "pkg_name="$pkg_name
}

# Get the arch of pkg after installation.
get_pkg_arch() {
 # cpu_abi=$(adb shell getprop ro.product.cpu.abi)
  primary_cpu_abi=$(adb shell pm dump ${pkg_name}|grep "primaryCpuAbi"|awk -F "=" '{print $2}')
  # We have to compare the first 5 letters to avoid the boring '-' character.
  case ${primary_cpu_abi:0:5} in
    "null")
      # We have to get the preferred cpu abi if the primary cpu abi is null.
      preferred_cpu_abi=$(adb shell getprop ro.product.cpu.abilist|awk -F "," '{print $1}')
      case ${preferred_cpu_abi:0:5} in
        "armea")
          arch="arm"
          ;;
        "arm64")
          arch="arm64"
          ;;
        *)
          echo "Unsupported cpu abi: "${cpu_abi}
	esac
      ;;
    "armea")
      arch="arm"
      ;;
    "arm64")
      arch="arm64"
      ;;
    *)
      echo "Unsupported cpu abi: "${cpu_abi}
  esac
}

# Extract the binaroy code of hot methods from the specified java benchmark.
# $1: package filter
do_extract() {
  # We need to force the benchmark apk to compile with AOT in 7.0.
  if [ "${release_version}" = "7.0" ]; then
    adb shell cmd package compile -m speed -f ${pkg_name} > /dev/null 2>&1
  fi

  oat_file=/data/app/${pkg_name}-1/oat/${arch}/base.odex

  case $1 in
    "com.aurorasoftworks.quadrant.ui")
      declare -A cpu_case
      cpu_case["uC"]="benchmark_cpu_branching_logic"
      cpu_case["Ix"]="benchmark_cpu_matrix_int"
      cpu_case["BI"]="benchmark_cpu_matrix_long"
      cpu_case["pS"]="benchmark_cpu_matrix_short"
      cpu_case["sW"]="benchmark_cpu_matrix_byte"
      cpu_case["yv"]="benchmark_cpu_matrix_float"
      cpu_case["KP"]="benchmark_cpu_matrix_double"
      cpu_case["lT"]="benchmark_cpu_checksum"

      # start to oatdump.
      for class in uC Ix BI pS sW yv KP lT; do
        adb shell oatdump --oat-file=${oat_file} --class-filter=${class} --method-filter=a > Quadrant-${cpu_case[${class}]}.s
      done
      ;;
    "eu.chainfire.cfbench")
      oat_file=/data/app/${pkg_name}-1/oat/${arch}/base.odex

      # start to oatdump.
      for method in benchMIPS benchMSFLOPS benchMDFLOPS benchMemReadAligned benchMemWriteAligned; do
        adb shell oatdump --oat-file=${oat_file} --class-filter=BenchJava --method-filter=${method} > CFBench-${method}.s
      done
      ;;
    *)
      echo "Unsupported benchmark: $1"
  esac
}

main() {
  for pkg_filter in com.aurorasoftworks.quadrant.ui eu.chainfire.cfbench; do
    get_pkg_name ${pkg_filter}
    if [ -z "${pkg_name}" ]; then
      echo "${pkg_filter} has not been installed."
      continue
    fi

    get_pkg_arch
    do_extract ${pkg_filter}
  done
}

main "$@"

