#!/bin/bash

###
### LEIA-ME
###
### Script: pre-install.sh
### Descricao: Prepara um ambiente Debian like ou RedHat like para o processo
###            de compilacao do LibreOffice. Com opcoes de informar a pasta
###            onde ficarao os fontes e opcao de clonar ou nao

### Modo de uso:
### bash pre-install.sh                 - Instala as deps e clona para a pasta $HOME/libo
### bash pre-install.sh /algum/caminho  - Instala as deps e clona para o caminho informado
### bash pre-install.sh --no-clone      - Instala as deps e nao faz git-clone
### bash pre-install.sh --help          - Mostra as informacoes acima




###
### Secao de funcoes
###

###
### Informa o modo de uso e sintaxe
### 
modoDeUso()
{
    echo " "
    echo "Modo de uso:"; echo " ";
    echo "bash pre-install.sh [parametro]"; echo " "

    echo "Parametros:"; echo " "
    echo " /caminho/pasta/    - Prepara o ambiente e faz o clone na pasta /caminho/pasta/"
    echo " --no-clone         - Prepara o ambiente e nao faz o clone"
    echo " --help             - Informacoes de uso"; echo " ";
    echo "Se nenhum parametro for informado, sera preparado o ambiente"
    echo " e sera feito o clone na pasta $HOME/libo/"
}

###
### Funcao que age de acordo com o parametro informado
###
acaoPorParametro()
{
    ###
    ### Se o parametro for --no-clone, termina
    ###
    if [ "$param" == "--no-clone" ]; then
        exit
    fi

    ###
    ### Se o parametro for vazio, cria a pasta libo em $HOME e clona
    ###
    if [ "$param" == "" ]; then
        cd $HOME
        git clone git://anongit.freedesktop.org/libreoffice/core libo && echo " " && "Concluido!"
        exit
    fi

    ###
    ### Se o parametro for uma pasta com permissao de escrita, cria a pasta
    ### libo no caminho especificado e clona
    ###
    if [ -d "$param" ]; then
        cd "$param"
        git clone git://anongit.freedesktop.org/libreoffice/core libo && echo " " && "Concluido!"
        exit

    ###
    ### Se nao, tenta criar e entao clonar
    ###
    else
        mkdir -p $param

        ###
        ### Verifica novamente se a pasta existe, se nao exite
        ###  ocorreu um erro de permissao ao criar a pasta.
        ###  Informa erro e sai.
        ###
        if [ -d "$param" ]; then
            cd $param
            git clone git://anongit.freedesktop.org/libreoffice/core libo && echo " " && "Concluido!"
            exit
        else
            echo "Nao foi possivel criar a pasta '$param'"
            exit
        fi
    fi
}


###
### Inicio do Script
###

###
### Recebe o primeiro parametro informado
###
param="$1"

###
### Se existem dois parametros, informa erro de sintaxe e termina
###
if [ "$2" ]; then
    echo "Erro de sintaxe!";
    modoDeUso
    exit

###
### Ou se o parametro eh --help, mostra tela de ajuda
###
elif [ "$param" == "--help" ]; then
    modoDeUso
    exit
fi




###
### Inicio da parte interativa
###
clear
echo " Script de instalacao dos pre-requisitos para compilar o LO."

###
### Informa a pasta destino conforme o caso
###
if [ "$param" == "" ]; then
    echo " Caminho (absoluto) da pasta onde sera clonado o repositorio libo: '$HOME'"; echo " "
elif [ "$param" == "--no-clone" ]; then
    echo " Nao sera feito o clone!"
else
    echo " Caminho (absoluto) da pasta onde sera clonado o repositorio libo: '$param'"; echo " "
fi

echo "1. Debian/Ubuntu"
echo "2. Fedora"; echo " "
read -p "Escolha sua distro: " distro

if [ "$distro" == "1" ]; then
    echo "Instalacao dos pre-requisitos em ambiente Debian/Ubuntu"
    echo " "
    sudo apt-get update
    sudo apt-get build-dep libreoffice -y
    sudo apt-get install git-core libgnomeui-dev gawk junit4 doxygen -y

    acaoPorParametro

elif [ "$distro" == "2" ]; then
    echo "Instalacao dos pre-requisitos em ambiente Fedora"
    echo " "
    sudo yum update
    sudo yum-builddep libreoffice -y
    sudo yum install git libgnomeui-devel gawk junit doxygen -y
    
    acaoPorParametro

else
    echo "Desculpe, opcao invalida!"
fi
