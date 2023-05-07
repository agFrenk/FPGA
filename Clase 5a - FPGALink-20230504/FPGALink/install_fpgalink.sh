#!/bin/bash

set -o errexit

# Obtenemos la infraestructura primero

mkdir -p $HOME/FPGALink
cd $HOME/FPGALink

targz="makestuff.tar.gz"

if test -e "$targz"; then
    echo "El archivo ${targz} ya existe en el directorio actual."
else
    # Si el archivo no existe, descargarlo con wget
    wget -O"${targz}" http://tiny.cc/msbil
    tar zxf "${targz}"
fi

# y luego obtenemos y compilamos la aplicación flcli

cd makestuff/apps

../scripts/msget.sh makestuff/flcli/20170708 || true
cd flcli
make deps
cd ../../

# Agregamos la biblioteca libfpgalink.so al sistema

sudo bash -c "echo ${HOME}/FPGALink/makestuff/libs/libfpgalink/lin.x64/rel/ > /etc/ld.so.conf.d/fpgalink.conf"
sudo ldconfig

# Ahora ya tenemos compilado flcli, lo cual nos permite acceder a la FPGA desde el host.

