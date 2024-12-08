#!/bin/bash

# Log the access to fileaccesslog.txt

echo "$(date '+%Y-%m-%d %H-%M-%S') - File accessed: $1" >> /home/champuser/fileaccesslog.txt

# Email the contents of fileaccesslog.txt
echo "To: morgan.rees@mymail.champlain.edu" > /home/champuser/temp_email.txt
echo "Subject: Accesslogs" >> /home/champuser/temp_email.txt

sed 's/:/-/g' /home/champuser/fileaccesslog.txt >> /home/champuser/temp_email.txt

cat /home/champuser/temp_email.txt | ssmtp morgan.rees@mymail.champlain.edu




