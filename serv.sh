#!/bin/bash
#consulta y detencion de servicios
nomtemp=$(mktemp);  res=$(service -e | cut -d '/' -f 6 | sed '/^$/d' |  xargs -I texto echo texto "off" | tee $nomtemp | nl | xargs dialog --stdout --title "Administrar servicios" --ok-label "Detener" --cancel-label "Salir" --checklist "Seleccione los servicios a detener" 0 0 10) && ( echo $res | xargs -n1 -I texto awk ' NR == texto {system ("service  "  $1 " stop")}' $nomtemp )
