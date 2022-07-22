#!/bin/bash
#
task_name="run2task"

# Enter the commands you to execute on target host(s) below in runcommands.
# Mulitplie commands must be separated by colon (:)
#
runcommands="ls -ltr /tmp;cd /tmp;pwd:whoami:ls -ltr /var:ls -l /"
# runcommands="ls -ltr /tmp"
###

# Enter the logFile name and the email address(es) you want logs sent to.
logFile="/tmp/mailScript-${task_name}.reportOut"
mailAddr="c@irs.gov a@irs.gov b@irs.gov a@irs.gov b@irs.gov a@irs.gov b@irs.gov a@irs.gov b@irs.gov a@irs.gov b@irs.gov"
#
###

cd /tmp/${task_name}
tar xvf run2task_wrapper.tar 
/tmp/${task_name}/run2task.sh $runcommands >/tmp/run2task.reportOut
# echo "i am in caller: /tmp/${task_name}/run2task.sh $runcommands"
echo "...finito :)"
#
/tmp/${task_name}/mailScript.sh $logFile $mailAddr >/tmp/mailScript-${task_name}.reportOut
echo "---" >>/tmp/mailScript-${task_name}.reportOut
# rm -rf /tmp/${task_name}
#echo "rm -rf /tmp/${task_name} - [$?]" >>/tmp/mailScript-${task_name}.reportOut

