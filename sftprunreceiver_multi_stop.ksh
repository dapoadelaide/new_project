#!/bin/ksh

receiverAddr="$1"
 
# run script - *.ksh
clear

print ""
print ""
print ""

print "*** Running [su - wasadmin -c cd /opt/csdsftp; ./sftprunreceiver_multi stop ***"
su - wasadmin -c "cd /opt/csdsftp; ./sftprunreceiver_multi stop"
print "Return Code for [su - wasadmin -c cd /opt/csdsftp; ./sftprunreceiver_multi stop]:[$?]"
print "" 
# adios

exit
