#!/bin/bash
# Ejercicios Semana 3 Redirecciones y control de procesos. 
# Autor: Joel Francisco Escobar Socas
# ==========================================================================================


# Antes de comenzar con los ejercicios vamos de forma previa a usar los siguientes comandos en nuestra sesión:
# "xload" 
# Este comando nos permite ver la representación gráfica del uso de CPU, al añadirle el carácter &
# lo ejecutamos directamente en segundo plano.

echo "EJERCICIOS SEMANA 3: REDIRECCIONES Y CONTROL DE PROCESOS "
echo " Autor: Joel Francisco Escobar Socas"
echo " ───────────────────────────────────────────────────────────"
#Ejercicio 1

 echo "1) Contar el número de procesos de nuestra sesión que están ejecuntadose en segundo plano: "

 jobs -r | wc -l

# "jobs" nos muestra el numero de procesos de nuestra sesion en segundo plano y su opcion "- r" solo los que estan en ejecucion  
# "wc -l" permite contar el numero de procesos y solo seleccionar en la tabla la primera fila

#Ejercicio 2

# Si ahora ejecutamos el comando "fg id" , traemos a primer plano al proceso 1 .
# Si luego presionamos ctrl + z lo ponemos en estado de detenido.
  # fg 1
  #ctrl + z


 echo " ───────────────────────────────────────────────────────────"
 echo "2) Contar el número de procesos que están en estado detenidos de entre los de nuestra sesión:"

 jobs -s | wc -l
# visualizamos con la opción "-s" todos los procesos en segundo plano en estado de detenidos de nuestra sesion 


#Ejercicio 3
echo " ───────────────────────────────────────────────────────────"
echo " 3) Mostrar el nombre de los procesos que se están ejecutando en segundo plano:"


jobs -r |tr -s ' ' ' '  |cut -d ' ' -f3

#con "jobs" sacamos todos los procesos y con "tr" 
#sustituimos los espacios por un solo espacio y seleccionamos la fila que visualiza los nombres

#Ejercicio 4 
echo " ───────────────────────────────────────────────────────────"
echo "4) Contar el número total de procesos que estamos ejecutando: "
 ps aux | wc -l 

# Con el "ps aux" visualizamos todos los procesos ejecutandose y con "wc -l" contamos y mostramos el número.

#Ejercicio 5 
echo " ───────────────────────────────────────────────────────────"
echo  "5) Sacar un listado de todos los directorios que hay en nuestro directorio actual: "

ls -ld */ |tr -s ' ' ' ' | cut -d ' ' -f9

#Con "ls -ld */ " mostramos todos los directorios dentro del directorio actual 
#Y aplicamos una serie de tuberias para modificar la visualización 
#     "tr ' ' ' ' ": sustituye todos los espacios en blanco por un espacio en blanco 
#     "cut -d ' ' -f9": muestra solo la file 9 referentes a los nombres


#Ejercicio 6: 
echo " ───────────────────────────────────────────────────────────"
echo "6) Contar el número de programas alojados en nuestro directorio actual donde el grupo otros tiene permisos de ejecución: "

find . -perm 771 

#Con el comando "find " podemos especificar una búsqueda, al añadirle el "." se busca en el directorio actual 
# y con "-perm 771" buscamos los ficheros con permiso de ejecución en el grupo others.