#!/bin/bash

set -o errexit

XILINX=/home/pong/Xilinx/14.7/ISE_DS

function prompt_board(){

        # Solicitar el board al usuario
        
        echo "Ingrese board[${board_default}]:"
        read board

        if [[ -z "${board}" ]]; then
            board="${board_default}"
        fi
}

function check_board(){
    
    while : ; do        
        # Verificar si el board ingresado es válido
        if [[ ! " ${boards_validos[@]} " =~ " ${board} " ]]; then
            # Si el board no es válido, informar al usuario y solicitar nuevamente
            echo "El board ingresado no es válido. Ingrese uno de los siguientes: ${boards_validos[*]}"
            prompt_board
        else
            break
        fi
    done
}

#Nos falta compilar el firmware que va en la FPGA. Descargamos y compilamos la versión VHDL de cksum para la placa que tengamos

# boards válidos
boards_validos=("nexys2-500" "nexys2-1200" "atlys")

# board por defecto
board_default="nexys2-500"

if [[ $# -ge 1 ]] && [[ -n "$1" ]]; then
    board="$1"
else
    prompt_board
fi

check_board

# Si el board es válido, informar al usuario
echo "Has elegido ${board}!"

case $board in
  "nexys2-500" | "nexys2-1200")
    vidpid="1443:0005"
    ports="-d D7+"
    ;;
  "atlys")
    vidpid="1443:0007"
    ports=""
    ;;
esac

cd makestuff
scripts/msget.sh makestuff/hdlmake || true
cd hdlmake/apps
2to3 --write ../bin/hdlmake.py
sed -i '157s/file/open/; 107s/file/open/; 191s/file/open/' ../bin/hdlmake.py
source ${XILINX}/settings64.sh ${XILINX}
../bin/hdlmake.py -g makestuff/swled
cd makestuff/swled/cksum/vhdl

../../../../../bin/hdlmake.py -t ../../templates/fx2all/vhdl -b "${board}" -p fpga
../../../../../../apps/flcli/lin.x64/rel/flcli -v "${vidpid}" -i ${vidpid} ${ports}
../../../../../../apps/flcli/lin.x64/rel/flcli -v "${vidpid}" -p J:D0D2D3D4:fpga.xsvf

dd if=/dev/urandom of=random.dat bs=1024 count=64
../../../../../../apps/flcli/lin.x64/rel/flcli -v "${vidpid}" -a 'w0 "random.dat";r1;r2' -b
../../../../../../apps/flcli/lin.x64/rel/flcli -v "${vidpid}" -a 'r0 10000 "out.dat"'

