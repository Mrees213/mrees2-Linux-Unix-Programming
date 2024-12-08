#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage: $0 <log_file> <ioc_file>"
    exit 1
fi

log_file="$1"
ioc_file="$2"
output_file="report.txt"

# Create an array of IOCs from the ioc_file
mapfile -t iocs < "$ioc_file"
for i in ${iocs[@]}; do echo $i; done

# Process the log file and save results to report.txt
awk -v iocs="${iocs[*]}" '
BEGIN {
    split(iocs, ioc_array, " ")
    for (i in ioc_array) ioc_set[ioc_array[i]] = 1
}
{
   for (ioc in ioc_set) {
        if (index($0, ioc) > 0) {
            printf "%s %s %s\n", $1, $4 " " $5, $7
            next
        }
    }
}
' "$log_file" > "$output_file"

echo "Report saved to $output_file"

