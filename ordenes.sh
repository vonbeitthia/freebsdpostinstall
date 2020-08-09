#!/bin/bash
export DIALOGRC=$PWD/dialog.conf
sesion=$PWD/ordenes.opt #registro de opciones seleccionaas en la sesion anterior
log=$PWD/ord.log
temp1=$(mktemp) 
tempsh=$(mktemp)


function ejecuta {
	#ejecuta la orden indicada en $1
	#preparamos el archivo de ordenes
	rm $PWD/$log 2>/dev/null  #archivo log 
	#extraemos las lineas de ordenes.txt e igualamos a 2 o más columnas
	while [ : ] ; do
	numlinea=$1;
	numorden=$(printf "%03i" $numlinea)
	mensaje1=$(grep "<$numorden" ordenes.txt | cut -d ' ' -f 2- | sed 's/">/"/g' | tr -d \")
	sed -E -n "/<$numorden/,/<\/$numorden/p ; " ordenes.txt | sed -E "1d;\$d ; s/^[[:space:]]{2}//g" > $tempsh
	(source $tempsh) 2>> $log  | dialog  --timeout 1 --stdout --backtitle  "Orden: <\Z2$numorden\Zn>" --colors --title "\Z0$titulo1" --programbox "\Z6\Zb$mensaje1" 20 60 
	#echo $numlinea
	shift 
	if [[ -z $1 ]] ; then break; fi
	done
}


#obtenemos el valor mas alto de las ordenes etiquetadas
titulo1=$(eval "echo $(egrep "^Titulo:" ordenes.txt | cut -d : -f2 | sed 's/^[[:blank:]]*//g')")
ultlista=$(egrep -o -E "^<[0-9]{3} " ordenes.txt | tr -d \< 	| awk 'END {printf "%i",$1}' )

ninguno=0
egrep -E "^<[0-9]{3}" ordenes.txt | tr -d '<' | sed -E 's/\">/\" off /g'  > $temp1
while [ : ] ; do
	
	if [[ -f $sesion ]]; then
		verifica=$(cat $sesion);
		if [[ -z $verifica ]]; then
			dialog --stdout --title "$titulo1" --infobox "Sesión sin contenido" 0 0 && sleep 0.3
		else
			dialog --stdout --title "$titulo1" --infobox "Cargando sesion anterior" 0 0 
			
			cat $sesion  | xargs -I texto -n 1 sed -I '' 's/\(^texto.*\) off/\1 on/g' $temp1
			#sed -I '' -E 's/\"/\\"/g' $temp1
		fi
	fi
	if [[ $ninguno -eq 0 ]]; then
		textodinamico="Seleccionar todos los elementos"
	else
		textodinamico="Eliminar selección"
	fi
	menu=$(cat $temp1)
	resul=$(echo $menu | xargs dialog --title "$titulo1" --ok-label "Ejecutar" --cancel-label "Salir" --stdout --colors --checklist "Seleccione un Script de ordenes" 0 0 20 000 "$textodinamico" off)
	#salir = 1
	#ejecutar = 0 
	salida=$?
	if [[ $salida -eq 0 ]]; then 
		if [[ -z $resul ]]; then
			dialog --stdout --colors --title "$titulo1" --msgbox "Debe seleccionar al menos \Z1una\Zn opción" 5 60
		elif [[ `echo $resul | cut -d ' ' -f1` = "000"  ]]; then
			
			[ $ninguno -eq 0 ] && ninguno=1  || ninguno=0   #cambiamos el estado de seleccion
			if [[ $ninguno -eq 0 ]]; then #quita la seleccion
				sed -i '' 's/on $/off /g' $temp1 
			else
				sed -i '' 's/off $/on /g' $temp1 
			fi
			rm $sesion 2> /dev/null
		else
			echo $resul>$sesion
			dialog --stdout --colors --title "$titulo1" --yes-label "Continuar" --no-label "Cancelar" --default-button no --yesno "Proceder a ejecutar los \Zbscripts\Zn seleccionados" 10 60
			if [[ $? -eq 0 ]]; then
				ejecuta $resul
			fi
		fi
	else
		break
	fi
done



