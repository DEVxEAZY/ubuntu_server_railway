FROM ubuntu:latest

# Atualiza a lista de pacotes e instala o wget
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get -y install wget

# Baixa e instala o ttyd
RUN wget -qO /bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64 && \
    chmod +x /bin/ttyd

# Define a porta a ser exposta
EXPOSE $PORT

# Armazena as credenciais em um arquivo de depuração
RUN echo $CREDENTIAL > /tmp/debug

# Define o comando de inicialização
CMD ["/bin/bash", "-c", "/bin/ttyd -p $PORT -c $USERNAME:$PASSWORD /bin/bash"]
