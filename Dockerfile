# Usar a imagem base do Ubuntu
FROM ubuntu:latest

# Atualizar a lista de pacotes e instalar dependências do sistema
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y wget python3 python3-pip \
    # Dependências para selenium com Chrome
    libx11-xcb1 libxtst6 libnss3 libxss1 libasound2 \
    # Dependências para pyautogui
    scrot python3-tk python3-dev python3-setuptools libffi-dev \
    # Dependências para Chromium
    chromium-driver

# Instalar ttyd
RUN wget -qO /bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64 && \
    chmod +x /bin/ttyd

# Definir o diretório de trabalho
WORKDIR /app

# Copiar arquivo de requisitos
COPY requirements.txt .

# Instalar dependências do Python
RUN pip3 install --no-cache-dir -r requirements.txt

# Copiar o código fonte para o diretório de trabalho
COPY . .

# Expor a porta especificada
EXPOSE $PORT

# Armazenar as credenciais em um arquivo de depuração
RUN echo $CREDENTIAL > /tmp/debug

# Comando para inicialização
CMD ["/bin/bash", "-c", "/bin/ttyd -p $PORT -c $USERNAME:$PASSWORD /bin/bash"]
