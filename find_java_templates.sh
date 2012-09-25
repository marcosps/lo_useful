#!/bin/bash

# Author: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
# This script will show all java files that have templates

for i in `find -name *.java -print`
do
	if cat $i | grep -i "@author" 1> /dev/null 2> /dev/null
	then
		echo $i
	fi
done
