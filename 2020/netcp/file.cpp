/*
* PRACTICA DE SISTEMAS OPERATIVOS: NETCP.
*******************************************************************
* Autor: Joel Francisco Escobar Socas.
* Asignatura: Sistemas Operativos.
* Fichero: netcpsend.cpp -> Main encargado de enviar mensajes
*******************************************************************
*/
#include "file.h"

file::file(std::string nombre_archivo, bool flag_mode) {
   

    if(abierto_ < 0){
        std::cout<<"Error al abrir el archivo\n";
    }
    if(flag_mode == true){
        abierto_ = open(nombre_archivo.c_str() , O_RDONLY);
        lockf(abierto_, F_LOCK, 0);
        length = lseek( abierto_, 0, SEEK_END );
        puntero_ = mmap(NULL,length, PROT_READ, MAP_SHARED,abierto_,0);
        if(puntero_ < 0){
            std::cout<< "Error al mapear la memoria\n";
        }
        
    }
   if(flag_mode == false){
        abierto_ = open(nombre_archivo.c_str() , O_CREAT, S_IRWXU);
        lockf(abierto_, F_LOCK, 0);
        ftruncate(abierto_, length);     
   }
}
    void* file::getter_puntero(){
        return puntero_;
    }

 int file::getter_longitud(){
    return length;
 }

file::~file(){
    close(abierto_);
    munmap(puntero_,length);
    lockf(abierto_, F_ULOCK, 0);	
}

ssize_t file::leer(Message &message) {

    ssize_t verificacion = read(abierto_,&message.text, 1024);
    if(verificacion < 0 ){
        std::cout << "error al leer el fichero\n";
    }
    return verificacion;
}