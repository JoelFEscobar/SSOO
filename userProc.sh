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
lista=$(ps -A -o user --no-headers|sort -u |uniq )
copia_lista_usuarios=$(ps -A -o user --no-headers|sort -u |uniq)
exist=$(cat /etc/passwd | tr -s ':' ' ' | cut -d ' ' -f1)
usrconect=$(who | tr -s ' ' ' '|cut -d ' ' -f1 )

opcion_help=0
opcion_t=0
opcion_usr=0
opcion_filter=0
opcion_inv=0
opcion_pid=0
opcion_count=0
#────────────────────────┤ Funciones ├──────────────────────────────
Seconds_format_xx()
{
  TIME="$auxN"
  echo | awk -v "S=$TIME" '{printf "%02d:%02d:%02d",S/(60*60),S%(60*60)/60,S%60}'
}



cabecera(){
  echo "Autor: Joel Francisco Escobar Socas"
}

ProcessUsr(){
  cabecera
  if [[ "$opcion_count" = "1" ]];then
    echo -e "$COLOR_CIAN$(ps -o user:20| head -n 1)\t\tNUM_PROCESS$TEXT_RESET"
  else
    echo -e "$COLOR_CIAN$(ps -o user:20,uid,gid,pid,cputime | head -n 1)\t\tNUM_PROCESS$TEXT_RESET"
  fi
  
  echo "$COLOR_MAGENTA────────────────────────────────────────────────────────────────────────────────────────────────────$TEXT_RESET"

  for i in $lista; do
    e_time=$(ps -u $i -o user,pid,gid,time --no-headers| sort -u | tr -s ' ' ' ' | cut -d ' ' -f4)
      for j in $e_time; do
        if [[ "$j">"$N" ]]; then 
          if [ "$opcion_usr" = "1" ]; then
            for k in $usrconect; do
              if [[ "$i" == "$k" ]]; then
                user_match="$i "
              fi
            done
          else
            user_match="$i " 
          fi
          #echo "Para el usuario $i -> $j es mayor que $N
        fi
      done

      for i in $user_match; do 
        if [[ "$opcion_count" = "1" ]]; then
          username=$(ps -u $i -o user:20 --sort=cputime --no-headers|tail -n 1 | uniq)
          numproc=$(ps -u $i | wc -l|uniq )
          printf "${username}\t\t${numproc}\n"
        else
          username=$(ps -u $i -o user:20,uid,gid,pid,cputime:10 --sort=cputime --no-headers|tail -n 1 | uniq)
          numproc=$(ps -u $i | wc -l|uniq )
          printf "${username}\t${numproc}\n"
        fi           
        
      done

      
  done
       
}

#Función error_exit que controla la salida de errores
error_exit(){
  case $1 in
    1) echo "$TEXT_MAGENTA Error!: Opcion seleccionada no valida$TEXT_RESET" 1>&2
			help_func
			exit 1
			;;

    2) echo "$TEXT_MAGENTA Error!: Los argumentos introducidos son incompatibles$TEXT_RESET" 1>&2
      help_func
      exit 1
      ;;

    3) echo "$TEXT_MAGENTA Error!: Formato del número N no válido $TEXT_RESET" 1>&2
      format_case
      help_func
      exit 1
      ;;
    4) echo "$TEXT_MAGENTA Error!: opcion no encontrada $TEXT_RESET" 1>&2
      help_func
      exit 1
      ;;
    *) echo "$TEXT_MAGENTA Error Desconocido $TEXT_RESET" 1>&2
      help_func
      exit 1
      ;;
  esac

}

#Función que muestra el formato deseado 
format_case(){
  echo "El formato del número introducido debe ser: $TEXT_CIAN 00:00:00 $TEXT_RESET "
  echo "══════════════════════════════════════════════════════════════════════════════"
  echo "Donde: "
  echo "→ Los primeros $TEXT_CIAN 00:$TEXT_RESET corresponden a horas"
  echo "→ Los segundos $TEXT_CIAN :00:$TEXT_RESET corresponden a minutos"
  echo "→ Los terceros $TEXT_CIAN :00$TEXT_RESET corresponden a segundos"
  echo "→ Por defecto el valor será 00:00:01, correspondiente a 1 segundo"
  echo "══════════════════════════════════════════════════════════════════════════════"
}

