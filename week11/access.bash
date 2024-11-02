#!bin/bash


allLogs=""
file="/var/log/apache2/access.log"



function getAllLogs(){
allLogs=$(cat "$file" | cut -d' '  -f1,4,7 | tr -d "[")
}


function ips(){ 
ipsAccessed=$(echo "$allLogs" | cut -d' ' -f1)
}

function pageCount() { 
countpage=$(awk '{print $7}' "$file" | sort | uniq -c | sort -rn)
}


pageCount
getAllLogs
ips
#echo "$ipAccessed"
echo "$countpage"
