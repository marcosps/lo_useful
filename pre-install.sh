#!/bin/bash

###
### README
###
### Script.....: pre-install.sh
### Description: Prepare linux systems Debian or RedHat based for the
###              LibreOffice compilation process. Options for dependencies
###              install and clone the source (standard), or just dependencies
###              install.

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
### Testers
### - Marcos Paulo de Souza ..(marcos.souza.org [at] gmail.com)
### - Jose Guilherme Vanz ....(guilherme.sft [at] gmail.com)
###

usageSyntax()
{
    echo " "
    echo "Usage:"
    echo " "
    echo "bash pre-install.sh [option]"
    echo " "

    echo "Options:"
    echo " "
    echo " --dir [/some/folder/]    - Clone in /some/folder/"
    echo "                          - If no dir was informed, git will clone the source in $HOME/libo/ folder"
    echo " --no-clone               - Only dep install, don't clone"
    echo " --help                   - Show this help message"
    echo " "
}

gitClone()
{
    if $noclone; then
        exit
    fi

    if [ "$clonedir" == "" ]; then
        cd $HOME
        git clone git://anongit.freedesktop.org/libreoffice/core libo && echo "Success!"
        exit
    fi

    # Uses the directory informed.
    if [ -d "$clonedir" ]; then
        cd "$clonedir"
        git clone git://anongit.freedesktop.org/libreoffice/core libo && echo "Success!"
        exit
    else
        # If not exists, try create.
        mkdir -p $clonedir
        if [ -d "$clonedir" ]; then
            cd "$clonedir"
            git clone git://anongit.freedesktop.org/libreoffice/core libo && echo "Success!"
            exit
        else
            echo "Unable to create '$clonedir' folder"
            exit
        fi
    fi
}

debianInstall()
{
    echo "Dep install for Debian/Ubuntu/Mint"
    echo " "

    # installing aptitude for a lot of reasons :)
    sudo aptitude update
    sudo apt-get install aptitude

    sudo aptitude build-dep libreoffice -y

    sudo aptitude install ccache
    sudo aptitude install git-core libgnomeui-dev gawk junit4 doxygen libgstreamer0.10-dev -y
    sudo aptitude install libarchive-zip-perl
    sudo aptitude install libcupsys2-dev libcups2-dev
    sudo aptitude install gperf libxslt1-dev libdbus-glib-1-dev libgstreamer-plugins-base0.10-dev
    # Ubuntu 13.04 - Missing
    sudo aptitude install autoconf libcups2-dev libfontconfig1-dev g++ gcj-4.7-jdk gperf
    sudo aptitude install libjpeg-dev libxslt1-dev xsltproc libxml2-utils python3.3-dev
    sudo aptitude install libx11-dev libxt-dev libxext-dev libxrender-dev libx11-dev libxrandr-dev
    sudo aptitude install bison flex libgconf2-dev libdbus-glib-1-dev libgtk2.0-dev libgtk-3-dev
    sudo aptitude install libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev
    sudo aptitude install libgl-dev libglu-dev ant junit4
    # Ubuntu 14.10 seems to not have libkrb5 as development dependency
    sudo aptitude install libkrb5-dev
}

fedoraInstall()
{
    echo "Dep install for Fedora"
    echo " "

    sudo dnf update -y

    sudo dnf builddep libreoffice -y
    sudo dnf install git libgnomeui-devel gawk junit doxygen perl-Archive-Zip Cython python-devel gstreamer-plugins-* -y
    sudo dnf install ccache -y
}

suseInstall()
{
    echo " "
    echo "1. 11.4"
    echo "2. 12.1"
    echo "3. 12.2"
    echo "4. 12.3"
    echo "5. 13.1"
    echo "6. 13.2"
    echo " "
    read -p "Select your SUSE version: " version

    case $version in
        1) vername="11.4";;
        2) vername="12.1";;
        3) vername="12.2";;
        4) vername="12.3";;
        5) vername="13.1";;
        6) vername="13.2";;
        *) echo "Sorry, invalid option!"; exit;;
    esac

    echo " "
    echo "1. 32 bits"
    echo "2. 64 bits"
    echo " "
    read -p "Select your system type: " systype

    case $systype in
        1) sysname="32 bits";;
        2) sysname="64 bits";;
        *) echo "Sorry, invalid option!"; exit;;
    esac

    echo " "
    echo "Dep install for openSUSE" $vername $sysname
    echo "If you receive a question to answer [yes or no], please, read carrefully."
    echo "Maybe root's password will be asked more than once."
    echo " "

    sudo zypper refresh
    sudo zypper update
    sudo zypper in java-1_7_0-openjdk-devel # gcj is installed by default but it does not work reasonably.

    sudo zypper in ccache

    if [$systype == 1]; then
        sudo zypper in krb5-devel-32bits
    else
        sudo zypper in krb5-devel
    fi

    sudo zypper mr --enable "openSUSE-$vername-Source" # Enable te repo to download the source.
    sudo zypper si -d libreoffice # For OpenSUSE 11.4+ (was OpenOffice_org-bootstrap)
    sudo zypper in git libgnomeui-devel gawk junit doxygen python3-devel libreoffice-pyuno
}

showDestination()
{
    if [ "$clonedir" == "" ]; then
        echo "Path (absolute) for the folder where will be cloned the libo repository: '$HOME'"; echo " "
    elif [ "$clonedir" == "--no-clone" ]; then
        echo "Chosen option for don't clone!"; echo " "
    else
        echo "Path (absolute) for the folder where will be cloned the libo repository: '$clonedir'"; echo " "
    fi
}

distroChoice()
{
    echo "1. Debian/Ubuntu"
    echo "2. Fedora"
    echo "3. openSUSE"
    echo "4. Other linux"
    echo " "

    read -p "Choice your distro: " distro

    case $distro in
        1) debianInstall;;
        2) fedoraInstall;;
        3) suseInstall;;
        4) echo "Please, follow the instructions in \"http://www.libreoffice.org/developers-2\" to configure you system or contact us."; exit;;
        *) echo "Sorry, invalid option!"; exit;;
    esac
}

cloneSyntaxError()
{
    echo "Syntax error. Cannot use --no-clone and --dir together."
    usageSyntax
    exit
}

noclone=false
clonedir=""

###
### Check input parameters.
###
while [ $# -ne 0 ]
do
    case $1 in
        "--help") usageSyntax; exit;;
        "--no-clone")
            if [ "$clonedir" != "" ]; then
                cloneSyntaxError
            fi
            noclone=true;;
        "--dir")
            if $noclone; then
                cloneSyntaxError
            fi

            # Get dir name.
            shift
            clonedir=$1

            dr=${clonedir:0:1}
            # Need a name before the next parameter.
            if [ "$dr" == "-" ]; then
                echo "Syntax error. Invalid directory \"$clonedir\"."; exit
            fi
            ;;
        *) echo "Syntax error. Invalid parameter \"$1\"."; usageSyntax; exit;;
    esac
    # Next parameter.
    shift
done

clear
echo "Script for dependencies installation to compile LibreOffice."
showDestination;
distroChoice;
gitClone;
