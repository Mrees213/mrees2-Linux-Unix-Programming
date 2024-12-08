#!/bin/bash

# URL of the IOC web page
url="http://10.0.17.6/IOC.html"

# File to save the IOC
output_file="IOC.txt"

# Use curl to fetch the web page content and grep to extract the IOC
curl -s "$url" | grep -oE 'etc/passwd|cmd=|/bin/bash|/bin/sh|1=1#|1=1- -' | sort -u > "$output_file"

echo "IOC have been saved to $output_file"




