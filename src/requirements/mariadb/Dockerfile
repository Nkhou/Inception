FROM debian:bullseye 
RUN apt-get update -yq && \
    apt-get install -yq \
    openssl \
    curl \
    vim \
    sudo 
ENV MYSQL_ROOT_PASSWORD: password
ENV MYSQL_DATABASE: mydata
ENV MYSQL_USER: najat
ENV MYSQL_PASSWORD: password

EXPOSE 3306
CMD ["mysqld"]
