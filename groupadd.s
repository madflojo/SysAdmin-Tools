#!/bin/bash
#### Description: Adds groups based on provided CSV file 
#### CSV file must use : as seperator
#### gid:groupname
#### Written by: Benjamin Cane @ 03-2012

## Check Input
if [ -z $1 ]
then
    echo "`basename $0` <csvfile>"
    exit 1
fi

if [ ! -r $1 ] 
then
   echo "Cannot open file"
   exit 1
fi

## Set Field Seperator to :
IFS=$'\n'

for x in `cat $1`
do

    NEW_GID=$(echo $x | cut -d: -f1)
    NEW_GROUP=$(echo $x | cut -d: -f2)

    ## Check for existing group
    PASSCHK=$(grep -c ":$NEW_UID:" /etc/group)
    if [ $PASSCHK -gt 1 ]
    then
        echo "GID: $NEW_GID seems to exist check /etc/group"
        exit 1
    fi

    groupadd -g $NEW_GID $NEW_GROUP

done
