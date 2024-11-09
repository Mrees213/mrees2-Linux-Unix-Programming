#!/bin/bash

logFile="/var/log/apache2/access.log"

function displayAllLogs(){
    cat "$logFile"
}

function displayOnlyIPs(){
    cat "$logFile" | cut -d ' ' -f 1 | sort -n | uniq -c
}

function displayOnlyPages(){
    cat "$logFile" | awk '{print $7}' | sort | uniq -c | sort -rn
}

function histogram(){
    local visitsPerDay=$(cat "$logFile" | cut -d " " -f 4,1 | tr -d '['  | sort | uniq)
    :> newtemp.txt
    echo "$visitsPerDay" | while read -r line;
    do
        local withoutHours=$(echo "$line" | cut -d " " -f 2 | cut -d ":" -f 1)
        local IP=$(echo "$line" | cut -d  " " -f 1)
        echo "$IP $withoutHours" >> newtemp.txt
    done 
    cat "newtemp.txt" | sort -n | uniq -c
}

function frequentVisitors(){
    histogram | awk '$1 > 10 {print $0}'
}

function suspiciousVisitors(){
    grep -f ioc.txt "$logFile" | awk '{print $1}' | sort | uniq -c
}

while :
do
    echo "Please select an option:"
    echo "[1] Display all Logs"
    echo "[2] Display only IPs"
    echo "[3] Display only Pages"
    echo "[4] Histogram"
    echo "[5] Frequent Visitors"
    echo "[6] Suspicious Visitors"
    echo "[7] Quit"

    read userInput
    echo ""

    case "$userInput" in
        1)
            echo "Displaying all logs:"
            displayAllLogs
            ;;
        2)
            echo "Displaying only IPs:"
            displayOnlyIPs
            ;;
        3)
            echo "Displaying only Pages:"
            displayOnlyPages
            ;;
        4)
            echo "Histogram:"
            histogram
            ;;
        5)
            echo "Frequent Visitors:"
            frequentVisitors
            ;;
        6)
            echo "Suspicious Visitors:"
            suspiciousVisitors
            ;;
        7)
            echo "Goodbye"
            break
            ;;
        *)
            echo "Invalid option. Please enter a number between 1 and 7."
            ;;
    esac

    echo ""
done
function displayOnlyPages(){
    cat "access.log" | awk '{print $7}' | sort | uniq -c | sort -rn
}

function frequentVisitors(){
    histogram | awk '$1 > 10 {print $0}'
}

function suspiciousVisitors(){
    grep -f ioc.txt "$access.log" | awk '{print $1}' | sort | uniq -c | sort -rn
}


while :
do
    echo "Please select an option:"
    echo "[1] Display all Logs"
    echo "[2] Display only IPs"
    echo "[3] Display only pages visited"
    echo "[4] Histogram"
    echo "[5] Frequent visitors"
    echo "[6] Suspicious visitors"
    echo "[7] Quit"

    read userInput
    echo ""

    case "$userInput" in
        1)
            echo "Displaying all logs:"
            displayAllLogs
            ;;
        2)
            echo "Displaying only IPs:"
            displayOnlyIPs
            ;;
        3)
            echo "Displaying only pages visited:"
            displayOnlyPages
            ;;
        4)
            echo "Histogram:"
            histogram
            ;;
        5)
            echo "Frequent visitors:"
            frequentVisitors
            ;;
        6)
            echo "Suspicious visitors:"
            suspiciousVisitors
            ;;
        7)
            echo "Goodbye"
            break
            ;;
        *)
            echo "Invalid input. Please try again."
            ;;

   esac
done

    
