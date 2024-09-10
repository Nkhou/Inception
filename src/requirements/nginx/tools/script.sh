#!bin/bash


# mkdir /etc/nginx/ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx-selfsigned.key \
    -out /etc/ssl/certs/nginx-selfsigned.crt \
    -subj "/C=AR/L=KHOURIBGA/OU=1337/CN=nkhoudro.42.fr/UID=nkhoudro"
chmod 755 /etc/ssl/private/nginx-selfsigned.key
chmod 755 /etc/ssl/certs/nginx-selfsigned.crt
# mv /etc/nginx/conf.d/nginx.conf /etc/nginx/nginx.conf
# chmod +x /etc/nginx/conf.d/nginx.conf
nginx  -g "daemon off;"
tail -f /var/log/nginx/error.log
tail -f /var/log/nginx/access.log