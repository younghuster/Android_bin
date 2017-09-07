#!/system/bin/sh

cmd=`cat /proc/$1/cmdline`
echo pid=$1"($cmd)"
echo "     Thread Id\t\t  Thread Name" 
for d in /proc/$1/task/*
do
  if test -d $d ; then
    echo -n $d:"\t"
    cat $d/comm
  fi
done
