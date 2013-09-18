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
# This script will help to find all headers that just make another includes

for file in `find . -type f \( -name "*.h" -o -name "*.hxx" \) -print`
do
	if [ $(cat $file | grep '#include' | wc -l) -gt 0 ]
	then
                if [[ "$file" == *precompile* ]]
		then
			continue;
		fi

		if [ $(cat $file | grep -w "class" | wc -l) -gt 0 ]
		then
			continue;
		fi

		if [ $(cat $file | grep -w "define" | wc -l) -gt 0 ]
		then
			continue;
		fi

		if [ $(cat $file | grep -w "namespace" | wc -l) -gt 0 ]
		then
			continue;
		fi

		if [ $(cat $file | grep -w "void" | wc -l) -gt 0 ]
		then
			continue;
		fi

		if [ $(cat $file | grep -w "int" | wc -l) -gt 0 ]
		then
			continue;
		fi

		if [ $(cat $file | grep -w "typedef" | wc -l) -gt 0 ]
		then
			continue;
		fi

		echo "$file: wrapper header. Please take a look"
	fi
done
