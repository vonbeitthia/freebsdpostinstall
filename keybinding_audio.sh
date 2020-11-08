#!/bin/bash
#Control de salida de audio
#Agregar atajos de teclado en
#Sistema -> Centro de Control -> atajos de teclado

res=$(cat /dev/sndstat | sed -e '1d;$d;s/^/\"/g;s/$/\"/g;s/\:/\"\ \"/g' | xargs zenity --list --column='Disp' --column='Descripcion' ); [[ $temp ]] && num=$(echo $res | grep  -o '[0-9]') && sysctl hw.snd.default_unit=$num
