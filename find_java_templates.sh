#!/bin/bash

# Author: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
# This script will show all java files that have templates

for i in `find -name *.java -print`
do

	if echo "$i" | grep "build" > /dev/null
	then
		# there is a simple method for just skip this file?
		echo "" > /dev/null
	else

		if cat $i | grep -i "To change this template, choose Tools" 1> /dev/null 2> /dev/null
		then
			echo 'Template' $i

		elif cat $i | grep -i "@author" 1> /dev/null 2> /dev/null
		then
			echo 'Author' $i

		fi
	fi
done
