#!/bin/bash 
#####
#PBS -l select=1:ncpus=1:mem=20GB
#PBS -l walltime=9:59:00
#PBS -N viirs_rerun2
#PBS -q "dev"
#PBS -j oe
#PBS -A ICE-DEV
#  #PBS -R "rusage[mem=1024]"
#####

#-----------------------------------------------------------------------------
set -x

export NRT=YES
export KEEPDATA=NO

export tagm=20260509
export tag=20260510
export end=20260512

#-----------------------------------------------------------------------------
export HOMEbase=$HOME/rgops
export seaice_analysis_ver=v4.5.2

export HOMEseaice_analysis=$HOMEbase/seaice_analysis.${seaice_analysis_ver}

#Use this to override system in favor of my archive:
if [ $NRT == 'NO' ] ; then
  echo zzz not running in near real time, use my archives
  export DCOMROOT=/u/robert.grumbine/noscrub/satellites/prod/
  export RGTAG=dev
  export my_archive=true
else
  echo zzz running in near real time, use operations
fi

cd $HOMEseaice_analysis/ecf

#--------------------------------------------------------------------------------------
#The actual running of stuff
export cyc=00

while [ $tag -le $end ]
do

  for cyc in 00 06 12 18
  do
    time $HOMEseaice_analysis/ecf/dev/viirsday.sh
  done

  export tagm=$tag
  tag=`expr $tag + 1`
  export tag=`$HOME/bin/dtgfix3 $tag`

done
