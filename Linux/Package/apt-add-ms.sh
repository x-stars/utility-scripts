#!/bin/bash

function os-info
{
    cat /etc/os-release |
    grep "^$1=" |
    awk -F= '{ print $2 }' |
    sed 's/"//g'
}

ID=$(os-info ID)
VERSION_ID=$(os-info VERSION_ID)

curl https://packages.microsoft.com/keys/microsoft.asc |
apt-key add -

curl https://packages.microsoft.com/config/$ID/$VERSION_ID/prod.list |
tee /etc/apt/sources.list.d/microsoft.list
