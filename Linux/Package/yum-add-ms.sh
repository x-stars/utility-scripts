#!/bin/sh
# Add Microsoft source to yum.

osinfo ()
{
    cat /etc/os-release |
    grep "^$*=" |
    awk -F= '{ print $2 }' |
    sed 's/"//g'
}

ID=$(osinfo ID)
VERSION_ID=$(osinfo VERSION_ID)

curl https://packages.microsoft.com/config/$ID/$VERSION_ID/prod.repo |
tee /etc/yum.repos.d/microsoft.repo
