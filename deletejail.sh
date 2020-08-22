#!/bin/bash
## eliminar jaula del sistema
temp=$(mktemp)
while [ : ]; do
	sel=$(ezjail-admin list | xargs -I texto echo "\"texto\""  | sed -n -E '3,$p' | tee $temp | nl| xargs dialog --stdout --ok-label "Eliminar" --cancel-label "Salir" --default-button "cancel"  --menu "Seleccione la jaula para eliminar" 0 0 10)
	if [[ $? -eq 0 ]]; then
		nomjaula=$(cat $temp | sed -n $sel'p' | awk '{ print $4}' | tr -d \")
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
			fi
		fi
	else
		break;
	fi
done
#dialog --stdout --msgbox "Debe especificar el nombre de la jaula"  0 0
