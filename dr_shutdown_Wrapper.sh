#!/bin/bash

# start
echo ""
# echo "***************************************************************************************"
echo ""
#date
#pwd
#id

echo "       Hostname: `hostname`"
#echo "       Hostname: `hostname`" >/tmp/HOSTNAME.OUT
echo "       ********"
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

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

 

From: Adelaide Paul (Contractor)
Sent: Friday, July 1, 2022 12:45 PM
To: 'pauladelaide@gmail.com' <pauladelaide@gmail.com>; 'pauladelaide@yahoo.com' <pauladelaide@yahoo.com>
Subject: run2task ksh

 

#!/bin/ksh

#pa - 05/23/2018 for MeF/PETE IBM/IRS

#pa - 12/23/2018 updated to email log to the user and other addresses

#

######################################

 

# clear the logfile

log="/tmp/$0.`date '+%m%d%Y-%H%M%S'`.logfile"

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

 

# chmod 644 $log

 

getOut(){

echo "[`date '+%m/%d/%Y %H:%M:%S'`]: Commands [$arg] is not supported [rc:$?] ... exiting script"

exit

}

 

msgOut(){

echo "[`date '+%m/%d/%Y %H:%M:%S'`]: $msg"

}

 

runUsage(){

     # clear

     echo "[$@]"

     echo "USAGE Example1: ./run2task.ksh <Command1> <Command2> \"<Command3 Argument1 Agument2 ... Argument[n]>\"  ... <Command[n]> "

     echo "USAGE Example2: ./run2task.ksh \"<Command1>;<Command2>;<Command3>;...<Command[n]>\" "

     echo ""

     echo "                                     *** NOTE ***"

     echo "                                         ===="

     echo "       - Multiple separate Commands can be separated with a space - no quote is required (e.g. USAGE Example1 above)."

     echo "       - Multiple separate Commands can be separated with semi-colon - quote is required (e.g. USAGE Example2 above)."

     echo "       - Command with argument(s) or space(s) must be quoted - e.g. Command3 in USAGE example1 above."

     echo "       - If Command is a script or app, then absolute path must be supplied."

     echo ""

     exit 1

}

 

buildEmail(){

     receiverAddr="${arg}"

     if [[ $receiverAddr == *"@irs.gov"* ]]; then

           # echo "[${receiverAddr}] contains mailing address(es)!"

           for email in ${receiverAddr}

           do

             if [[ -z "${senderAddr}" ]]; then

               senderAddr="${email}"

              fi

           done   

      fi

}

 

runSummary(){

  echo "\n\n\n******************************************************************************** "

  echo "*****************************    RUN SUMMARY   ********************************* "

  echo "******************************************************************************** "

  

   if [ "$p" -gt 0 ]

   then

        echo ""

        echo "COMMANDS SUCCESSFUL:"

        echo "==================="

        echo "*** [$p] command(s) executed successfully. ***"

        for pc in "${passedCommands[@]}" ; do

            echo  "Successful command: $pc"

        done

        echo ""

        echo "*** Successful command(s) entered: [ ${passedCommands[@]} ] ***"

        echo ""

   fi

 

   if [ "$f" -gt 0 ]

  then

        echo ""

        echo "COMMANDS FAILED:"

        echo "==============="

        echo "*** [$f] command(s) executed with failure. ***"

        for fc in "${failedCommands[@]}" ; do

            echo "Failed command: $fc"

        done

        #

 

        echo ""

        echo "*** Error command(s) entered: [ ${failedCommands[@]} ] ***"

        echo ""

   fi

 

}

 

if [ -z "$@" ] ; then

  runUsage

fi

 

##########

# start

##########

 

userId=`id`

entryCnt=1

subjectFlag="on"

messageBody=/tmp/messageBody

cat /dev/null >${messageBody}

# clear

echo "\nCommand(s) entered: [$@]\n"

for arg in "$@"

