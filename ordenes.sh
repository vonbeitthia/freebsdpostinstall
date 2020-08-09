#!/bin/bash
export DIALOGRC=$PWD/dialog.conf

#ejecuta toda la secuencia de ordenes o una por una
#argumentos all - todos
#1-xxx para indicar la orden a ajecutar


argu=${1:- 0}
numargu=$(printf "%i" $argu)
	
	#obtenemos el valor mas alto de las ordenes etiquetadas

	lista=$(cat ordenes.txt | egrep -o -E "^<[0-9]{3} " | tr -d \< 	| awk 'END {printf "%i",$1}' )

	titulo1=$(eval "echo $(egrep "^Titulo:" ordenes.txt | cut -d : -f2 | sed 's/^[[:blank:]]*//g')")
	#preparamos el archivo de ordenes
	temp1=$(mktemp)
	rm $HOME/freepostinstall/funciones.log
	sed 's/^[[:blank:]]./orden /g' ordenes.txt > $temp1
	for (( n=1; n <= $lista ; n++ )); do 
		mensaje1=""
		numorden=$(printf "%03i" $n)
		mensaje1=$(eval "echo $(grep "<$numorden" $temp1 | cut -d ' ' -f 2- | sed 's/">/"/g')") 
		echo "Orden: <$n> - <$numorden> Mensaje: <$mensaje1>" >> funciones.log
		
		if [ -z $mensaje1 ]; then continue; fi
		
		ord=$(awk " /^\<$numorden/,/^\<\/$numorden\>/ { print }"	$temp1 | grep "^orden " | cut -d ' ' -f 2-)
		echo "$ord" >> funciones.log
		if [ $numorden -eq $numargu ]; then
	   	( eval "$ord" ) 2>> funciones.log  | dialog  --timeout 1 --stdout --backtitle  "Orden: <\Z2$ord\Zn>" --colors --title "\Z0$titulo1" --programbox "\Z6\Zb$mensaje1" 20 60 
			break
		elif [ $numargu -eq 0 ]; then #todas las ordenes
		   #( eval $(echo $ord)) 2>> funciones.log  | dialog  --timeout 1 --stdout --backtitle  "Orden: <\Z2$ord\Zn>" --colors --title "\Z0$titulo1" --programbox "\Z6\Zb$mensaje1" 20 60 
		   ( eval  "$ord" ) 2>> funciones.log  | dialog  --timeout 1 --stdout --backtitle  "Orden: <\Z2$ord\Zn>" --colors --title "\Z0$titulo1" --programbox "\Z6\Zb$mensaje1" 20 60 
		fi
	done

