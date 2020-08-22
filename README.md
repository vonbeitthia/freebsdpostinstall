# freebsdpostinstall
Mediante los siguientes scripts se configuran diversas opciones de Freebsd.  Algunos aspectos a considerar son:

- Probado en la rama estable de Freebsd 12
- Para manejo de jaulas se utiliza ezjail
- Al ejecutar el scrip se pueden seleccionar cuales sub-scripts ejecutar.  Pueden seleccionarse
  todos, ninguno o alguno en específico. 
- El script para crear alguna jaula, requiere que se active la función de creacion de 
  jaulas previamente.
- Para crear o editar scripts recuerde que debe respetarse el orden numérico en el archivo ordenes.txt.  
  igualmente debe respetar las tabulaciones a fin de mejorar la comprensión del texto.
  La orden cat no refleja los tabuladores ya que serían agregados al archivo creado y normalmente
  generan inconvenientes.
  
ordenes.sh: Ejecuta los scripts de configuración para Freebsd

ordenes.txt: Contiene los scripts enumerados a ejecutarse

deletejail.sh:  Para eliminar jaulas y escenarios chroot relacionados definitivamente.  

detectar.sh: Determina si un dispositivo fue conectado y reconocido a traves de comparar dmesg

dialog.conf: archivo de configuracion de colores para los dialogos del script

keybinding_brillo.txt: combinaciones de teclas para ajustar brillo en panalla hdmi 

y pantalla lvds en escritorio mate.  Se agrega de forma manual (Sistema - centro de control - atajos de teclado)

ord.log: Archivo log con las ordenes ejecutadas en los scripts

ord.opt: Registro para guardar las opciones selecciondas en la ultima sesion

respaldo.sh: crea un respaldo de sistema en formato tar en el directorio /respaldo

script1.sh: Es el primer script a ejecutarse mediante sh script1.sh, que permite 
instalar el entorno bash shell para la posterior ejecución del script principal, además efectúa respaldo.

serv.sh: Consulta los servicios en ejecución que pueden detenerse a peticion del usuario
updategit.sh:  Efectuá la actualización de este repositorio (sólo puede hacerlo el administrador)

Descarga del contenido
recomendable mediante git

pkg install -y git
sed -i 's/vonuser/tu_usuario/g' ordenes.txt
git clone https://github.com/vonbeitthia/freebsdpostinstall.git

los scripts estaran ubicados en el directorio freebsdpostinstall
----------------------------------------------------------------


El usuario creado por defecto se llama vonuser, para cambiar el nombre de 
usuario por defecto puedes emplear:
		sed -i 's/vonuser/tu_usuario/g' ordenes.txt


Este programa debe ejecutarse como usuario root

Orden de los scripts:

1 Básicamente instala el entorno bash y el editor nano

		pkg install -y bash nano 
		o puedes ejecutar el script1.sh mediante
		sh script1.sh

2 cambia el usuario por defecto
		sed -i 's/vonuser/tu_usuario/g' ordenes.txt

3 ejecuta bash
		bash

4 revisa el archivo <ordenes.txt> antes de ejecutar el script.  
	Verifica la conexión mediante el archivo wpa.supplicant
	Verifica las direcciones ip configuradas por defecto
	Verifica la interfaz virtual desde la que se crearan las jaulas


4 luego ejecuta el script de ordenes mediante
		source ordenes.sh

Espero lo disfruten.
