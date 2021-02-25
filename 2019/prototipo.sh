#!/bin/bash
#Practica final de bash
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#constantes

  TITLE="Información del Sistema para $HOSTNAME"


#Estilos
  TEXT_ULINE=$(tput sgr 0 1)
  TEXT_BOLD=$(tput bold)
  TEXT_CIAN=$TEXT_BOLD$(tput setaf 6)$TEXT_RESET
  TEXT_RESET=$(tput sgr0)
  TEXT_YELLOW=$TEXT_BOLD$(tput setaf 3 20)
  TEXT_RED=$TEXT_BOLD$(tput setaf 1 20)
  ARROW="$TEXT_BOLD--> $TEXT_RESET"
  LINE="-------------------------------------------------------"

#variables

  on_opt=0
  off_opt=0
  u_opt=0
  r_opt=0
  kill_opt=0
  user_on=$(users)
  #other_option=$(ps -Af --no-headers | tr -s ' ' ' ' | cut -d ' ' -f1 |sort | uniq)
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#funciones:

  fail_function()
  {
    case $1 in

      1 )
        echo "$TEXT_RED =============/La opción que ha seleccionado no es valida/=====================  $TEXTRESET"
        echo " -> Para consultar el manual introduzca: [nombre_ejecutable].sh [--man]"
        exit 1
        ;;
        2 )
          echo "$TEXT_RED ¡ALERT!: Caso Improbable  $TEXTRESET"
          exit 1
          ;;
      * )
        echo "$TEXT_RED Acaba de encontrar un error no registrado $TEXT_RESET"
        exit 1
        ;;
    esac
  }


#Función que maneja la lista de usuarios
  lista_usuarios()
  {
    echo -e "$(ps axo user:20,uid,gid,comm:20,pcpu,cputime,comm,cputime| head -n 1) \tNum_ficheros \tNumeros_procesos\n"

    if [ "$off_opt" -eq "1" ]; then
      for i in $(echo $usuarios); do
        if [ "$i" != "$user_on" ]; then
          show_date=$(ps -u $i -o user:20,uid,gid --no-headers|uniq )
          show_cpu=$(ps -o comm,%cpu,cputime -u $i --no-headers --sort=-%cpu|head -n 1|uniq )
          show_old_process=$( ps -o comm,etime -u $i --no-headers --sort=-etime|head -n 1|uniq )
          show_process=$(ps -u $i | wc -l )
          fich_number=$(lsof -u $i | tail -n +2 |wc -l )
          printf " ${show_date} ${show_cpu} ${show_old_process} \t\t${fich_number} \t\t ${show_process} \n"
        fi
      done
    else

      for i in $(echo $usuarios); do
        show_date=$(ps -u $i -o user:20,uid,gid --no-headers|uniq )
        show_cpu=$(ps -o comm,%cpu,cputime -u $i --no-headers --sort=-%cpu|head -n 1|uniq )
        show_old_process=$(ps -o comm,etime -u $i --no-headers --sort=-etime|head -n 1|uniq )
        show_process=$(ps -u $i | wc -l|uniq )
        fich_number=$(lsof -u $i | tail -n +2 |wc -l )
        printf " ${show_date}: ${show_cpu} ${show_old_process} \t\t${fich_number} \t\t${show_process} \n "
      done
    fi

  }
#Manual en caso de que el usuario tenga dudas
  manual()
  {
    clear
    echo " =========================/Manual del Usuario/========================================"
    echo " Si tiene alguna duda ejecute el codigo como a continuación se le muestra: "
    echo
    echo -e "\t $ARROW $TEXT_CIAN nombre_ejecutable.sh [-U] [-R] [-ON] [-OFF] [-k N] $TEXT_RESET"
    echo
    echo " tenga en cuenta que las extensiones son las siguientes: "
    echo " [-U]: se ordenará por UID "
    echo " [-R]: reverse se ordenará inversamente, tanto por nombre de usuario como por UID "
    echo " [-ON]: online, se mostrará únicamente la información de los usuarios que esten realmente conectados al sistema, eliminando usuarios no reales. "
    echo " [-OFF]: offline, se mostrará la información de usuarios falsos y que no esten conectados en el sistema "
    echo " [-k N]: eliminar los procesos, con un número de ficheros abiertos superior al indicado.  "
  }

#Funcion principal
  write_page()
  {
cat << _EOF_
    $ARROW $TEXT_BOLD $TEXT_YELLOW $TITLE $TEXT_RESET
    $LINE

    $(lista_usuarios)

_EOF_

  }
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#Menú principal
  while [ "$1" != "" ]; do
    case $1 in
      -U )
          echo "Ejecutando con argumento -U"
          u_opt=1
          ;;

      -R )
          echo "Ejecutando con argumento -R"
          r_opt=1
          ;;

      -ON )
          echo "Ejecutando con argumento -ON"

          on_opt=1
          ;;

      -OFF )
          echo "Ejecutando con argumento -OFF"

          off_opt=1
          ;;

      --man )
          manual
          exit 1
          ;;

        * )
          fail_function 1
          exit 1
          ;;
      esac
      shift
    done
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    #Caso default (0000)
    if [ "$u_opt" = "0" ] &&  [ "$r_opt" = "0" ] && [ "$on_opt" = "0" ] && [ "$off_opt" = "0" ]; then
        usuarios=$(ps -A -o user --no-headers|sort -u|uniq)
