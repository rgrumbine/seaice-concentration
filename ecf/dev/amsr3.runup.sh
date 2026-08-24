#!/bin/bash 
#####
#PBS -l select=1:ncpus=1:mem=20GB
#PBS -l walltime=9:59:00
#PBS -N amsr3_rerun
#PBS -q "dev"
#PBS -j oe
#PBS -A ICE-DEV
#  #PBS -R "rusage[mem=1024]"
#####

#-----------------------------------------------------------------------------
set -x

export NRT=NO
export KEEPDATA=NO

export tagm=20260818
export tag=20260819
export end=20260819

#-----------------------------------------------------------------------------
export HOMEbase=$HOME/rgdev
export seaice_analysis_ver=v4.5.2

export HOMEseaice_analysis=$HOMEbase/seaice_analysis.${seaice_analysis_ver}

#Use this to override system in favor of my archive:
if [ $NRT == 'NO' ] ; then
  echo zzz not running in near real time, use my archives
  #export DCOMROOT=/u/robert.grumbine/noscrub/satellites/prod/
  export DCOMROOT=/lfs/h2/emc/da/noscrub/common/lfs/h1/ops/prod
#/lfs/h2/emc/da/noscrub/common/lfs/h1/ops/prod/dcom/20260818/seaice/pda
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

  #for cyc in 00 06 12 18
  for cyc in 00 
  do
    #echo runup HOMEbase $HOMEbase
    #echo runup HOMEseaice_analysis $HOMEseaice_analysis
    #echo runup pwd `pwd`
    echo zzz amsr3.runup.sh calling amsr3day.sh
    time $HOMEseaice_analysis/ecf/dev/amsr3day.sh
  done

  export tagm=$tag
  tag=`expr $tag + 1`
  export tag=`$HOME/bin/dtgfix3 $tag`

done
