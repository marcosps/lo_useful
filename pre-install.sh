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
    echo " --dir [/some/folder/]    - Dep install and clone in /some/folder/"
    echo "                          - If no dir was informed, whill be installed" 
    echo "                            the deps and git clone in $HOME/libo/ folder"
    echo " --download               - Download packeages instead of install them"
    echo " --no-update              - Don't update the repository"
    echo " --no-clone               - Only dep install, don't clone"
    echo " --ccache                 - Install ccache. It speeds up recompilation by"
    echo "                            caching previous compilations and detecting when"
    echo "                            the same compilation is being done again"
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
    sudo apt-get install aptitude


    if $update; then
        sudo aptitude update
    fi

    if $inccache; then
        sudo aptitude install ccache
    fi

    option="sudo aptitude install"

    if $download; then
        option="aptitude download"
        # installing the tools to verify the dependencies of a package
        sudo aptitude install apt-rdepends
    fi

    if $download; then
        double_jump=false

        # this format usually is: Build-Depends: zlib1g-dev
        for i in `apt-rdepends --build-depends --follow=DEPENDS libreoffice`
        do
            if $double_jump; then
                double_jump=false
                continue
            fi

            # after this part of build-dep, we have a number, so skip too
            if [[ "$i" == "(>=" || "$i" == "(>>" ]]; then
                double_jump=true
                continue
            fi

            # skip deps by LibreOffice itself
            case $i in
                "libcmis-dev" | "libicu-dev" | "liblcms2-dev" | "libmdds-dev" | "libwpd-dev")
                continue
            esac

            # first line of command
            if [[ "$i" != "libreoffice" && "$i" != "Build-Depends:" && "$i" != "Build-Depends-Indep:" ]]; then

                file_entry=`ls | grep "$i" | wc -l`
                if [ $file_entry -eq 0 ]; then
                    aptitude download $i
                fi
            fi
        done
    else
        sudo aptitude build-dep libreoffice -y
    fi

    $option git-core libgnomeui-dev gawk junit4 doxygen libgstreamer0.10-dev -y
    $option libarchive-zip-perl 
    $option libcupsys2-dev libcups2-dev
    $option gperf libxslt1-dev libdbus-glib-1-dev libgstreamer-plugins-base0.10-dev
    # Ubuntu 13.04 - Missing
    $option autoconf libcups2-dev libfontconfig1-dev g++ gcj-4.7-jdk gperf 
    $option libjpeg-dev libxslt1-dev xsltproc libxml2-utils python3.3-dev 
    $option libx11-dev libxt-dev libxext-dev libxrender-dev libx11-dev libxrandr-dev 
    $option bison flex libgconf2-dev libdbus-glib-1-dev libgtk2.0-dev libgtk-3-dev
    $option libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev
    $option libgl-dev libglu-dev ant junit4
    # Ubuntu 13.04
}

fedoraInstall()
{
    echo "Dep install for Fedora"
    echo " "

    if $update; then
        sudo yum update
    fi
	
    if $inccache; then
        sudo yum install ccache
    fi

    option="sudo yum install"

    if $download; then
        option="yum install"
    fi

    sudo yum install yum-downloadonly
    sudo yum-builddep libreoffice -y

    if $download; then
        $option git libgnomeui-devel gawk junit doxygen perl-Archive-Zip Cython python-devel -y --download-only
    else
        $option git libgnomeui-devel gawk junit doxygen perl-Archive-Zip Cython python-devel -y
    fi
}

suseInstall()
{
    echo " "
    echo "1. 11.4"
    echo "2. 12.1"
    echo "3. 12.2"
    echo "4. 12.3"
    echo "5. 13.1"
    echo " "
    read -p "Select your SUSE version: " version

    case $version in
        1) vername="11.4";;
        2) vername="12.1";;
        3) vername="12.2";;
        4) vername="12.3";;
        5) vername="13.1";;
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
    
    if $inccache; then
        sudo zypper in ccache
    fi

    if [$systype == 1]; then
        sudo zypper in krb5-devel-32bits
    else
        sudo zypper in krb5-devel
    fi	
	
    sudo zypper mr --enable "openSUSE-$vername-Source" # Enable te repo to download the source.
    sudo zypper si -d libreoffice # For OpenSUSE 11.4+ (was OpenOffice_org-bootstrap)
    sudo zypper in git libgnomeui-devel gawk junit doxygen
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

inccache=false
noclone=false
clonedir=""
download=false
update=true

###
### Check input parameters.
###
while [ $# -ne 0 ]
do
    case $1 in
        "--help") usageSyntax; exit;;
        "--ccache") inccache=true;;
        "--no-clone")
            if [ "$clonedir" != "" ]; then
                cloneSyntaxError
            fi 
            noclone=true;;
        # if we want just ot download the deps, create a dir called
        # deps and enter in the new dir, and call this shell again with the parameter
        "--download")
            mkdir deps 2> /dev/null

            if [ ! -d "deps" ]; then
                echo "Failed to create deps dir. ABORTING."
                exit
            fi

            cd deps
            bash ../$0 --downloadnow --no-update --no-clone
            exit;;
        # just for intern use, download the packets inside the deps dir
        "--downloadnow")
            # don't use sude just for download
            download=true;;
        "--no-update")
            update=false;;
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
