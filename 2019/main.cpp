#include <iostream>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/ip.h>
#include <cstring>
//#include <thread>

#include "socket.hpp"
//#include "hilo1.hpp"
//#include "hilo2.hpp"


int port;
std::string ip;//esto crea un string
sockaddr_in make_ip_address(const char* ip_address, int port){
  sockaddr_in local_address{};
  local_address.sin_family = AF_INET;
  //Si ip_address está vacío, almacena en ip_address la ip almacenada en sockaddr_in, la ip asignada del ordenador.
  if (ip_address == "")
    local_address.sin_addr.s_addr = htonl(INADDR_ANY);
  else
    inet_aton(ip_address,&local_address.sin_addr);
  local_address.sin_port = htons(port);

  return local_address;
}


int main(int argc, char* argv[]) {
  try{
    port = 2234;
    ip = "127.0.0.1";
    int n = ip.length();
    //str.c_str
    char ip_address[n + 1];
    strcpy(ip_address, ip.c_str());
    //ip_address >> CHAR, ip >> STRING.

    //Estructura sockaddr_in iniciada con valores.
    make_ip_address(ip_address, port);
    auto ipForSocket = make_ip_address(ip_address, port);

    //Crear un Socket
    Socket CreaSocket(ipForSocket);

    //Crear hilos
    //std::thread recibirMessage(ipForSocket);
    //std::thread enviarMessage();
    //recibirMessage.join();	// Bloquear el hilo principal hasta que hilo1 termine
    //hilo2.join();	// Bloquear el hilo principal hasta que hilo2 termine

  //Si se lanza una excepción dentro de try la ejecución saltará al código del bloque catch.
  }catch(std::bad_alloc& e) {
    std::cerr << "mytalk" << ": memoria insuficiente\n";
		return 1;
  }catch(std::system_error& e) {
		std::cerr << "mitalk" << ": " << e.what() << '\n';
    return 2;
	}catch (...) {
    std::cout << "Error desconocido\n";
		return 99;
  }
  return 0;
}
