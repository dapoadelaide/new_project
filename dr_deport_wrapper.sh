#!/bin/ksh
# yml:  dr_deport.yml

# start
#
date
pwd
id

# receiverAddr="$1"

# run dr_deport.ksh
clear

print ""
print ""
print ""

print "*** Running [vxdg list before deport] ***"
/usr/sbin/vxdg list
print "Return Code for [vxdg list]:[$?]"
print ""
print ""
print ""

print "*** Running [ dr_deport.ksh ] ***"
/disaster_recovery/dr_deport.ksh
print "Return Code for [/disaster_recovery/dr_deport.ksh]:[$?]"
print ""
print ""
print ""

print "Sleeping for 5 minutes ..........[Started: `date '+%m%d%Y-%H%M%S'`]"
sleep 300
print "Woke up from 5 minutes of sleep..[Woke up: `date '+%m%d%Y-%H%M%S'`]"
print ""
print ""
print ""

print "*** Running [vxdg list after deport] ***"
/usr/sbin/vxdg list
print "Return Code for [vxdg list]:[$?]"
#
#########################################################
