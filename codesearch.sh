#!/bin/bash
# codesearch.sh

# This program is free software. You can redistribute it and/or modify
# is under the terms of the GNU Gerenal Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#


## Configs Section
toFind="$1"
list="/tmp/libo.out"
path=$(pwd)
ext_a="*.*xx" # for *.cxx and *.hxx
ext_b="*.c"   # for *.c
ext_c="*.h"   # for *.h

## Functions Section
fileVerify()
{
    if [ -e $list ]; then
        existFile=true
    else
        existFile=false
    fi
}

fileCleanner()
{
    rm $list 2> /dev/null
}


## Script begin

# Remove possible old files
fileCleanner

# Create a new file
for folders in $(ls)
do
	if [ -d ./$folders ]; then
        find $path/$folders/ -iname $ext_a | xargs -L10 grep -m 1 $toFind | cut -d':' -f1 >> $list
        find $path/$folders/ -iname $ext_b | xargs -L10 grep -m 1 $toFind | cut -d':' -f1 >> $list
        find $path/$folders/ -iname $ext_c | xargs -L10 grep -m 1 $toFind | cut -d':' -f1 >> $list        
	fi
done

# After all if not empty show the file generated
fileVerify

if [ $existFile ]; then
    awk 'NR==1{print "Search Result:\n[Type <q> to exit]"}1' $list | less
    echo "Program terminated!"
fi
