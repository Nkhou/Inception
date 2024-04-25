FROM debian:bullseye 
RUN sh -c 'apt-get update -y && apt-get upgrade -y && \
    apt-get install -y \
    mariadb-server' 
COPY ./conf/myconf.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY ./conf/script.sh /

EXPOSE 3306
CMD ["/script.sh"]
