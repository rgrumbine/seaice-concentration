#!/bin/sh
set -x

pwd=`pwd`;

if [ -z $MMAB_BASE ] ; then
  echo MMAB_BASE for mmablib has not been defined
  exit
fi
  
if [ ! -f makeall.mk ] ; then
  cp ../makeall.mk .
  if [ $? -ne 0 ] ; then
    echo could not find makeall.mk, aborting
    exit 1
  fi
fi

for d in seaice_amsr3bufr.fd seaice_iceamsr3.Cd 
do
  cd $pwd/$d
  make
  cd ..
done
