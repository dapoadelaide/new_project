#!/bin/bash
#
task_name="dr_shutdown"

# Enter the logFile name and the email address(es) you want logs sent to.
logFile="/tmp/mailScript-${task_name}.reportOut"
mailAddr="c@irs.gov a@irs.gov b@irs.gov a@irs.gov b@irs.gov a@irs.gov b@irs.gov a@irs.gov b@irs.gov a@irs.gov b@irs.gov"
#
cd /tmp/${task_name}
tar xvf dr_shutdown_wrapper.tar 
/tmp/${task_name}/dr_shutdown_wrapper.sh >/tmp/dr_shutdown.reportOut
/tmp/${task_name}/mailScript.sh $logFile $mailAddr
echo "---" >>/tmp/mailScript-${task_name}.reportOut
#rm -rf /tmp/${task_name}
echo "rm -rf /tmp/${task_name} - [$?]" >>/tmp/mailScript-${task_name}.reportOut