#OPCION ON Y SUS COMBINACIONES:
#------------------------------------------------------------------------------------------------------------------
      #Si la opcion -ON es la unica activada (0010)
      elif [ "$u_opt" = "0" ] &&  [ "$r_opt" = "0" ] && [ "$on_opt" = "1" ] && [ "$off_opt" = "0" ]; then
        usuarios=$(ps u --no-headers | tr -s ' ' ' '| cut -d ' ' -f1|uniq)

      #si ON y R son activados a la vez(0110)
      elif [ "$u_opt" = "0" ] &&  [ "$r_opt" = "1" ] && [ "$on_opt" = "1" ] && [ "$off_opt" = "0" ]; then
        usuarios=$( ps u --no-headers |sort -r | tr -s ' ' ' '| cut -d ' ' -f1|uniq )

      #Si ON y U son activadas (1010)
      elif [ "$u_opt" = "0" ] &&  [ "$r_opt" = "0" ] && [ "$on_opt" = "1" ] && [ "$off_opt" = "0" ]; then
        usuarios=$( ps u --no-headers --sort=uid| tr -s ' ' ' '| cut -d ' ' -f1|uniq   )

      #Si ON R Y U son activadas a la vez (1110)
      elif [ "$u_opt" = "1" ] &&  [ "$r_opt" = "1" ] && [ "$on_opt" = "1" ] && [ "$off_opt" = "0" ]; then
        usuarios=$( ps u --no-headers --sort=uid| tr -s ' ' ' '| cut -d ' ' -f1|uniq  )
#------------------------------------------------------------------------------------------------------------------

#OPCION OFF Y SUS COMBINACIONES:
      #Si la opcion -OFF es la unica activada (0001)
      elif [ "$u_opt" = "0" ] &&  [ "$r_opt" = "0" ] && [ "$on_opt" = "0" ] && [ "$off_opt" = "1" ]; then
        usuarios=$(ps -A -o user --no-headers | sort| uniq)

      #Si OFF y R son activadas (0101)
      elif [ "$u_opt" = "0" ] &&  [ "$r_opt" = "1" ] && [ "$on_opt" = "0" ] && [ "$off_opt" = "1" ]; then
        usuarios=$( ps -A -o user --no-headers | sort -r | uniq  )

      #Si OFF , U Y R son activadas
      elif [ "$u_opt" = "1" ] &&  [ "$r_opt" = "1" ] && [ "$on_opt" = "0" ] && [ "$off_opt" = "1" ]; then
        usuarios=$( ps -A -o user --no-headers --sort=-uid|uniq  )
#------------------------------------------------------------------------------------------------------------------
#RESTO DE OPCIONES
      #Si la opcion -U es la unica activada(1000)
      elif [ "$u_opt" = "1" ] &&  [ "$r_opt" = "0" ] && [ "$on_opt" = "0" ] && [ "$off_opt" = "0" ]; then
        usuarios=$( ps -A -o user --no-headers --sort=uid | uniq  )

      #Si la opcion -R es la unica activada (0100)
      elif [ "$u_opt" = "0" ] &&  [ "$r_opt" = "1" ] && [ "$on_opt" = "0" ] && [ "$off_opt" = "0" ]; then
        usuarios=$( ps -A -o user --no-headers | sort -r | uniq)

      #Si U y R son activados a la vez(1100)
      elif [ "$u_opt" = "1" ] &&  [ "$r_opt" = "1" ] && [ "$on_opt" = "0" ] && [ "$off_opt" = "0" ]; then
        usuarios=$( ps -A -o user --no-headers --sort=-uid|uniq  )

      #Si OFF Y U son activadas a la vez (1001)
      elif [ "$u_opt" = "1" ] &&  [ "$r_opt" = "0" ] && [ "$on_opt" = "0" ] && [ "$off_opt" = "1" ]; then
        usuarios=$( ps -A -o user --no-headers --sort=uid| uniq  )
  #------------------------------------------------------------------------------------------------------------------
#CASOS IMPROBABLES
      #Si On y OFF son activadas (0011)
      elif [ "$u_opt" = "0" ] &&  [ "$r_opt" = "0" ] && [ "$on_opt" = "1" ] && [ "$off_opt" = "1" ]; then
        fail_function 2
        exit 1

      # Si ON OFF Y U son activadas (1011)
      elif [ "$u_opt" = "1" ] &&  [ "$r_opt" = "0" ] && [ "$on_opt" = "1" ] && [ "$off_opt" = "1" ]; then
        fail_function 2
        exit 1

      # Si ON OFF Y R son activadas (0111)
      elif [ "$u_opt" = "0" ] &&  [ "$r_opt" = "1" ] && [ "$on_opt" = "1" ] && [ "$off_opt" = "1" ]; then
        fail_function 2
        exit 1

      # Si ON OFF U  y R son activadas (1111)
      elif [ "$u_opt" = "1" ] &&  [ "$r_opt" = "1" ] && [ "$on_opt" = "1" ] && [ "$off_opt" = "1" ]; then
        fail_function 2
        exit 1
    fi
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    write_page
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#final del programa
  exit 0
