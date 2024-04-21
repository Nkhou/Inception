FROM debian:bullseye 
RUN apt-get update -y && \
    apt-get install -y \
    mariadb-server 
# COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# ENV MYSQL_ROOT_PASSWORD: password
# ENV MYSQL_DATABASE: mydata
# ENV MYSQL_USER: najat
# ENV MYSQL_PASSWORD: password

EXPOSE 3306
# CMD ["mysqld"]
