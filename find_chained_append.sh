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
# This script will help to remove all chained appends in LibreOffice fdo#57950

for i in `find . -type f \( -name "*.cxx" -o -name "*.h" \) -print`
do
	if cat $i | grep -E 'append\(.*append\(' 2>/dev/null 1>/dev/null
	then
		echo $i
	fi
done
