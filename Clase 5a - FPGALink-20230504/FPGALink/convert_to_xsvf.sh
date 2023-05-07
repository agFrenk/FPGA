#!/bin/bash

# Uso:
#
# convert_to_xsvf.sh <board> <bit_file> <xsvf>
# 

set -o errexit

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

cat > batch_file << EOL
setMode -bscan
addDevice -p 1 -file "$2"
addDevice -p 2 -file "${HOME}/Xilinx/14.7/ISE_DS/ISE/xcf/data/xcf04s.bsd"
setcable -port xsvf -file "$3"
program -p 1
exit
EOL

    ;;
  "atlys")

cat > batch_file << EOL
setMode -bscan
addDevice -p 1 -file "$2"
setcable -port xsvf -file "$3"
program -p 1
exit

EOL

esac




impact -batch batch_file
rm batch_file
rm _impactbatch.log
