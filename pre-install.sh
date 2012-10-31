#!/bin/bash

clear
echo " Instalacao dos pre-requisitos para compilar o LO"
echo " "
echo "1. Debian/Ubuntu"
echo "2. Fedora"
read -p "Escolha sua distro: " distro

if [ "$distro" == "1" ]; then
    distro="Debian/Ubuntu"
elif [ "$distro" == "2" ]; then
    distro="Fedora"
fi

echo "Voce escolheu: $distro"
