#!/bin/bash

# Note that the analysis job can run without any contents in the output from this.
# That is what the 'touch' at the end is ensuring.
#
# Environment to run: COMOUT, DCOMROOT, PDY, PDYm1, PDYm2
#                     USH/seaice_amsr3l2
set -x

if [ $# -ne 3 ]; then
  echo need 3 inputs: day, hh, inst  
  exit
fi

day=$1
hh=$2
inst=$3
export PS4='$SECONDS + seaice_amsr3l2.${inst}.${day}${hh}: '

echo zzz entered exseaice_amsr3l2

export PYTHONPATH=$PYTHONPATH:$PACKAGEROOT/seaice_analysis.v4.5.2/sorc/mmablib/py
if [ ! -d $PACKAGEROOT/seaice_analysis.v4.5.2/sorc/mmablib/py ] ; then
  echo could not find mmablib/py
  exit 1
fi
echo zzz prepared python

#$USHseaice_analysis/amsr3_composite.py $DCOMROOT/$day/wgrdbul/IST/AMSR3-SEAICE*_s${day}${hh}*.nc \
$USHseaice_analysis/amsr3_composite.py /lfs/h2/emc/obsproc/noscrub/sudhir.nadiga/SCRIPTDIR/SEMIOPS/TEMPNEW/asmr_seaice/AMSR3-SEAICE*_s${day}${hh}*.nc \
    > amsr3.$inst.$cyc.${day}$hh 
# Handle no file case 
if [ ! -f amsr3.$inst.$cyc.${day}$hh ] ; then
  touch amsr3.$inst.$cyc.${day}$hh
fi

cp -p amsr3.$inst.$cyc.${day}$hh $COMOUT

echo " done with amsr3.$inst.$cyc.${day}$hh processing, exiting...."
