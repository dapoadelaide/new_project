#!/bin/ksh

receiverAddr="$1"
 
# run script - *.ksh
clear

print ""
print ""
print ""

print "*** Running [su - wasadmin -c cd /opt/csdsftp; ./sftprunreceiver_multi_aps start ***"
su - wasadmin -c "cd /opt/csdsftp; ./sftprunreceiver_multi_aps start"
print "Return Code for [su - wasadmin -c cd /opt/csdsftp; ./sftprunreceiver_multi_aps start]:[$?]"
print "" 
# adios

exit
