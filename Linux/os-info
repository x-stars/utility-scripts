#!/bin/bash

if [ $# -eq 0 ]
then
    cat /etc/os-release
else
    for n in $*
    do
        cat /etc/os-release |
        grep ^$n= |
        awk -F '=' '{ print $2 }' |
        sed 's/"//g'
    done
fi
