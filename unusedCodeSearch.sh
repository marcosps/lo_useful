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
### We can also call this script with the parameter macros: It wll show only the macros
### that are not used and can be removed
###

# Credits: Ricardo Montania - ricardo [at] linuxafundo.com.br

###
### Configs Section
###
headers=".hxx"
souces=".cxx"
path=$(pwd)
result="/tmp/libo_result.txt"
tmpA="/tmp/tmpA.txt"
tmpB="/tmp/tmpB.txt"

target="$1"
Type="$2"





###
### functions section
###
cleanFiles()
{
    if [ -f $tmpA ]; then
        rm -rf $tmpA    2> /dev/null
    fi
    if [ -f $tmpB ]; then
        rm -rf $tmpB    2> /dev/null
    fi
    if [ -f $result ]; then
        rm -rf $result  2> /dev/null
    fi
}
helpMessage()
{
    echo "Usage:";
    echo " "
    echo "bash path/unusedCodeSearch.sh [option] [args]"
    echo "Options"
    echo " --cxx     - Search in cxx files"
    echo " --hxx     - Search in hxx files"
    echo " --help    - Show this help"
    echo " "
    echo "Args"
    echo " macro     - Search for any macro"
    echo " method    - Search for any methods"
    echo " ifdef     - Search for any ifdef without #define"
}
allMacroCollector()
{
    find "$path" -iname "$searchExtension" | xargs -L10 git grep -e ^"$Type" | cut -d'#' -f2 | cut -c8-200 > $tmpA
}

# used for find ifdefs
allDefsCollector()
{
    find "$path" -iname "$searchExtension" | xargs -L10 git grep -e ^"$Type" | cut -d'#' -f2 | cut -c7-200 > $tmpA
}

removeDuplicates()
{
    x=0
    y=$(cat $tmpA | wc -l)
    while [ "$x" -lt "$y" ];
    do
        let x=x+1
        current_macro="$(head -n $x $tmpA | tail -n 1)"

	# remove all between ()
        current_macro=$(sed -r "s/\(.*//g" <<< "$current_macro")

        # remove all after a space, leaving just the macro name
        current_macro=$(sed -r "s/ .*//g" <<< "$current_macro")

	# remove spaces before the ifdef name
        current_macro=$(sed -e "s/ //g" <<< "$current_macro")

        if [ "$(cat $tmpA | grep $current_macro | wc -l)" != "1" ]; then
            sed -i "/$current_macro/d" $tmpA
            echo "$current_macro" > /tmp/tmp.txt
            cat $tmpA >> /tmp/tmp.txt
            rm $tmpA
            mv /tmp/tmp.txt $tmpA
        fi
    done
}

removeDoubleIfdefs()
{
    x=0
    y=$(cat $tmpA | wc -l)
    while [ "$x" -lt "$y" ];
    do
        let x=x+1
        current_macro="$(head -n $x $tmpA | tail -n 1)"

	# remove all between ()
        current_macro=$(sed -r "s/\(.*//g" <<< "$current_macro")

	# remove spaces before the ifdef name
        current_macro=$(sed -e "s/ //g" <<< "$current_macro")

        if [ "$(cat $tmpA | grep $current_macro | wc -l)" != "1" ]; then
            sed -i "/$current_macro/d" $tmpA
            echo "$current_macro" > /tmp/tmp.txt
            cat $tmpA >> /tmp/tmp.txt
            rm $tmpA
            mv /tmp/tmp.txt $tmpA
        fi
    done
}

cxxMacroSelector()
{
    x=0
    y=$(cat $tmpA | wc -l)
    while [ "$x" -lt "$y" ];
    do
        let x=x+1
        current_macro="$(head -n $x $tmpA | tail -n 1)"

        # if exist an '\' replace for an blank space
        current_macro=$(echo "${current_macro/\\/ }")

        # if current_macro has 2 words continue the script else continue, go to the begin of while
        if [ "$(echo $current_macro | wc -w)" == "1" ]; then
            continue
        fi

        just_macro=$(echo $current_macro | cut -d' ' -f1)

        # remove the all between () of a macro
        just_macro=$(sed -r "s/\(.*//g" <<< "$just_macro")

        # remove all after a space, leaving just the macro name
        just_macro=$(sed -r "s/ .*//g" <<< "$just_macro")

        first_use=$(git grep "$just_macro" * | cut -d':' -f1 | uniq) #era grep -R

        # Verify if the source of the current macro is a cxx file
        extension=$(grep -R -m 1 "$just_macro" $path/* | cut -d':' -f1 | cut -d'.' -f2)
        if [ "$(echo $extension | grep cxx | wc -l)" != "0" ]; then

            echo "Macro: $just_macro" >> $result
            echo "Declared by: $first_use" >> $result

            how_many=$(grep -R "$just_macro" $path/* | cut -d':' -f1 | wc -l)
            if [ "$how_many" == "1" ]; then
                echo "Used in the file $how_many time (the #define line)" >> $result
                echo "Which mean the macro can be removed! :)" >> $result
            else
                echo "Used in the file $how_many times" >> $result
            fi

            echo " " >> $result
            echo "---" >> $result
            echo " " >> $result
            echo " " >> $result
        fi
    done
}

allIfdefsCheck()
{
    x=0
    y=$(cat $tmpA | wc -l)

    # root of the LO
    cd ..

    while [ "$x" -lt "$y" ];
    do
        let x=x+1

        current_ifdef="$(head -n $x $tmpA | tail -n 1)"

        # if exist an '\' replace for an blank space
        current_ifdef=$(echo "${current_ifdef/\\/ }")

        just_ifdef=$(echo $current_ifdef | cut -d' ' -f1)

        # remove the all between () of a macro
        just_ifdef=$(sed -r "s/\(.*//g" <<< "$just_ifdef")

        # remove all after a space, leaving just the macro name
        just_ifdef=$(sed -r "s/ .*//g" <<< "$just_ifdef")

        verify_define=$(git grep "$just_ifdef" * | grep "#define" | wc -l)

	if [ $verify_define == 0 ]; then
           verify_define=$(git grep "D$just_ifdef" * | wc -l)

           if [ $verify_define == 0 ]; then
               echo "ifdef $just_ifdef without #define. This can be removed?"
           fi
	fi
        
    done
}



###
### Script begin
###

# Remove possible old files
cleanFiles

if [ "$target" == "--hxx" ]; then
    if [ "$Type" == "macro" ]; then

        Type="#define"
        searchExtension="*.hxx"
        #allMacroCollector

    elif [ "$Type" == "method" ]; then

        echo "Not done yet. Come back later! :)"
        exit

    else

        echo "Syntax error!"
        helpMessage

    fi
elif [ "$target" == "--cxx" ]; then
    if [ "$Type" == "macro" ]; then

        Type="#define"

        searchExtension="*.cxx"

        allMacroCollector

        removeDuplicates

        cxxMacroSelector

        if [ -f $result ]; then
            awk 'NR==1{print "Search Result:\n[Type [q] to exit Up,Down,PgUp,PgDown to navigate]\n"}1' $result | less
        fi
        exit

    elif [ "$Type" == "method" ]; then

        echo "Not done yet. Come back later! :)"
        exit

    elif [ "$Type" == "ifdef" ]; then

        Type="#ifdef"

        searchExtension="*"

        allDefsCollector

        removeDoubleIfdefs

        allIfdefsCheck

    else
        echo "Syntax error!"
        helpMessage
    fi
elif [ "$target" == "--help" ]; then
    helpMessage
else
    echo "Syntax error!"
    helpMessage
fi
