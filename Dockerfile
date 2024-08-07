# Usar a imagem base do Ubuntu
FROM ubuntu:latest

# Atualizar a lista de pacotes e instalar dependências do sistema
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y wget python3-full python3-pip \
    libx11-xcb1 libxtst6 libnss3 libxss1 liboss4-salsa-asound2 \
    scrot python3-tk python3-dev python3-setuptools libffi-dev \
    chromium-driver

# Instalar ttyd
RUN wget -qO /bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64 && \
    chmod +x /bin/ttyd

# Limpar o cache do apt para reduzir o tamanho da imagem
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Definir o diretório de trabalho
WORKDIR /app

# Instalar virtualenv
RUN pip3 install virtualenv

# Criar e ativar um ambiente virtual
RUN virtualenv venv

# Copiar arquivo de requisitos
COPY requirements.txt .

# Instalar dependências dentro do ambiente virtual
RUN ./venv/bin/pip install --no-cache-dir -r requirements.txt

# Copiar o código fonte para o diretório de trabalho
COPY . .

# Expor a porta especificada
EXPOSE $PORT

# Armazenar as credenciais em um arquivo de depuração
RUN echo $CREDENTIAL > /tmp/debug

# Comando para inicialização
CMD ["/bin/bash", "-c", "/bin/ttyd -p $PORT -c $USERNAME:$PASSWORD /bin/bash"]