do

   if [[ $subjectFlag == "on" ]] ; then

       subjectLine="$arg"

       subjectFlag="off"

   fi

        

   echo "Command:[${arg}]" >>${messageBody} 

#

  # echo "$arg" | grep -w "rmdir"

  # echo "$arg" | grep -w "rmdir"  > /dev/null

  # if [ $? = 0 ] ; then

  #    getOut

  # fi

#

  # echo "$arg" | grep -w "rm" > /dev/null

  # if [ $? = 0 ] ; then

  #     getOut

  # fi

 

#  inputCommands[$entryCnt]="$1" # works just as well

   echo "Command=$arg"

 

#  extract email addresses

   if [[ $arg == *"@irs.gov"* ]]; then

      echo "Contains mailing address(es) ... will email logs to address(es)."

      buildEmail

      shift

   else

      inputCommands[$entryCnt]="$arg"

      (( entryCnt=entryCnt+1 ))

      shift

    fi

done

 

echo "\nCommand[s] arrayed: [${inputCommands[@]}]\n"

 

p=0

f=0

for cmd in "${inputCommands[@]}" ; do

        echo ""

        echo "*************************** Command(s) to run: [$cmd]   *****************************"

        echo ""

        echo "Executing..."

        echo ""

        eval $cmd 2>&1

        cmd_rc=$?

        if [ $cmd_rc = 0 ]

        then

                echo ""

                echo "\nCommand Completed Successfully ..."

                echo "Command PASSED with error code: $cmd_rc"

                passedCommands[$p]="$cmd"

                ((p=p+1))

        else

                echo "\nCommand FAILED with error code: $cmd_rc ..."

                failedCommands[$f]="$cmd"

                ((f=f+1))

        fi

done

 

# do summary report

runSummary

chmod 644 $log

 

# do emailing

fileToGet="$log"

fileToGet_basename=`basename $log`

box=`hostname `

reply_email="${box} <${senderAddr}>"

# subject="RUNTASK [ ${fileToGet_basename} ] from ${box}"

subject="RUNTASK [ ${subjectLine} ] from ${box}"

 

os_name=`uname `

case $os_name in

  SunOS)

    for email in ${receiverAddr}

    do

       mailx -i -s "${subject}" -r "${reply_email}" ${email} < ${fileToGet}

      # mailx -a ${fileToGet} -s "${subject}" -r "${reply_email}" ${email} < ${messageBody}

      echo "${fileToGet_basename} Sent To: [${email}] ..."

    done

  ;;

  Linux)

    for email in ${receiverAddr}

    do

      # mail -i -s "${subject}" -r "${reply_email}" ${email} < ${fileToGet}

      mailx -a ${fileToGet} -i -s "${subject}" -r "${reply_email}" ${email} < ${messageBody}

      echo "${fileToGet_basename} Sent To: [${email}] ..."

    done

  ;;

  *)

    for email in ${receiverAddr}

    do

      # mail -i -s "${subject}" -r "${reply_email}" ${email} < ${fileToGet}

      mailx -a ${fileToGet} -i -s "${subject}" -r "${reply_email}" ${email} < ${messageBody}

      echo "${fileToGet_basename} Sent To: [${email}] ..."

    done

  ;;

esac

echo ""

echo "remvoving log [${fileToGet}]"

rm ${fileToGet} ${messageBody}

echo "removed log [${fileToGet}]- [rc:$?]"

echo ""

echo ""

 

echo "#!/bin/ksh" >/tmp/cleanlog

echo "sleep 30" >>/tmp/cleanlog

echo "rm /opt/tmp/`basename $PWD`.lo*" >>/tmp/cleanlog

echo "exit" >>/tmp/cleanlog

nohup /tmp/cleanlog &

ps -ef|grep -i cleanlog >/tmp/cleanlog.psout

chmod 744 /tmp/cleanlog

chmod 744 /tmp/cleanlog.psout

exit

 
