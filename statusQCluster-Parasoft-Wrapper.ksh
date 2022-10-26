#!/bin/ksh
#user:mqm
#group:mqm
#interp:sol

#####################################################
# StatusQCluster.ksh                                #
# ================================================= #
# Note:  This script must be executed as "mqm".     #
# ================================================= #
# This script is for a Tivoli Task.  The script     #
# executes the "statusQCluster script that must     #
# reside in /var/mqm/scripts.  This script will look#
# for Cluster Queues in a specified Cluster on a    #
# specific Queue Manager.                           # 
# ================================================= #
# Parameters are:                                   #
#    (1) Cluster Name                    Required.  #
#    (2) Queue Manager Name              Required.  #
#####################################################

# Added by PAdelaide - ESM - 10/17/2011
# Updated for logging by PAdelaide - IBM/IRS - 05/19/2018
# task is run by root, therefore 'dspmq' command binaries will be sourced correctly for the root id.
# but mqm id is used to run the core script (/var/mqm/scripts/addQCluster.ksh)
###################################################################################################


# clear the logfile
log="/tmp/$0.logfile.`date '+%m%d%Y-%H%M%S'`.txt"
# >$log

pipe1="/tmp/regular_pipe.$$"
pipe2="/tmp/error_pipe.$$"
trap 'rm "$pipe1" "$pipe2"' EXIT

mkfifo "$pipe1"
mkfifo "$pipe2"
tee -a $log < "$pipe1" &
tee -a $log >&2 < "$pipe2" &

# Redirect output to a logfile as well as their normal locations
exec >"$pipe1"
exec 2>"$pipe2"

chmod 644 $log

#
# start
#
date
pwd
id


receiverAddr="$1"

ECHO ()
{
    echo "`date '+%m/%d/%y %H:%M:%S'` $1"
}

if [ $# -eq 1 ]; then
     # use default parameters
     cluster_name=AMDAS_WEBAPP_CLUSTER
     qmgr_name=`dspmq | grep QMNAME | awk -F'(' '{print $2}' | awk -F')' '{print $1}' | sed -n "1p"`
else
    # write incorrect # of arguments passed
    ECHO "ERROR: Incorect # of arguments passed to script - Aborting..."
    exit
fi

# /var/mqm/scripts/parasoftStatusQCluster.sh $1 $2
# ECHO "Command: [su - mqm -c cd /var/mqm/scripts;  /var/mqm/scripts/parasoftStatusQCluster.sh $cluster_name $qmgr_name]"
# su - mqm -c "cd /var/mqm/scripts; /var/mqm/scripts/parasoftStatusQCluster.sh $cluster_name $qmgr_name"

ECHO "Command: [su - mqm -c cd /var/mqm/scripts;  /var/mqm/scripts/parasoftStatusQCluster.sh $qmgr_name $cluster_name]"
su - mqm -c "cd /var/mqm/scripts; /var/mqm/scripts/parasoftStatusQCluster.sh $qmgr_name $cluster_name"

# ==================== #
# END OF SHELL SCRIPT. #
# ==================== #
#
#########################################################

chmod 644 $log

# do emailing

messageBody=/tmp/messageBody
cat /dev/null >${messageBody}

# receiverAddr="$2"
fileToGet="$log"
fileToGet_basename=`basename $log`
fileToGetTMP="/tmp/${fileToGet_basename}"
echo "[$fileToGetTMP]" >${messageBody}  
box=`hostname `
# reply_email="${box} <${senderAddr}>"
subject="[ ${fileToGet_basename} ] from ${box}"
sleep 10

os_name=`uname `
case $os_name in
  SunOS)
    for email in ${receiverAddr}
    do
      reply_email="${box} <${email}>"
      echo "mailx -i -s ${subject} -r ${reply_email} ${email} < ${fileToGetTMP}"
      # mailx -i -s "${subject}" -r "${reply_email}" ${email} < ${fileToGet}
      mailx -i -s "${subject}" -r "${reply_email}" ${email} < ${fileToGetTMP}
      
# mailx -a ${fileToGet} -s "${subject}" -r "${reply_email}" ${email} < ${messageBody}

      echo "${fileToGetTMP} Sent To: [${email}] ..."
    done
  ;;
  Linux)
    for email in ${receiverAddr}
    do
      # echo "mail -i -s ${subject} -r ${reply_email} ${email}<${fileToGetTMP}"
       ls -ltr ${fileToGetTMP}
sleep 15
      # mail -i -s "${subject}" -r "${reply_email}" ${email}<${fileToGetTMP}

      # echo "mailx -a ${fileToGetTMP} -i -s ${subject} -r ${reply_email} ${email} < ${fileToGetTMP}"
      #mailx -a ${fileToGetTMP} -i -s "${subject}" -r "${reply_email}" ${email} < ${fileToGetTMP}

      reply_email="${box} <${email}>"
      echo "mailx -a ${fileToGetTMP} -i -s ${subject} -r ${reply_email} ${email}<${messageBody}"
      mailx -a ${fileToGetTMP} -i -s "${subject}" -r "${reply_email}" ${email}<${messageBody}

      echo "${fileToGetTMP} Sent To: [${email}] ..."
    done
  ;;
  *)
    for email in ${receiverAddr}
    do
      mail -i -s "${subject}" -r "${reply_email}" ${email} < ${fileToGetTMP}
      # mailx -a ${fileToGet} -i -s "${subject}" -r "${reply_email}" ${email} < ${messageBody}
      echo "${fileToGetTMP} Sent To: [${email}] ..."
    done
  ;;
esac
# adios

exit

