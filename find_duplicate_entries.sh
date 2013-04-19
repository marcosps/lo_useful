#!/bin/bash

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# Author: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
# This script will help to find duplicate includes and using declarations

for i in `find . -type f \( -name "*.cxx" -o -name "*.h" \) -print` 
do
	for inc in `egrep "#include.*" $i | awk '{ print $2 }' | sort | uniq `
	do
		num=$(grep $inc $i | wc -l)
		if [ "$num" -gt "1" ]
		then
			echo "$i: Header $inc is duplicated"
		fi
	done

	for use in `egrep "using namespace" $i | awk '{ print $3 }' | sort | uniq `
	do
		num=$(grep "using namespace $use" $i | wc -l)
		if [ "$num" -gt "1" ]
		then
			echo "$i: Namespace $use is duplicated"
		fi
	done
done
