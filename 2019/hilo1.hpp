#pragma once //Para asegurarte de que el compilador no pete por ser hpp.

#include <iostream>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/ip.h>
#include <cstring>
#include <thread>

//Lee el fichero y lo envia.


//Como traes la estructura?
void recibirMessage(ipForSocket){
  try{
    sockaddr_in destino{};
    destino = make_ip_address("127.0.0.1",2234);
    Message message{};
    receive_from(message, destino);
    //Imprimir en pantalla falta
    
    //Falta bucle y enciarlo al main
  }catch(std::exception){
    eptr=std::current_exception();
  }

}


