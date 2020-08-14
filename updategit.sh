#!/bin/bash
echo Marcando archivos
git add .
git status
mensaje=$(date)
git commit -m "Actualizacion del $mensaje"
git push origin master && echo Actualizacion exitosa
