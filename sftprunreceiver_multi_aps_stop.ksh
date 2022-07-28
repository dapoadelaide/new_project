#!/bin/ksh

receiverAddr="$1"
 
# run script - *.ksh
clear

print ""
print ""
print ""

print "*** Running [su - wasadmin -c cd /opt/csdsftp; ./sftprunreceiver_multi_aps stop ***"
su - wasadmin -c "cd /opt/csdsftp; ./sftprunreceiver_multi_aps stop"
print "Return Code for [su - wasadmin -c cd /opt/csdsftp; ./sftprunreceiver_multi_aps stop]:[$?]"
print "" 
# adios

exit

