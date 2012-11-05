#!/bin/bash



testPath()
{
    # testa se foi informado algum caminho
    if [ "$path" == "" ]; then
        echo " "; echo "Informe a pasta de destino!"
        echo " Ex: bash pre-install.sh /mnt/dados/ - Para clonar em /mnt/dados/"
        exit
    # testa se a pasta existe
    elif [ -d "$path" ]; then
        pasta="$path"
    # se nao existe, tenta criar, e se conseguir, continua, se nao, aborta
    else
        mkdir -p "$path"
        if [ -d "$path" ]; then
            echo 'Pasta "$path" criada com sucesso .. '
        else
            echo " "; echo "Nao foi possivel criar a pasta destino!"
            exit
        fi
    fi
}

final()
{
    echo " "; echo " "; echo " ";
    echo "Principais dependencias instaladas!"
}

clone()
{
    echo " "
    read -p "Deseja clonar o repositorio agora? (S) ou (N): " resp
    if [ "$resp" == "n" ] || [ "$resp" == "N" ]; then
        exit
    elif [ "$resp" == "s" ] || [ "$resp" == "S" ]; then
        cd $path
        echo "Clonando para a pasta 'libo', em: $path"

        git clone git://anongit.freedesktop.org/libreoffice/core libo && echo "Concluido!"
    fi
}

##
## Script begin
##

path="$1"
# Testa se a pasta destino informada pelo usuario existe, e se estiver ok, continua
testPath

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
    sudo apt-get build-dep libreoffice -y
    sudo apt-get install git-core libgnomeui-dev gawk junit4 doxygen -y
    final
    clone
elif [ "$distro" == "2" ]; then
    echo "Instalacao dos pre-requisitos em ambiente Fedora"
    echo " "
    sudo yum update
    sudo yum-builddep libreoffice -y
    sudo yum install git libgnomeui-devel gawk junit doxygen -y
    final
    clone
else
    echo "Desculpe, opcao invalida!"
fi
