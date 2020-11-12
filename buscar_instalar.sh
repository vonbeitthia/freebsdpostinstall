#!/bin/bash
# buscar e instalar un programa pkg
if [[ ! $1 ]]; then
	echo escriba el nombre del paquete a buscar 
	echo	buscar_instalar nombre_pkg
else
	paquete=$1
	while [ : ];  do res=$(pkg search $paquete | sed -e 's/^/\"/g;s/$/\"/g;s/ /\" \"/1;' | xargs dialog --stdout --menu  "Seleccione programa a instalar" 0 0 0);  [ $? -ne 0 ] && break; sudo pkg install -y $res | dialog --stdout --programbox  100 100 && dialog --stdout --msgbox "El programa se instalo exitosamente" 10 40 || read -p 'Se registro un error - presione <enter> para continuar' ; done
fi

