#!/bin/sh
# Set apt source host.

ARC_SOURCE=archive.ubuntu.com
SEC_SOURCE=security.ubuntu.com

NEW_SOURCE=$1
while [ "$NEW_SOURCE" = "" ]; do
    read -r -p "New source: " NEW_SOURCE
done

SOURCE_LIST=/etc/apt/sources.list
if [ -e "$SOURCE_LIST.org" ]; then
    echo "Sources backup exists."
    exit 1
fi
cp $SOURCE_LIST $SOURCE_LIST.org

sed -i "s,$ARC_SOURCE,$NEW_SOURCE,g" $SOURCE_LIST
sed -i "s,$SEC_SOURCE,$NEW_SOURCE,g" $SOURCE_LIST
