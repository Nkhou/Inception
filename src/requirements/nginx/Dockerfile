FROM debian:bullseye 

RUN apt-get update -q && \
    apt-get install -y \
    nginx\
    openssl \
    curl \
    vim \
    bash

COPY ./tools/script.sh /script.sh
RUN chmod +x /script.sh
COPY ./conf/nginx.conf /etc/nginx/conf.d

EXPOSE 443 

ENTRYPOINT ["/script.sh"]
