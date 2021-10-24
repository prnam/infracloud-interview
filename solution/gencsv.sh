#!/bin/bash

index=0
entries=10
file=inputFile


if [[ -n "$1" ]] && [[ "$#" -eq 1 ]]; then
    if [[ $1 == "$(echo $1 | awk '{print strtonum($0)}')" ]] && [[ "$1" > 0 ]]; then
    entries=$1
    else
    echo "Invalid arguement! Please check necessary docs for more details."
    exit 1
    fi
fi

> $file

for ((index=0;index<$entries;index++)); do
    echo $index, $RANDOM >> $file
done

if [[ -e $file ]]; then
 chmod 766 $file
 cat $file
fi
