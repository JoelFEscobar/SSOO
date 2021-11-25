#!/bin/bash
#userProc.sh: Script que permite mostrar un listado con todos los usuarios que tienen al menos un proceso con un tiempo de CPU consumido mayor de N
#Autor: Joel Francisco Escobar Socas
#Asignatura: Sistemas Operativos
#####################################################################
#────────────────────────┤ Constantes ├──────────────────────────────
TITLE="BIENVENIDO AL SCRIPT USERPROC"
FUNCTION="UserProc es un script que permite mostrar un listado con todos los usuarios que estan ejecutando un proceso con un tiempo de cpu consumido especifico en la máquina $HOSTNAME"
AUTHOR="Joel Francisco Escobar Socas"
LINE="════════════════════════════════════════════════════════════════════════════════════════════════════"
POINT="°"
EXPLAIN="Explicación:"
NAME="Autor: "
#────────────────────────┤ Estilos ├──────────────────────────────
TEXT_BOLD=$(tput bold)
COLOR_GREEN=$TEXT_BOLD$(tput setaf 2)$TEXT_RESET
COLOR_BLACK=$TEXT_BOLD$(tput setaf 0)$TEXT_RESET
COLOR_MAGENTA=$TEXT_BOLD$(tput setaf 5)$TEXT_RESET
COLOR_CIAN=$TEXT_BOLD$(tput setaf 6)$TEXT_RESET
COLOR_RED=$TEXT_BOLD$(tput setaf 1)$TEXT_RESET
TEXT_RESET=$(tput sgr0)
TEXT_ULINE=$(tput sgr 0 1)

#────────────────────────┤ Variables ├──────────────────────────────
#Variables que recogen datos importantes para su listado
N="00:00:01" #Variable N que almacena el tiempo por defecto es 1 segundo
lista=$(ps -A -o user --no-headers|sort -u |uniq ) #La variable lista es la lista de usuarios que están ejecutando algun proceso en la máquina.
copia_lista_usuarios=$(ps -A -o user --no-headers|sort -u |uniq)
exist=$(cat /etc/passwd | tr -s ':' ' ' | cut -d ' ' -f1)
usrconect=$(who | tr -s ' ' ' '|cut -d ' ' -f1 ) #lista de usuarios que estan conectados a la máquina.
#Flags para cuando el usuario introduzca opciones
opcion_help=0
opcion_t=0
opcion_usr=0
opcion_filter=0
opcion_inv=0
opcion_pid=0
opcion_count=0
#────────────────────────┤ Funciones ├──────────────────────────────

# Función que visualiza la cabecera del programa.
cabecera(){
cat << _HEADER_
$COLOR_GREEN$TITLE$TEXT_RESET
$COLOR_BLACK$LINE$TEXT_RESET
$COLOR_MAGENTA$POINT $EXPLAIN$TEXT_RESET $COLOR_CIAN$FUNCTION
$COLOR_MAGENTA$POINT$NAME$TEXT_RESET $COLOR_CIAN$AUTHOR
$COLOR_MAGENTA────────────────────────────────────────────────────────────────────────────────────────────────────$TEXT_RESET
_HEADER_
}

# Función Principal que procesa a los usuarios y clasifica segun tiempo de CPU.
ProcessUsr(){
  cabecera  #Dependiendo de la opcion mostramos una cabecera u otra.
  if [[ "$opcion_count" = "1" ]];then
    echo -e "$COLOR_CIAN$(ps -o user:20| head -n 1)\t\tNUM_PROCESS$TEXT_RESET"
  else
    echo -e "$COLOR_CIAN$(ps -o user:20,uid,gid,pid,cputime | head -n 1)\t\tNUM_PROCESS$TEXT_RESET"
  fi
  echo "$COLOR_MAGENTA────────────────────────────────────────────────────────────────────────────────────────────────────$TEXT_RESET"
  
  for i in $lista; do 
    e_time=$(ps -u $i -o user,pid,gid,time --no-headers| sort -u | tr -s ' ' ' ' | cut -d ' ' -f4)
      for j in $e_time; do
        if [[ "$j">"$N" ]]; then  #Se comprueba el si el tiempo del usuario es mayor que N.
          if [ "$opcion_usr" = "1" ]; then
            for k in $usrconect; do
              if [[ "$i" == "$k" ]]; then
                user_match="$i " #Si se verifica que además el usuario pertenece al comando who se guarda en el vector user_match.
              fi
            done
          else
            user_match="$i " # Si la opcion que clasifica para usuarios conectados todos solo guardamos todos los usuarios en el vector.
          fi
        fi
      done
      # En el siguiente for hacemos la visualización de los datos para esos usuarios con mayor tiempo que N.
      for i in $user_match; do 
        if [[ "$opcion_count" = "1" ]]; then   #Si se interesa mostrar solo los procesos mostramos el nombre y proceso.
          username=$(ps -u $i -o user:20 --sort=cputime --no-headers|tail -n 1 | uniq)
          numproc=$(ps -u $i | wc -l|uniq )
          printf "${username}\t\t${numproc}\n"
        else                                  #Sino se mmuestra todo y se imprime.
          username=$(ps -u $i -o user:20,uid,gid,pid,cputime:10 --sort=cputime --no-headers|tail -n 1 | uniq)
          numproc=$(ps -u $i | wc -l|uniq )
          printf "${username}\t${numproc}\n"
        fi           
        
      done

      
  done
       
}

