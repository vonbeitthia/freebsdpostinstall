#!/usr/bin/env bash
##################################
#Script para configuracion FreeBSD
#Contenido: 
#Autor: vonbeitthia
##################################
titulo="Configuracion `uname -sr`"
contenido="Actualizando sistema"
pkg update | dialog --stdout --colors --title "\Z7\Zb$titulo" --programbox "$contenido" 0 0
contenido="Instalando shell BASH / Editor nano"
pkg install -y bash nano | dialog --stdout --colors --title "\Z7\Zb$titulo" --programbox "$contenido" 0 0
ln -s /usr/local/bin/bash /bin
sh respaldo.sh
bash
