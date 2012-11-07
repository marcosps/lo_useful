#!/bin/bash

###
### README
###
### Script.....: pre-install.sh
### Description: Prepare linux systems Debian or RedHat based for the
###              LibreOffice compilation process. Options for dependencies
###              install and clone the source (standard), or just dependencies
###              install.

### Functions:
### bash pre-install.sh                 - Dep install and clone to $HOME/libo folder
### bash pre-install.sh /some/folder    - Dep install and clone in the received folder
### bash pre-install.sh --no-clone      - Only dep install, don't clone
### bash pre-install.sh --help          - Show help message

### LICENSE
### This program is free software: you can redistribute it and/or modify
### it under the terms of the GNU General Public License as published by
### the Free Software Foundation.
###
### This program is distributed in the hope that it will be useful,
### but WITHOUT ANY WARRANTY; without even the implied warranty of
### MERCHANTABILITY of FITNESS FOR A PARTICULAR PURPOSE. See the
### GNU General Public License for more details.
### http://www.gnu.org/licenses

###
### Authors
### - Marcos Paulo de Souza ..(marcos.souza.org [at] gmail.com)
### - Ricardo Montania .......(ricardo.montania [at] gmail.com)




###
### Function section
###

###
### Usage and syntax
### 
usageSyntax()
{
    echo " "
    echo "Usage:"; echo " ";
    echo "bash pre-install.sh [option]"; echo " "

    echo "Options:"; echo " "
    echo " /some/folder/    - Dep install and clone in /some/folder/"
    echo " --no-clone       - Only dep install, don't clone"
    echo " --help           - Show this help message"; echo " ";
    echo "If no parameters was informed, whill be installed the deps"
    echo " and git clone in $HOME/libo/ folder"
}

###
### Function that works according with the parameter received
###
actionByParameter()
{
    ###
    ### If the parameter is --no-clone, exit
    ###
    if [ "$param" == "--no-clone" ]; then
        exit
    fi

    ###
    ### If the parameter is empty, clone for the $HOME/libo folder
    ###
    if [ "$param" == "" ]; then
        cd $HOME
        git clone git://anongit.freedesktop.org/libreoffice/core libo && echo " " && "Success!"
        exit
    fi

    ###
    ### If the parameter is a valid and writable folder, clone there
    ###
    if [ -d "$param" ]; then
        cd "$param"
        git clone git://anongit.freedesktop.org/libreoffice/core libo && echo " " && "Success!"
        exit

    ###
    ### If not, try create and then to clone
    ###
    else
        mkdir -p $param

        ###
        ### Verify again if the folder exists, and if not
        ###  show an error message and exit.
        ###
        if [ -d "$param" ]; then
            cd $param
            git clone git://anongit.freedesktop.org/libreoffice/core libo && echo " " && "Success!"
            exit
        else
            echo "Unable to create '$param' folder"
            exit
        fi
    fi
}



###
### Script Begin
###

###
### Receive the first parameter informed
###
param="$1"

###
### if there is two parameters or more, exit. 
###
if [ "$2" ]; then
    echo "Syntax error!";
    usageSyntax
    exit

###
### Or if the parameter is --help, show the help message
###
elif [ "$param" == "--help" ]; then
    usageSyntax
    exit
fi




###
### Begin of the interactive section
###
clear
echo " Script for dependencies installation to compile LibreOffice."

###
### Show the destiny folder according to the case
###
if [ "$param" == "" ]; then
    echo " Path (absolute) for the folder where will be cloned the libo repository: '$HOME'"; echo " "
elif [ "$param" == "--no-clone" ]; then
    echo " Chosen option for don't clone!"; echo " "
else
    echo " Path (absolute) for the folder where will be cloned the libo repository: '$param'"; echo " "
fi

echo "1. Debian/Ubuntu"
echo "2. Fedora"; echo " "
read -p "Choice your distro: " distro

if [ "$distro" == "1" ]; then
    echo "Dep install for Debian/Ubuntu"
    echo " "
    sudo apt-get update
    sudo apt-get build-dep libreoffice -y
    sudo apt-get install git-core libgnomeui-dev gawk junit4 doxygen -y

    actionByParameter

elif [ "$distro" == "2" ]; then
    echo "Dep install for Fedora"
    echo " "
    sudo yum update
    sudo yum-builddep libreoffice -y
    sudo yum install git libgnomeui-devel gawk junit doxygen -y
    
    actionByParameter

else
    echo "Sorry, invalid option!"
fi
