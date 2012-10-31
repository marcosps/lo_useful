#!/bin/bash




final()
{
    echo " "; echo " "; echo " ";
    echo "Principais dependencias instaladas!"
}

##
## Script begin
##
clear
echo " Instalacao dos pre-requisitos para compilar o LO"
echo " "
echo "1. Debian/Ubuntu"
echo "2. Fedora"; echo " "
read -p "Escolha sua distro: " distro

if [ "$distro" == "1" ]; then
    echo "Instalacao dos pre-requisitos em ambiente Debian/Ubuntu"
    echo " "
    sudo apt-get update
    sudo apt-get build-dep libreoffice
    sudo apt-get install git-core libgnomeui-dev gawk junit4 doxygen
    final
elif [ "$distro" == "2" ]; then
    echo "Instalacao dos pre-requisitos em ambiente Fedora"
    echo " "
    sudo yum update
    sudo yum-builddep libreoffice
    sudo yum install git libgnomeui-devel gawk junit doxygen
    final
else
    echo "Desculpe, opcao invalida!"
fi