#Función Help que muestra el uso del script

help_func(){

  echo "Modo de Uso: ./userProc.sh [Options] "
  echo "══════════════════════════════════════════════════════════════════════════════"
  echo "Las opciones soportadas son: "
  echo "→ Sin argumentos: Mostrará los usuarios que están ejecutando proceso con un tiempo de cpu consumido mayor que 00:00:01"
  echo "→ -h o --help: Mostrará una ayuda acerca del funcionamiento"
  echo "══════════════════════════════════════════════════════════════════════════════"

}



#────────────────────────┤ Función Main ├──────────────────────────────
################################################################################################################
#────────────────────────┤ Gestión de las opciones pasadas por línea de comando ├──────────────────────────────
clear
while [ "$1" != "" ]; do
  case $1 in
    --help | -h )
      echo " ─┤ Ayuda del Programa ├─"
      opcion_help=1	
      ;;

    -t )
      echo " Seleccionando el Número"
      opcion_t=1
      shift
      auxN=$1
      echo "auxN: $auxN"
      N=$(Seconds_format_xx)
      ;;

    -usr )
      echo "Filtrando por usuarios conectados a $HOSTNAME"
      opcion_usr=1
      ;;

    -u )
      echo "Filtrando por usuarios especificados"
      opcion_filter=1

      while [[ $2 != "" ]]; do
        usuario_parametro+="$2 "
        shift
      done
      
      for i in $usuario_parametro; do
        for j in $copia_lista_usuarios; do
          if [[ "$i" == "$j" ]]; then
            lista=$usuario_parametro
          fi
        done
      done
  
 
      ;;

    -inv )
      echo "Ordenando por INVERSA"
      opcion_inv=1
      lista=$(ps -A -o user --no-headers|sort -r |uniq)
      ;;


    -count )
      echo "Mostrando solo el numero de procesos por usuario"
      opcion_count=1
      ;;

    * )
      error_exit 1
      exit 4
      ;;

    esac
    shift
done

#────────────────────────┤ Control de las diferentes combinaciones ├──────────────────────────────
########################################################################################################
#────────────────────────┤ Caso Base ├──────────────────────────────
# Opcion por defecto (00 00 00)
if [ "$opcion_help" = "0" ] && [ "$opcion_t" = "0" ] && [ "$opcion_usr" = "0" ] && [ "$opcion_filter" = "0" ] && [ "$opcion_inv" = "0" ] && [ "$opcion_count" = "0" ]; then
ProcessUsr|uniq
# Si llamamos a Ayuda (10 00 00)
elif [ "$opcion_help" = "1" ] && [ "$opcion_t" = "0" ] && [ "$opcion_usr" = "0" ] && [ "$opcion_filter" = "0" ] && [ "$opcion_inv" = "0" ] && [ "$opcion_count" = "0" ]; then
help_func
# Si le pasamos el número de segundos a filtrar (01 00 00)
elif [ "$opcion_help" = "0" ] && [ "$opcion_t" = "1" ] && [ "$opcion_usr" = "0" ] && [ "$opcion_filter" = "0" ] && [ "$opcion_inv" = "0" ] && [ "$opcion_count" = "0" ]; then
ProcessUsr |uniq
# Si lo queremos ordenar por usuarios conectados (00 10 00)
elif [ "$opcion_help" = "0" ] && [ "$opcion_t" = "0" ] && [ "$opcion_usr" = "1" ] && [ "$opcion_filter" = "0" ] && [ "$opcion_inv" = "0" ] && [ "$opcion_count" = "0" ]; then
ProcessUsr |uniq
# Si filtramos usuarios especificos (00 01 00)
elif [ "$opcion_help" = "0" ] && [ "$opcion_t" = "0" ] && [ "$opcion_usr" = "0" ] && [ "$opcion_filter" = "1" ] && [ "$opcion_inv" = "0" ] && [ "$opcion_count" = "0" ]; then
ProcessUsr |uniq
#Si ordenamos inversamente (00 00 10)
elif [ "$opcion_help" = "0" ] && [ "$opcion_t" = "0" ] && [ "$opcion_usr" = "0" ] && [ "$opcion_filter" = "0" ] && [ "$opcion_inv" = "1" ] && [ "$opcion_count" = "0" ]; then
ProcessUsr| uniq 
#Si contamos el numero de procesos
elif [ "$opcion_help" = "0" ] && [ "$opcion_t" = "0" ] && [ "$opcion_usr" = "0" ] && [ "$opcion_filter" = "0" ] && [ "$opcion_inv" = "0" ] && [ "$opcion_count" = "1" ]; then
ProcessUsr|uniq
########################################################################################################
#────────────────────────┤ Combinaciones posibles ├──────────────────────────────
#Es posible filtrar para un tiempo especifico y invertir todo
elif [ "$opcion_help" = "0" ] && [ "$opcion_t" = "1" ] && [ "$opcion_usr" = "0" ] && [ "$opcion_filter" = "0" ] && [ "$opcion_inv" = "1" ] && [ "$opcion_count" = "0" ]; then
ProcessUsr|uniq
#Es posible filtrar por usuario y hacer la inversa
#Help con T
elif [ "$opcion_help" = "0" ] && [ "$opcion_t" = "1" ] && [ "$opcion_usr" = "0" ] && [ "$opcion_filter" = "1" ] && [ "$opcion_inv" = "1" ] && [ "$opcion_count" = "0" ]; then
ProcessUsr|uniq

