#include <iostream>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/ip.h>
#include <cerrno>
#include <cstring>
#include <unistd.h>

#include "socket.hpp"
using namespace std;

//Constructor
Socket::Socket(const sockaddr_in& ip_address){
  fd_ = socket(AF_INET, SOCK_DGRAM, 0);
  if (fd_ < 0) {
    throw std::system_error(errno, std::system_category(), "Fallo al crear el Socket");
  }

  result_ = bind(fd_, reinterpret_cast<const sockaddr*>(&ip_address), sizeof(ip_address));
  if (result_ < 0)
    throw std::system_error(errno, std::system_category(), "Fallo bind");
}

//Destructor
Socket::~Socket() {
  close(fd_);
  close(result_);
}


//==================/Funciones implementadas/===============================
//Send_to.
void Socket::send_to(const Message &message, const sockaddr_in &ip_address) {
  int enviar = sendto(fd_, &message, sizeof(message), 0, reinterpret_cast<const sockaddr*>(&ip_address), sizeof(ip_address));
  if(enviar < 0)
    throw std::system_error(errno, std::system_category(), "Fallo enviarMessage");
}

//Recivir.
void Socket::receive_from(Message &message, sockaddr_in &ip_address) {
  socklen_t src_len = sizeof(ip_address);
  int recibir = recvfrom(fd_, &message, sizeof(message), 0, reinterpret_cast<sockaddr*>(&ip_address), &src_len);
  if(recibir < 0)
    throw std::system_error(errno, std::system_category(), "Fallo recibirMessage");
}