#Funcion que cambia el formato del tiempo de segundos a horas:minutos:segundos.
Seconds_format_xx()
{
  SECONDS="$auxN"
  echo | awk -v "S=$SECONDS" '{printf "%02d:%02d:%02d",S/(60*60),S%(60*60)/60,S%60}' #Seleccionamos los srgundos y modificamos su salida 
}                                                                                    #de forma que sean cifras de 2 digitos y dentro de estas se hacen los calculos aritmeticos necesarios.


#Función que controla la salida de errores.
error_exit(){
  case $1 in
    1) echo "$COLOR_RED Error!: Opcion seleccionada no valida$TEXT_RESET" 1>&2
			help_func
			exit 1
			;;

    2) echo "$COLOR_RED Error!: Los argumentos introducidos son incompatibles$TEXT_RESET" 1>&2
      help_func
      exit 1
      ;;

    3) echo "$COLOR_RED Error!: opcion no encontrada $TEXT_RESET" 1>&2
      help_func
      exit 1
      ;;
    *) echo "$COLOR_RED Error Desconocido $TEXT_RESET" 1>&2
      help_func
      exit 1
      ;;
  esac

}


#Función Help que muestra el uso del script al usuario.

help_func(){

  echo "→ MODO DE USO:$COLOR_RED./userProc.sh$TEXT_RESET $COLOR_MAGENTA[-t segundos] [-u usuario1 usuario2] [-usr] [-inv] [-h o --help] $TEXT_RESET "
 echo "$COLOR_BLACK══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════$TEXT_RESET"
  echo "$COLOR_GREEN Las opciones soportadas son:$TEXT_RESET"
  echo "→$COLOR_MAGENTA Sin argumentos:$TEXT_RESET $COLOR_GREEN Mostrará los usuarios que están ejecutando procesos con un tiempo de cpu consumido mayor que 1 segundo$TEXT_RESET"
  echo "→$COLOR_MAGENTA [-t segundos]:$TEXT_RESET $COLOR_GREEN Mostrará los usuarios que están ejecutando procesos con un tiempo de cpu consumido mayor que N segundos$TEXT_RESET"
  echo "→$COLOR_MAGENTA [-u usuario1 usuario2]:$TEXT_RESET $COLOR_GREEN Mostrará los usuarios especificados en usuario1 usuario2 usuario3 que están ejecutando procesos con un tiempo de cpu consumido mayor que 1 segundos$TEXT_RESET"
  echo "→$COLOR_MAGENTA [-usr]:$TEXT_RESET $COLOR_GREEN Mostrará los usuarios que están conectados (online) y estan ejecutando algún proceso mayor de 1 segundos$TEXT_RESET"
  echo "→$COLOR_MAGENTA [-inv]:$TEXT_RESET $COLOR_GREEN Mostrará los usuarios en orden inverso que están ejecutando procesos con un tiempo de cpu consumido mayor que N segundos $TEXT_RESET"
  echo "→$COLOR_MAGENTA [-h o --help]:$TEXT_RESET $COLOR_GREEN Mostrará la ayuda para los usuarios que no sepan como ejecutar el código$TEXT_RESET"
   echo "$COLOR_BLACK══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════$TEXT_RESET"

}



#────────────────────────┤ Función Main ├──────────────────────────────
################################################################################################################
#────────────────────────┤ Gestión de las opciones pasadas por línea de comando ├──────────────────────────────

clear
while [ "$1" != "" ]; do #Analizamos lo que se recibe por parámetros y vemos los diferentes casos soportados.
  case $1 in #Primer caso si se introduce -h o --help se muestra ayuda del programa
    --help | -h )
      opcion_help=1	
      ;;

    -t )   #Caso -t N y
      echo " Seleccionando el Número"
      opcion_t=1
      shift
      auxN=$1  #se guarda en $1 el valor de los segundos 
      N=$(Seconds_format_xx)  #Se transforma la variable encargada de comparar el tiempo.
      ;;

    -usr )  #Caso de los usuarios conectados se activa el flag y en el ProcessUsr se compara con el comando who
      echo "Filtrando por usuarios conectados a $HOSTNAME"
      opcion_usr=1
      ;;
 
    -u ) #Caso -u se filtra por usuarios especificados
      echo "Filtrando por usuarios especificados"
      opcion_filter=1 
      #Mientras no sea un valor nulo se va guardando los distintos usuarios en un vector llamado usuario_parametro
      while [[ $2 != "" ]]; do
        usuario_parametro+="$2 "
        shift
      done
      #Comprobabamos que los usuarios introducidos forman parte de la lista de usuarios que estan ejecutando algun proceso.
      for i in $usuario_parametro; do
        for j in $copia_lista_usuarios; do
          if [[ "$i" == "$j" ]]; then
            lista=$usuario_parametro
          fi
        done
      done
      ;;

    -inv )  #Función inversa se modifica la lista de usuarios a un orden inverso.
      echo "Ordenando por INVERSA"
      opcion_inv=1
      lista=$(ps -A -o user --no-headers|sort -r |uniq)
      ;;


    -count ) #Funcion count se activa el flag y se muestra uno de los dos 
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
error_exit 3
fi

#────────────────────────┤ Fin del programa ├──────────────────────────────
exit 0 #se sale con codigo de error 0 para especificar que hubo una salida exitosa.