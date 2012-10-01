#!/bin/bash
# unusedCodeSearch.sh

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

### About this script:
### 
### We can call this script without any parameters: it will show all files that uses a
### specific macros.
###
### We can also call this scirpt with the parameter macros: It wll show only the macros
### that are not used and can be removed
###

# Credits: Ricardo Montania - ricardo [at] linuxafundo.com.br


## Configs Section
path=$(pwd)
file="/tmp/macros_encontradas.txt"
fileOut="/tmp/macros_final.txt"
tmp="/tmp/tmp.txt"
ext_a="*.*xx"

rm -rf $file    2> /dev/null
rm -rf $fileOut 2> /dev/null
rm -rf $tmp     2> /dev/null


## Script begin

# collect all macros defined in .hxx files
find $path -iname "*.*xx" | xargs -L10 grep "#define" | cut -d'#' -f2 | cut -c8-200 > $file

# looping to look for each macro listed in the file above and in the end
# save a list with the search result
x=0
lns=$(wc -l $file)
y=$(expr "$lns" : '\([0-9]*\)')
while [ "$x" -lt "$y" ];
do
    let x=x+1
    current_macro="$(head -n $x $file | tail -n 1)"
    # if exist an '\', replace for an blank space
    current_macro=$(echo "${current_macro/\\/ }")
    # if current_macro has 2 words continue the script else go to the begin of while
    if [ "$(echo $current_macro | wc -w)" == "1" ]; then
        continue
    fi

    first_use=$(grep -R "$current_macro" * | cut -d':' -f1)

    just_macro=$(echo $current_macro | cut -d' ' -f1)

	# the $1 means that we jsut want to know the macros that can be removed
	if [ "$1" != "macros" ]; then
		echo "Macro: $current_macro" >> $fileOut
		echo "Declared by: $first_use" >> $fileOut
	fi

	# Verify if the source of the current macro is a cxx file
	extension=$(grep -R -m 1 "$just_macro" $path/* | cut -d':' -f1 | cut -d'.' -f2)
	if [ "$extension" == "cxx" ]; then
		how_many=$(grep -R "$just_macro" $path/* | cut -d':' -f1 | wc -l)
		if [ "$how_many" == "1" ]; then

			if [ "$1" != "macros" ]; then
				echo "Used in the file $how_many time (the #define line)" >> $fileOut
				echo "Wich mean the macro can be removed! :)" >> $fileOut
			else
				echo $current_macro in $first_use can be removed >> $fileOut
			fi
		else
			if [ "$1" != "macros" ];
			then
				echo "Used in the file $how_many times" >> $fileOut
			fi
		fi

	else
		# look for any use of the macro
		grep -R -m 1 "$just_macro" $path/* | cut -d':' -f1 > $tmp

		how_many=$(cat $tmp | wc -l)
		how_many=$(($how_many-1))

		if [ "$1" != "macros" ]; then
			echo "Number of files using it: $how_many" >> $fileOut
			grep -v "$first_use" $tmp >> $fileOut
		fi

		if [ "$how_many" == "0" ]; then
			if [ "$1" != "macros" ]; then
				echo "Wich mean the macro can be removed! :)" >> $tmp
			else
				echo $current_macro in $first_use can be removed >> $fileOut
			fi
		fi
	fi

	if [ "$1" != "macros" ]; then
		echo " " >> $fileOut
		echo "---" >> $fileOut
		echo " " >> $fileOut
		echo " " >> $fileOut
	fi
done

if [ -f $tmp ]; then
	rm $tmp
fi

if [ -f $file ]; then
	rm $file
fi

if [ -f $fileOut ]; then
	awk 'NR==1{print "Search Result:\n[Type <q> to exit Up,Down,PgUp,PgDown to navigate]\n"}1' $fileOut | less
fi
