#pragma once 

#include <array>

//Estructura de los mensajes.
struct Message{
  std::array<char, 1024> text;
};

class Socket{
  public:
    //Constructor
    Socket(const sockaddr_in& ip_address);
    //Destructor
    ~Socket();

    //funcion enviar a
    void send_to(const Message& message, const sockaddr_in& ip_address);
    //Recibir de
    void receive_from(Message& message, sockaddr_in& ip_address);

  private:
    int fd_;
    int result_;
};
