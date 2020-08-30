#!/bin/bash
## eliminar jaula del sistema
temp=$(mktemp)
while [ : ]; do
	sel=$(ezjail-admin list | sed '/^DS/d' | xargs -I texto echo "\"texto\""  | sed -n -E '3,$p' | tee $temp | nl| xargs dialog --stdout --ok-label "Eliminar" --cancel-label "Salir" --default-button "cancel"  --menu "Seleccione la jaula para eliminar" 0 0 10)
	if [[ $? -eq 0 ]]; then
		#nomjaula=$(cat $temp | sed -n $sel'p' | awk '{ print $4}' | tr -d \")
		nomjaula=$(cat $temp | sed -n $sel'p' | awk '{ print $5}' | tr -d \" | cut -d '/' -f 4)
		ubcjaula=$(cat $temp | sed -n $sel'p' | awk '{ print $5}' | tr -d \")
		if [[ -z $nomjaula ]]; then
			dialog --stdout --msgbox "Debe especificar una jaula con nombre"  0 0
		else
			dialog --stdout --colors --yes-label "Continuar" --no-label "Regresar" --default-button "no" --yesno "Eliminar la jaula \Z1$nomjaula"  0 0
			if [[ $? -eq 0  ]]; then
				ezjail-admin stop $nomjaula
				ezjail-admin delete $nomjaula
				chflags -R noschg $ubcjaula
				rm -r $ubcjaula
				rm /usr/local/etc/ezjail/*.bak
				dialog --stdout --colors --msgbox "La jaula \Z1$nomjaula\Zn fue eliminada" 0 0
				#actualizamos hosts en host Freebsd
				echo Solo se actualizan las jaulas que se estan ejecutando 
				listahosts=$(ezjail-admin list | sed -n -E '3,$p' | sed '/-/d' | awk '{ print $3 "\t" $4 }'| sed -E 's/\/([0-9]){2}//g' | tr [:upper:] [:lower:] | xargs -I texto echo texto.com | sed 's/\.com.com/\.com/g')
cat << EOF > /etc/hosts
192.168.0.100	`hostname`
127.0.0.1		localhost
::1			localhost
$listahosts
EOF
		
				#actualizamos la linea hostname de cada jaula en /usr/local/etc/ezjail - a jaula.com en minuscula usando gsed
				ezjail-admin list | sed -n -E '3,$p' | sed '/-/d' | awk '{ print $4 }' | xargs -I jaula gsed -i 's/hostname=\"jaula\"/hostname=\"\Ljaula\.com\"/g' /usr/local/etc/ezjail/jaula 2>/dev/null
				#actualizamos el resto de los hosts de jaulas
				ezjail-admin list | sed -n -E '3,$p' | sed '/-/d' | awk '{ print $5 }'|  xargs -I jaula cp /etc/hosts  jaula/etc/hosts
			fi
		fi
	else
		break;
	fi
done
#dialog --stdout --msgbox "Debe especificar el nombre de la jaula"  0 0
