#!/bin/bash
#userProc.sh: Script que permite mostrar un listado con todos los usuarios que tienen al menos un proceso con un tiempo de CPU consumido mayor de N
#Autor: Joel Francisco Escobar Socas
#Asignatura: Sistemas Operativos
#####################################################################

#────────────────────────┤ Constantes ├──────────────────────────────
TITLE="BIENVIENIDO AL SCRIPT USERPROC"
FUNCTION="UserProc es un script que permite mostrar un listado con todos los usuarios que estan ejecutando proceso con un tiempo de cpu consumido especifico en la máquina $HOSTNAME"
AUTHOR="Joel Francisco Escobar Socas"
LINE="═══════════════════════════════════════════════════════════════"
#────────────────────────┤ Estilos ├──────────────────────────────
TEXT_BOLD=$(tput bold)
COLOR_GREEN=$TEXT_BOLD$(tput setaf 2)$TEXT_RESET
COLOR_MAGENTA=$TEXT_BOLD$(tput setaf 5)$TEXT_RESET
COLOR_CIAN=$TEXT_BOLD$(tput setaf 6)$TEXT_RESET
TEXT_RESET=$(tput sgr0)
TEXT_ULINE=$(tput sgr 0 1)
#────────────────────────┤ Variables ├──────────────────────────────

N="00:00:01"

opcion_help=0
opcion_t=0


#────────────────────────┤ Funciones ├──────────────────────────────


lista=$(ps -A -o user --no-headers|sort -u |uniq )
exist=$(cat /etc/passwd | tr -s ':' ' ' | cut -d ' ' -f1)

lista(){
  echo "Función que muestra la lista de procesos de cpu "
  echo -e "$COLOR_CIAN$(ps -o user:20,uid,gid,pid,cputime | head -n 1)\tNumProccess$TEXT_RESET"


  for i in $lista; do
    e_time=$(ps -u $i -o user,pid,gid,time --no-headers| sort -u | tr -s ' ' ' ' | cut -d ' ' -f4)
      for j in $e_time; do
        if [[ "$j">"$N" ]]; then 
          user_match="$i " 
          #echo "Para el usuario $i -> $j es mayor que $N
        fi
      done
      for i in $user_match; do
            username=$(ps -u $i -o user:20,uid,gid,pid,cputime --sort=cputime --no-headers|tail -n 1 | uniq)
            numproc=$(ps -u $i | wc -l|uniq )
            printf "${username}\t${numproc}\n"
      done
  done



}

lista

#────────────────────────┤ Fin del programa ├──────────────────────────────

exit 0