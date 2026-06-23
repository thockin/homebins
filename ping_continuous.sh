#!/bin/bash

GATEWAY="10.5.69.1"

clear
OK=0
HADERR=0
while true; do
    D=$(date)
    #if [[ $HADERR -eq 1 ]]; then
    #    echo "$D" # with newline
    #fi
    echo -ne "\r$D   cycle: ${OK}" # no newline

    R8=$(ping -i 0.1 -c 100 -q 8.8.8.8 2>&1 | grep -E 'packet loss|rtt')
    LOSS8=$(echo "$R8" | grep "packet loss" | awk '{print $6}' | sed 's/%//')
    AVG8=$(echo "$R8" | grep "rtt" | awk '{print $4}' | awk -F/ '{print $2}')
    MAX8=$(echo "$R8" | grep "rtt" | awk '{print $4}' | awk -F/ '{print $3}')
    AVGWHOLE=$(echo "$AVG8" | cut -f1 -d.)
    if [[ $LOSS8 -gt 1 || $AVG8WHOLE -gt 100 ]]; then
        echo # newline
        echo "packet loss: $LOSS8%"
        echo "avg latency: $AVG8 ms"
        echo "max latency: $MAX8 ms"
        ping -w 1 -c 1 -q $GATEWAY >/dev/null 2>&1
        if [[ $? -eq 0 ]]; then
            echo "gateway is up"
        else
            echo "gateway is unreachable"
        fi
        echo
        if [[ $HADERR -eq 0 ]]; then
            play -q $HOME/siren-short.wav 2>/dev/null
            OK=0
            HADERR=1
        fi
    else
        OK=$((OK + 1))
        HADERR=0
    fi
    sleep 1
done

