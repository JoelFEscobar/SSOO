/*
* PRACTICA DE SISTEMAS OPERATIVOS: NETCP.
*******************************************************************
* Autor: Joel Francisco Escobar Socas.
* Asignatura: Sistemas Operativos.
* Fichero: socket.cpp -> fichero que describe toda la funcionalidad del socket.h
*******************************************************************
*/

#include "socket.h"
#include "file.h"
// Definicion de la estructura de las IP


//Constructor
Socket::Socket(const sockaddr_in& address){

    fd_= socket(AF_INET, SOCK_DGRAM, 0); 
    if (fd_ < 0) {
        std::cerr << "falló socket: " <<'\n';
    }
    int result = bind(fd_, reinterpret_cast<const sockaddr*>(&address), sizeof(address));
    if( result < 0 ){
        std::cerr <<"fallo bind: " << '\n';
    }
    std::cout<< ">> Se ha creado un socket"<<"\n";
}
 
//Destructor
 Socket::~Socket(){
     close(fd_);
 }
//Función que envia mensaje 
 void Socket::send_to(const Message& message, const sockaddr_in& address){

    int result = sendto(fd_, &message, sizeof(message), 0, reinterpret_cast<const sockaddr*>(&address),sizeof(address));
    
    if (result < 0) {
        std::cerr << "falló sendto: " << std::strerror(errno) << '\n';
        //return 6;	// Error. Terminar con un valor diferente y > 0
    }
    std::cout<<">> Se ha enviado el mensaje correctamente"<< '\n';
 }

 //Funcion que envia los datos al puntero
 void Socket::send_to(const void* puntero, const int length){
    int value = sendto(fd_,puntero,length,0,reinterpret_cast<const sockaddr*>(&puntero),sizeof(puntero));
    if (value < 0) {
        std::cerr << "falló sendto al puntero: " << std::strerror(errno) << '\n';
        //return 6;	// Error. Terminar con un valor diferente y > 0
    }
}

// Función que lee los mensajes
void Socket::receive_from(Message& message, sockaddr_in& address){
//Buscamos el mensaje
   socklen_t src_len = sizeof(address);
   int result = recvfrom(fd_, &message, sizeof(message), 0, reinterpret_cast<sockaddr*>(&address), &src_len);
    
    if (result < 0) {
        std::cerr << "falló recvfrom: " << std::strerror(errno) << '\n';
        //return 8;
    }
    std::cout << "hasta aqui va bien " << '\n';
    //Mostramos el mensaje
    char* remote_ip = inet_ntoa(address.sin_addr);
    int remote_port = ntohs(address.sin_port);
    message.text[1023] = '\0';
    std::cout << "El sistema " << remote_ip << ":" << remote_port << " envió el mensaje '" << message.text.data() << "'\n";
}

//Funcion que lee en la zona de memoria
 void Socket::recive_from(void* puntero, int length, file archivo, Message mensaje){
    socklen_t src_len = sizeof(puntero);
    int value = recvfrom(fd_, puntero,length,0,reinterpret_cast<sockaddr*>(puntero), &src_len );
    if (value < 0) {
        std::cerr << "falló recvfrom del mapeado: " << std::strerror(errno) << '\n';
        //return 8;
    }

    //lo guardamos en el archivo
    //Archivo << contenido;
   // mejorar esto ---> archivo << &mensaje.text;

}

