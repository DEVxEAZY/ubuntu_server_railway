FROM ubuntu:latest

# Instala dependências incluindo systemd, nginx e php-fpm
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y wget systemd systemd-sysv nginx php-fpm && \
    apt-get clean

# Baixa e instala o ttyd
RUN wget -qO /bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64 && \
    chmod +x /bin/ttyd

# Copia a configuração personalizada do Nginx
COPY default /etc/nginx/sites-available/default

# Habilita os serviços no systemd
RUN systemctl enable nginx && systemctl enable php7.4-fpm

# Expor a porta 80
EXPOSE 80

# Configura ponto de entrada para usar systemd
CMD ["/lib/systemd/systemd"]
