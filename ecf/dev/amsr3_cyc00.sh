#!/bin/bash 
#####
#PBS -l select=1:ncpus=6:mem=4GB
#PBS -l walltime=0:59:00
#PBS -N amsr3_nrt0
#PBS -q "dev"
#PBS -j oe
#PBS -A ICE-DEV
#  #PBS -R "rusage[mem=1024]"
#####

#-----------------------------------------------------------------------------
set -x

export NRT=${NRT:-NO}
export KEEPDATA=${KEEPDATA:-NO}

export tag=${tag:-`date +"%Y%m%d"`}
export PDY=$tag

#-----------------------------------------------------------------------------
export HOMEbase=${HOMEbase:-$HOME/rgdev}
export seaice_analysis_ver=v4.5.2

export HOMEseaice_analysis=$HOMEbase/seaice_analysis.${seaice_analysis_ver}

#Use this to override system in favor of my archive:
if [ $NRT == 'NO' ] ; then
  echo zzz not running in near real time, use my archives
  #export DCOMROOT=${DCOMROOT:-/u/robert.grumbine/noscrub/satellites/prod/}
  export DCOMROOT=${DCOMROOT:-/lfs/h2/emc/da/noscrub/common/lfs/h1/ops/prod}
  export RGTAG=dev
  export my_archive=true
else
  echo zzz running in near real time, use operations
fi

cd $HOMEseaice_analysis/ecf

#--------------------------------------------------------------------------------------
#The actual running of stuff
export cyc=00
time $HOMEseaice_analysis/ecf/dev/amsr3day.sh
#--------------------------------------------------------------------------------------
