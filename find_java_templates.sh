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
# This script will show all java files that have templates

#Modified-by: José Guilherme Vanz <guilherme.sft@gmail.com>

### Begin script ###
for i in `find \( -wholename ./workdir -o -wholename \*/build\* \) -prune -o -name *.java -print`
do
	if cat $i | grep -i "To change this template, choose Tools" 1> /dev/null 2> /dev/null
	then
		echo 'Template' $i
	
	elif cat $i | grep -i "@author" 1> /dev/null 2> /dev/null
	then
		sed '/@author/d' $i > $i.temp
		rm $i
		mv $i.temp $i
		echo 'Author' $i
	fi
done
