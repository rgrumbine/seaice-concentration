#!/bin/ksh

set -x

### Definition of the Fix fields:
export FNLAND127=${FNLAND127:-${FIXseaice_analysis}/seaice_nland127.map}
export FSLAND127=${FSLAND127:-${FIXseaice_analysis}/seaice_sland127.map}

cd $DATA
echo zzz entered scripts/amsr3l2.sh
exit
# compositor has already run

#----------------------------------------------------------
# Run the L2 --> L3 analysis on the AMSR files
# Input files =  amsr.bufr, $FIXseaice_analysis/seaice_nland127.map, $FIXseaice_analysis/seaice_sland127.map
# Output files = amsr3north.$PDY, amsr3south.$PDY
#New 5 Aug 2016 -- amsr3
#----------------------------------------------------------

export pgm=seaice_amsr3comp
. prep_step
startmsg
time $EXECseaice_analysis/seaice_amsr3comp $FNLAND127 $FSLAND127 \
           amsr3north6.$PDY amsr3south6.$PDY \
	   # amsr3read files here
           >> $pgmout 2>errfile
export err=$?;err_chk

