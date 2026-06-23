#!/bin/sh

while true; do
    echo -n "$(date)  =>  ";
    X=$(ping -w5 -c1 8.8.8.8 \
        | grep 'time=.*' \
        | awk '{print $7, $8}' \
        | cut -f2 -d= \
        | grep --line-buffered --color=always '.');
    echo "$X";
    sleep 1;
done
