#!/bin/bash
zenity --notification --text="Cargando entorno de programacion" --window-icon=info
ssh -p 2222 usuario@10.1.1.3  "source startnode.sh" && vncviewer 10.1.1.3:5901 