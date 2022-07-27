#!/bin/bash
# run2task_param.sh
# yml: run2task_param.yml

#pa - 12/23/2018 updated to email log to the user and other addresses
#
######################################

echo ""
echo "       .................................. Report ......................................"
echo "       ....................... Date: `date '+%m/%d/%Y %H:%M:%S'` .............................."
echo ""

# echo "i am in run2task now" 
# echo "Command(s) entered for here: [$@]"

if [[ -z "$@" ]] ; then
  runUsage
fi 

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
  echo "******************************************************************************** "
  echo "*****************************    RUN SUMMARY   ********************************* "
  echo "******************************************************************************** "
  
   if [[ "$p" -gt 0 ]]
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
 
   if [[ "$f" -gt 0 ]]
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
 
##########
# start
##########
 
userId=`id`
subjectFlag="on"
messageBody=/tmp/messageBody
cat /dev/null >${messageBody}

oldifs=$IFS
IFS=':'
read -a inputCommands <<< "$@"
# echo "inputCommands #1 : ${inputCommands[0]}"
echo "There are ${#inputCommands[*]} commands(s) entered" 
IFS=$oldifs

for cmd in "${inputCommands[@]}"; do
  echo "cmd[$cmd]"
  if [[ $subjectFlag == "on" ]] ; then 
        subjectLine="$cmd"
        subjectFlag="off"
        echo "Command:[${inputCommands[@]}]" >>${messageBody} 
        echo "Found subjectLine [$subjectLine] ... i am breaking the loop"
        break
   fi
done

echo "Command[s] arrayed: [${inputCommands[@]}]"

echo "sleeping 10"
sleep 10

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
                echo "Command Completed Successfully ..."
                echo "Command PASSED with error code: $cmd_rc"
                passedCommands[$p]="$cmd"
                ((p=p+1))
        else
                echo "Command FAILED with error code: $cmd_rc ..."
                failedCommands[$f]="$cmd"
                ((f=f+1))
        fi
done
 
# do summary report
runSummary
 
# adios
exit
