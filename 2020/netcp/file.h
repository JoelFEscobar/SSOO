/*
* PRACTICA DE SISTEMAS OPERATIVOS: NETCP.
*******************************************************************
* Autor: Joel Francisco Escobar Socas.
* Asignatura: Sistemas Operativos.
* Fichero: netcpsend.cpp -> Main encargado de enviar mensajes
*******************************************************************
*/
#pragma once
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/ip.h>
#include <netinet/in.h>
#include <iostream>
#include <cassert>
#include <cmath>
#include <vector>
#include <cstring>
#include <string>
#include <cstdlib>
#include <array>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h> 
#include <cerrno>
#include <arpa/inet.h>
#include <sys/mman.h>

#include "socket.h"




class file {
private:
    int abierto_;
    int length;
    void* puntero_;
public:
    file(std::string nombre_archivo, bool flag_mode);
    ~file();
    ssize_t leer(Message &message);
    void* getter_puntero();
    int file::getter_longitud();
    
};


