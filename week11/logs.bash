#!bin/bash

allLogs=""
file="/var/log/apache2/access.log"


function getAllLogs(){
allLogs=$(cat "$file" |  cut -d' '  -f1,4,7 | tr -d "[")
}

function ips(){
ipsAccessed=$(echo "$allLogs" | cut -d' ' -f1)
}

function pageCount() {
declare -A pageCount
while IFS=' ' read -r_ _page; do 

}

getAllLogs



pageAccesscount
