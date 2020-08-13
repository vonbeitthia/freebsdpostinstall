#!/bin/bash
temp1=$(mktemp); 
temp2=$(mktemp); 
read -p "Desconecte el dispositivo y presione enter" ; 
dmesg > $temp1; 
read -p "conecte el dispositivo para comprobar"; 
dmesg > $temp2; sleep 0.5; 
echo Dispositivo encontrado:
diff $temp1 $temp2


