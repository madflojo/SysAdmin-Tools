#!/bin/bash
#### Description: Adds users based on provided CSV file 
#### CSV file must use : as seperator
#### uid:username:comment:group:addgroups:/home/dir:/usr/shell:passwdage:password
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

    NEW_UID=$(echo $x | cut -d: -f1)
    NEW_USER=$(echo $x | cut -d: -f2)
    NEW_COMMENT=$(echo $x | cut -d: -f3)
    NEW_GROUP=$(echo $x | cut -d: -f4)
    NEW_ADDGROUP=$(echo $x | cut -d: -f5)
    NEW_HOMEDIR=$(echo $x | cut -d: -f6)
    NEW_SHELL=$(echo $x | cut -d: -f7)
    NEW_CHAGE=$(echo $x | cut -d: -f8)
    NEW_PASS=$(echo $x | cut -d: -f9)    

    ## check for existing user
    PASSCHK=$(grep -c ":$NEW_UID:" /etc/passwd)
    if [ $PASSCHK -ge 1 ]
    then
        echo "UID: $NEW_UID seems to exist check /etc/passwd"
    else
      useradd -u $NEW_UID -c "$NEW_COMMENT" -md $NEW_HOMEDIR -s $NEW_SHELL -g $NEW_GROUP -G $NEW_ADDGROUP $NEW_USER
	
	    if [ ! -z $NEW_PASS ]
	    then
	        echo $NEW_PASS | passwd --stdin $NEW_USER
	        chage -M $NEW_CHAGE $NEW_USER
	        chage -d 0 $NEW_USER 
	    fi
    fi
done
