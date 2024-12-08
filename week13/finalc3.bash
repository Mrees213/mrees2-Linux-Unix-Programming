#!/bin/bash

# Define input and output files
input_file="report.txt"
output_file="/var/www/html/report.html"

# Start HTML content
echo "<html>Access Logs with IOC indicators: <body><table border='1'>" > "$output_file"

# Read input file and convert to HTML table rows
while IFS= read -r line; do
    echo "<tr><td>$line</td></tr>" >> "$output_file"
done < "$input_file"

# End HTML content
echo "</table></body></html>" >> "$output_file"

echo "HTML report generated and moved to $output_file"

