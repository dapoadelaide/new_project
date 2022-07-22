#!/bin/bash

 
# start
##########
 
userId=`id`
entryCnt=1
subjectFlag="on"
messageBody=/tmp/messageBody
#cat /dev/null >${messageBody}
echo " " >${messageBody}

receiverAddr="$@"
for inputItem in "$@"
 do
   # if [[ $inputItem == *"/tmp"* ]]; then
   if [[ $inputItem == *"reportOut"* ]]; then
      for file in $inputItem
         do 
            # if [[ $file == *"/tmp"* ]]; then
            if [[ $file == *"reportOut"* ]]; then
                  fileToGet="$file"
                  echo "Log to email: $fileToGet "
                  break 
            fi 
       done
    fi 
 done

echo ""
echo "         .................................. Report ......................................"
echo "         ....................... Date: `date '+%m/%d/%Y %H:%M:%S'` .............................."
echo ""
echo " Logfile to email: $fileToGet "
echo " ****************"
echo ""

# do emailing
box=`hostname `
senderAddr="root"
subject="Subject"
reply_email="${box} <${senderAddr}>"
# subject="RUNTASK [ ${fileToGet_basename} ] from ${box}"
# subject="RUNTASK [ ${subjectLine} ] from ${box}"
 
os_name=`uname `
case $os_name in
  SunOS)
    for email in ${receiverAddr}
    do
      # mailx -i -s "${subject}" -r "${reply_email}" ${email} < ${fileToGet}
      # mailx -a ${fileToGet} -s "${subject}" -r "${reply_email}" ${email} < ${messageBody}
      echo "${fileToGet_basename} Sent To: [${email}] ..."
    done
  ;;
  Linux)
    for email in ${receiverAddr}
    do
        # if [[ $email  == *"/tmp"* ]]; then
        if [[ $email  == *"reportOut"* ]]; then
           continue
         fi

      # mail -i -s "${subject}" -r "${reply_email}" ${email} < ${fileToGet}
        mailx -a ${fileToGet} -i -s "${subject}" -r "${reply_email}" ${email} < ${messageBody}
        echo " mailx -a ${fileToGet} -i -s "${subject}" -r "${reply_email}" ${email} < ${messageBody}"
#       echo "${fileToGet} Sent To: [${email}] ..."
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
# echo "remvoving log [${fileToGet}]"
# rm -f ${fileToGet} ${messageBody}
# echo "removed log [${fileToGet}]- [rc:$?]"
echo ""
echo ""
 
exit
 
# adios
 
 
 
exit
dev/null
