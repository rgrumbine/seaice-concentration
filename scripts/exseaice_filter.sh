#!/bin/sh

#Parameters have been set up by J job
#Robert Grumbine

# Note that the analysis job can run without any contents in the output from this.
# That is what the 'touch' at the end is ensuring.

set -x
echo zzzzzzzzzzzzzzz  exseaice_filter: DCOMROOT = $DCOMROOT

#Note, tanks are:
  #export XLFUNIT_11=/dcom/us007003/$PDY/b012/xx012 -- navy SST tank
  #export XLFUNIT_11=/dcom/us007003/$PDY/b021/xx053 -- avcs18
  #export XLFUNIT_11=/dcom/us007003/$PDY/b021/xx054 -- avcl18
#the avcs and avcl are avhrr 'sea' and avhrr 'land' files.  Actually 
#  distinguished by cloud quality flag rather than geography.  'land' is cloudier,
#  which makes it more likely useful for sea ice filtering.
#The navy tank is unused, just noting the existence and difference.

#Note that date is PDYm1 -- this gives full calendar day of data 
if [ ! -f $COMOUT/land.$PDYm1 ] ; then
  echo zzzzz working on land $PDYm1
  if [ -f ${DCOMROOT}/$PDY/b021/xx054 ] ; then
    ln -sf ${DCOMROOT}/$PDY/b021/xx054 fort.11
    touch fort.51
    time $EXECseaice_analysis/seaice_avhrrbufr
    cp fort.51 $COMOUT/land.$PDYm1
    rm fort.51
  else
    echo zzzzz No avhrr 'land' file, continuing without it
    touch $COMOUT/land.$PDYm1
  fi
fi

if [ ! -f $COMOUT/seas.$PDYm1 ] ; then
  echo zzzzz working on seas $PDYm1
  if [ -f ${DCOMROOT}/$PDY/b021/xx053 ] ; then
    ln -sf ${DCOMROOT}/$PDY/b021/xx053 fort.11
    time $EXECseaice_analysis/seaice_avhrrbufr 
    touch fort.51
    cp fort.51 $COMOUT/seas.$PDYm1
    rm fort.51
  else
    echo zzzzz No avhrr 'seas' file, continuing without it
    touch $COMOUT/seas.$PDYm1
  fi
fi

if [ ! -f $COMOUT/land.$PDYm1 ] ; then
  touch $COMOUT/land.$PDYm1
fi

if [ ! -f $COMOUT/seas.$PDYm1 ] ; then
  touch $COMOUT/seas.$PDYm1
fi
