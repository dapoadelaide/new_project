#!/bin/bash
# yml: dr_shutdown.yml

# start
echo ""
# echo "***************************************************************************************"
echo ""
#date
#pwd
#id
echo "       ******** Host: `hostname`"
echo ""
echo "       .................................. Report ......................................"
echo "       .........................Script: dr_shutdown.sh ................................"
echo "       ....................... Date: `date '+%m/%d/%Y %H:%M:%S'` .............................."
echo ""
echo ""
echo "*** Running [HASTATUS before shutdown] ***"
/opt/VRTSvcs/bin/hastatus -sum 
echo "Return Code for [/opt/VRTSvcs/bin/hastatus -sum]:[$?]"

echo ""
echo "*** Running [ dr_shutdown.ksh ] ***"
/disaster_recovery/dr_shutdown.ksh
echo "Return Code for [/disaster_recovery/dr_shutdown.ksh]:[$?]"

echo ""
runsleep=10 
echo "Sleep: $runsleep"
echo "*** Sleeping for $runsleep seconds ***"
sleep $runsleep
echo "Woke up from $runsleep seconds of sleep..[Woke up: `date '+%m%d%Y %H:%M:%S'`]"
echo ""

echo "*** Running [HASTATUS after shutdown] ***"
/opt/VRTSvcs/bin/hastatus -sum
echo "Return Code for [/opt/VRTSvcs/bin/hastatus -sum]:[$?]"

#
echo ""
echo ""
echo "***************************************************************************************"
echo ""
echo ""

# adios
exit

 