########################################################################################################
#────────────────────────┤ Casos Improbables ├──────────────────────────────
#usar Help con otros comandos
#Help con T
elif [ "$opcion_help" = "1" ] && [ "$opcion_t" = "1" ] && [ "$opcion_usr" = "0" ] && [ "$opcion_filter" = "0" ] && [ "$opcion_inv" = "0" ] && [ "$opcion_count" = "0" ]; then
error_exit 2
#Help con usr
elif [ "$opcion_help" = "1" ] && [ "$opcion_t" = "0" ] && [ "$opcion_usr" = "1" ] && [ "$opcion_filter" = "0" ] && [ "$opcion_inv" = "0" ] && [ "$opcion_count" = "0" ]; then
error_exit 2
#Help con -u
elif [ "$opcion_help" = "1" ] && [ "$opcion_t" = "0" ] && [ "$opcion_usr" = "0" ] && [ "$opcion_filter" = "1" ] && [ "$opcion_inv" = "0" ] && [ "$opcion_count" = "0" ]; then
error_exit 2
#Help con inv
elif [ "$opcion_help" = "1" ] && [ "$opcion_t" = "0" ] && [ "$opcion_usr" = "0" ] && [ "$opcion_filter" = "0" ] && [ "$opcion_inv" = "1" ] && [ "$opcion_count" = "0" ]; then
error_exit 2
#Help con count
elif [ "$opcion_help" = "1" ] && [ "$opcion_t" = "1" ] && [ "$opcion_usr" = "0" ] && [ "$opcion_filter" = "0" ] && [ "$opcion_inv" = "0" ] && [ "$opcion_count" = "1" ]; then
error_exit 2
# Imposible filtrar para un usuario especifico y calcular para usuarios online
elif [ "$opcion_help" = "0" ] && [ "$opcion_t" = "0" ] && [ "$opcion_usr" = "1" ] && [ "$opcion_filter" = "1" ] && [ "$opcion_inv" = "0" ] && [ "$opcion_count" = "1" ]; then
error_exit 2
# Imposible filtrar para un usuario especifico y un tiempo especifico
elif [ "$opcion_help" = "0" ] && [ "$opcion_t" = "1" ] && [ "$opcion_usr" = "0" ] && [ "$opcion_filter" = "1" ] && [ "$opcion_inv" = "0" ] && [ "$opcion_count" = "1" ]; then
error_exit 2

else
error_exit 2
fi

#────────────────────────┤ Fin del programa ├──────────────────────────────

exit 0