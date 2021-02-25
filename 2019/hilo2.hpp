#pragma once //Para asegurarte de que el compilador no pete por ser hpp.
//Lee la entrada estandar

void enviarMessage(){
  try{
    std::string message_text("¡Hola, mundo!");
    Message message{};
    message_text.copy(message.text, sizeof(message.text) - 1, 0);    
  }catch(std::exception){
    eptr=std::current_exception();
  }
}

//A quien enviarlo y que archivo debe