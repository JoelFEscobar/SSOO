#!/bin/bash
# P6_joel.sh :Un script que informa del estado del sistema
# Autor: Joel francisco Escobar Socas

#Constantes
TITLE="-> Información del Sistema para $HOSTNAME <- "
RIGHT_NOW=$(date +"%x %r%Z")
UPDATED_TIME="-> Script actualizado el $RIGHT_NOW por $USER <-"
AUTHOR="-> Autor: Joel Francisco Escobar Socas <-"


# Estilos
TEXT_BOLD=$(tput bold)
COLOR_GREEN=$TEXT_BOLD$(tput setaf 2)$TEXT_RESET
COLOR_MAGENTA=$TEXT_BOLD$(tput setaf 5)$TEXT_RESET
COLOR_CIAN=$TEXT_BOLD$(tput setaf 6)$TEXT_RESET
TEXT_RESET=$(tput sgr0)
TEXT_ULINE=$(tput sgr 0 1)


# Variables que va a representar las opciones por defecto del usuario:
interactive=
filename=~/sysinfo.txt



# Funciones
system_info()
{
  # Funcion de stub temporal
  echo "${TEXT_ULINE}${COLOR_GREEN}Versión del sistema${TEXT_RESET}"
  uname -a
} 

show_uptime()
{
  # Función de stub temporal
  echo "${TEXT_ULINE}${COLOR_GREEN}Tiempo de encendido del sistema$TEXT_RESET"
  uptime
  
}


drive_space()
{
  # Función de stub temporal  
  echo "${TEXT_ULINE}${COLOR_GREEN}Espacio Ocupado por Particiones y Discos Duros$TEXT_RESET"
  df -h 
} 


home_space()
{
  # Función de stub temporal
  echo "${TEXT_ULINE}${COLOR_GREEN}Espacio ocupado en los Directorios$TEXT_RESET"
  if [ $(id -u) = 0 ];then
    echo "Bienvenido ${COLOR_MAGENTA}root${TEXT_RESET} de $HOSTNAME."
    echo "El espacio de los directorios es: "
    du -sh /home/* | sort -h
  else 
    echo "Bienvenido ${COLOR_MAGENTA}usuario${TEXT_RESET} de $HOSTNAME." 
    echo "El espacio de su directorio es: "

    du -sh $HOME | sort -h
  fi

}


usage()
{
  echo "${COLOR_MAGENTA}Ayuda para el usuario:${TEXT_RESET} "
  echo "(Default) Si quieres ejecutar el programa por defecto no introduzca nada"
  echo "(Opción -f) ./P6_joel.sh -f file_name : Especificas la salida del script a un fichero de nombre 'file_name'"
  echo "(Opcion -h) ./P6_joel.sh -h: Muestra la ayuda para el usuario"
  echo "(Opcion -i) ./P6_joel.sh -i: Entra en modo interactivo con el usuario"
  echo "(Default -i) si desea guardar por defecto en el modo interactivo, noe scriba nada y pulse enter"

}


# Modo interactivo implementado segun el guion
interactive_option(){
if [ "$interactive" = "1" ]; then
  echo "Introduzca el nombre del fichero de salida: "
  read name 
  if [ -f $name ]; then
    while [ "$fich" != '1' ]; do
      echo "¿Desea sobreescribir el archivo con ese nombre? (Y/N) > " 
      read seleccion
      case $seleccion in
        "Y" | "y")
          echo "Se va a sobreescribir el archivo, espere"
          filename=$name  
          fich=1
        ;;

        "N" | "n")
          echo "Saliendo..."
          fich=1 
          exit 0
        ;;

        * ) 
          echo "La opción introducida no es valida, escriba 'y' o 'n' por favor"
				  fich=0
			    ;;
      esac
    done 

  fi
fi
}




# Programa Principal
write_page(){

cat << _MAIN_

$TEXT_BOLD$COLOR_MAGENTA$TITLE$TEXT_RESET
  $COLOR_CIAN$UPDATED_TIME$TEXT_RESET
    $COLOR_CIAN$AUTHOR$TEXT_RESET

$(system_info)

$(show_uptime)

$(drive_space)

$(home_space)

_MAIN_

}


#switch que analiza las entrada por comando


while [ "$1" != "" ]; do
   case $1 in
       -f | --file )

            shift
           filename=$1
           ;;
       -i | --interactive )

            interactive=1
            interactive_option
            ;;
       -h | --help )

            usage
           exit
           ;;
       * )

            usage
           exit 1
   esac
   shift
done


#Guardar en el fichero

write_page > $filename



  mostrar_usuario=5
  ps -e -o user,pid,uid,gid,time | sort | tr ':' ' ' | awk '$7>'$mostrar_usuario' { print $1,$2,$3,$4,$5,$6,$7 }'