#!/bin/bash

myIP=$(bash myip.bash)

# Help menu function
function helpmenu() {
    echo "-n: Add -n as an argument for this script to use nmap"
    echo "-n external: External NMAP scan"
    echo " -n internal: Internal NMAP scan"
    echo " -s: Add -s as an argument for this script to use ss"
    echo " -s external: External ss(Netstat)  scan"
    echo "  $0 -s internal: Internal ss(Netsat)  scan"
}

# Return ports that are serving to the network
function ExternalNmap(){
    rex=$(nmap "${myIP}" | awk -F"[/[:space:]]+" '/open/ {print $1,$4}' )
    echo "$rex"
}

# Return ports that are serving to localhost
function InternalNmap(){
    rin=$(nmap localhost | awk -F"[/[:space:]]+" '/open/ {print $1,$4}' )
    echo "$rin"
}

# Only IPv4 ports listening from network
function ExternalListeningPorts(){
    elpo=$(ss -ltpn | awk -F"[[:space:]:(),]+" '!/127.0.0./ && /LISTEN/ {print $5,$9}' | tr -d "\"")
    echo "$elpo"
}

# Only IPv4 ports listening from localhost
function InternalListeningPorts(){
    ilpo=$(ss -ltpn | awk  -F"[[:space:]:(),]+" '/127.0.0./ {print $5,$9}' | tr -d "\"")
    echo "$ilpo"
}

# Check if the program is taking exactly 2 arguments
if [ $# -ne 2 ]; then
    helpmenu
    exit 1
fi

# Use getopts to handle options
while getopts "n:s:" opt; do
    case $opt in
        n)
            if [ "$OPTARG" = "external" ]; then
                ExternalNmap
            elif [ "$OPTARG" = "internal" ]; then
                InternalNmap
            else
                helpmenu
                exit 1
            fi
            ;;
        s)
            if [ "$OPTARG" = "external" ]; then
                ExternalListeningPorts
            elif [ "$OPTARG" = "internal" ]; then
                InternalListeningPorts
            else
                helpmenu
                exit 1
            fi
            ;;
        *)
            helpmenu
            exit 1
            ;;
    esac
done

