#!/bin/sh
# Add Microsoft source to apt.

osinfo ()
{
    cat /etc/os-release |
    grep "^$*=" |
    awk -F= '{ print $2 }' |
    sed 's/"//g'
}

ID=$(osinfo ID)
VERSION_ID=$(osinfo VERSION_ID)

curl https://packages.microsoft.com/keys/microsoft.asc |
apt-key add -

curl https://packages.microsoft.com/config/$ID/$VERSION_ID/prod.list |
tee /etc/apt/sources.list.d/microsoft.list
