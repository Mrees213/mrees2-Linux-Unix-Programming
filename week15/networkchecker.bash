#!/bin/bash

myIP=$(bash myip.bash)

# Todo-1: Create a helpmenu function that prints help for the script
function helpmenu() {
    echo "Usage: $0 [-n|-s] [internal|external]"
    echo "Options:"
    echo "  -n  Run NMAP scan"
    echo "  -s  Show listening ports using ss"
    echo "Arguments:"
    echo "  internal   Scan localhost"
    echo "  external   Scan network"
    exit 1
}

# Return ports that are serving to the network
function ExternalNmap(){
  rex=$(nmap "${myIP}" | awk -F"[/[:space:]]+" '/open/ {print $1,$4}' )
}

# Return ports that are serving to localhost
function InternalNmap(){
  rin=$(nmap localhost | awk -F"[/[:space:]]+" '/open/ {print $1,$4}' )
}

# Only IPv4 ports listening from network
function ExternalListeningPorts(){
  # Todo-2: Complete the ExternalListeningPorts that will print the port and application
  # that is listening on that port from network (using ss utility)
  elpo=$(ss -ltpn | awk -F"[[:space:]:(),]+" '!/127.0.0./ {print $5,$9}' | tr -d "\"")
  echo "$elpo"
}

# Only IPv4 ports listening from localhost
function InternalListeningPorts(){
  ilpo=$(ss -ltpn | awk  -F"[[:space:]:(),]+" '/127.0.0./ {print $5,$9}' | tr -d "\"")
  echo "$ilpo"
}

# Todo-3: If the program is not taking exactly 2 arguments, print helpmenu
if [ $# -ne 2 ]; then
    helpmenu
fi

# Todo-4: Use getopts to accept options -n and -s (both will have an argument)
while getopts ":n:s:" opt; do
  case $opt in
    n)
      if [ "$OPTARG" = "internal" ]; then
        InternalNmap
        echo "$rin"
      elif [ "$OPTARG" = "external" ]; then
        ExternalNmap
        echo "$rex"
      else
        helpmenu
      fi
      ;;
    s)
      if [ "$OPTARG" = "internal" ]; then
        InternalListeningPorts
      elif [ "$OPTARG" = "external" ]; then
        ExternalListeningPorts
      else
        helpmenu
      fi
      ;;
    \?)
      helpmenu
      ;;
  esac
done
