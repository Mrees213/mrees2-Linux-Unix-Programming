#!/bin/bash
clear

# filling courses.txt
bash courses.bash

courseFile="courses.txt"

function displayCoursesofInst(){
    echo -n "Please Input an Instructor Full Name: "
    read instName

    echo ""
    echo "Courses of $instName :"
    cat "$courseFile" | grep "$instName" | cut -d';' -f1,2 | \
    sed 's/;/ | /g'
    echo ""
}

function courseCountofInsts(){
    echo ""
    echo "Course-Instructor Distribution"
    cat "$courseFile" | cut -d';' -f7 | \
    grep -v "/" | grep -v "\.\.\." | \
    sort -n | uniq -c | sort -n -r 
    echo ""
}

# TODO - 1
function displayCoursesInLocation(){
    echo -n "Please Input a Location: "
    read location

    echo ""
    echo "Courses in $location:"
    cat "$courseFile" | grep "$location" | cut -d';' -f1,2,3,4,7 | \
    sed 's/;/ | /g'
    echo ""
}

# TODO - 2
function displayAvailableCourses(){
    echo -n "Please Input a Course Code: "
    read courseCode

    echo ""
    echo "Available Courses for $courseCode:"
    cat "$courseFile" | grep "^$courseCode" | awk -F';' '$6 > 0 {print $1 " | " $2 " | " $3 " | " $4 " | " $7}'
    echo ""
}

while :
do
    echo ""
    echo "Please select an option:"
    echo "[1] Display courses of an instructor"
    echo "[2] Display course count of instructors"
    echo "[3] Display courses in a location"
    echo "[4] Display available courses for a course code"
    echo "[5] Exit"

    read userInput
    echo ""

    if [[ "$userInput" == "5" ]]; then
        echo "Goodbye"
        break

    elif [[ "$userInput" == "1" ]]; then
        displayCoursesofInst

    elif [[ "$userInput" == "2" ]]; then
        courseCountofInsts

    elif [[ "$userInput" == "3" ]]; then
        displayCoursesInLocation

    elif [[ "$userInput" == "4" ]]; then
        displayAvailableCourses

    # TODO - 3 Display a message, if an invalid input is given
    else
        echo "Invalid input. Please select a valid option (1-5)."
    fi
done
