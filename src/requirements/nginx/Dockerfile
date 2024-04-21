FROM debian:bullseye 

RUN apt-get update -q && \
    apt-get install -y \
    nginx\
    openssl \
    curl \
    vim \
    bash

# RUN apt-get install OpenSSL -y
RUN mkdir /etc/nginx/ssl
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=AR/L=KHOURIBGA/OU=1337/CN=nkhoudro.42.fr/UID=nkhoudro"
COPY ./conf/nginx.conf /etc/nginx/conf.d
RUN mkdir -p /run/nginx
# RUN chmod 755 /var/www/html
# RUN chown -R www-data:www-data /var/www/html
EXPOSE 443 

CMD [ "nginx", "-g", "daemon off;"]
