#!/bin/sh
present=$(date +'%d-%B-%Y-%H-%M')
echo "creando respaldo <$present>"
mkdir -p /respaldo
tar -v -c -Z -P -p -C / -f /respaldo/$present-backup.tar  \
	--exclude usr/src \
	--exclude src/ports \
	--exclude usr/obj \
	--exclude 'usr/swap*' \
	--exclude mnt \
	--exclude .sujournal \
	--exclude var/run \
	--exclude dev \
	--exclude respaldo /

echo "Respaldando sysctl..."
sysctl -A > /respaldo/$present-sysctl.txt
echo "Respaldando rc.conf.."
sysrc -A > /respaldo/$present-rcconf.txt



#consultar contenido
#tar -tvf 04-August-2020-19-42-backup.tar | less
#consultar un directorio en especifico
#tar -tvf 04-August-2020-19-58-backup.tar | grep /ejemplo
#recuperar un archivo especifico
#tar Pxf 04-August-2020-20-23-backup.tar /ejemplo
