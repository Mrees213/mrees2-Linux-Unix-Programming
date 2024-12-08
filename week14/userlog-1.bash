#!/bin/bash

authfile="/var/log/auth.log"

function getLogins(){
 logline=$(cat "$authfile" | grep "systemd-logind" | grep "New session")
 dateAndUser=$(echo "$logline" | cut -d' ' -f1,2,11 | tr -d '\.')
 echo "$dateAndUser" 
}

function getFailedLogins(){
 failedLines=$(cat "$authfile" | grep "Failed password")
 dateAndIP=$(echo "$failedLines" | awk '{print $1, $2, $11}')
 echo "$dateAndIP"
}

# Sending logins as email
echo "To: morgan.rees@mymail.champlain.edu" > /home/champuser/Sys-320-Ubuntu/mrees2-sys-320-1/week14/emailform.txt
echo "Subject: Logins" >> /home/champuser/Sys-320-Ubuntu/mrees2-sys-320-1/week14/emailform.txt

getLogins >> /home/champuser/Sys-320-Ubuntu/mrees2-sys-320-1/week14/emailform.txt

cat /home/champuser/Sys-320-Ubuntu/mrees2-sys-320-1/week14/emailform.txt | ssmtp morgan.rees@mymail.champlain.edu

# Sending failed logins as email
echo "To: morgan.rees@mymail.champlain.edu" > /home/champuser/Sys-320-Ubuntu/mrees2-sys-320-1/week14/failed_emailform.txt
echo "Subject: Failed Logins" >> /home/champuser/Sys-320-Ubuntu/mrees2-sys-320-1/week14/failed_emailform.txt

getFailedLogins >> /home/champuser/Sys-320-Ubuntu/mrees2-sys-320-1/week14/failed_emailform.txt
cat /home/champuser/Sys-320-Ubuntu/mrees2-sys-320-1/week14/failed_emailform.txt | ssmtp morgan.rees@mymail.champlain.edu

