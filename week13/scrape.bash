#!/bin/bash


url="http://10.0.17.6/Assignment.html"
html_content=$(curl -s $url)


table1=$(echo "$html_content" | pup 'table:nth-of-type(1) tr text{}' | sed '/^$/d')
table2=$(echo "$html_content" | pup 'table:nth-of-type(2) tr text{}' | sed '/^$/d')


num_rows=$(echo "$table1" | wc -l)


for i in $(seq 1 $num_rows); do
  row1=$(echo "$table1" | sed -n "${i}p")
  row2=$(echo "$table2" | sed -n "${i}p")
  echo "$row1 | $row2"
done


