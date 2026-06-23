#!/bin/sh

rm /tmp/stats;
while true; do
    ping -w30 -c1 8.8.8.8 \
        | grep 'time=.*' \
        | awk '{print $7}' \
        | cut -f2 -d= \
        >> /tmp/stats;
    cat /tmp/stats \
        | ministat -n \
        | grep --line-buffered -v stdin;
    sleep 1;
done
