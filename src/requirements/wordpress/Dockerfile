FROM debian:bullseye

RUN apt-get update && \
    apt-get -y install wget php php-fpm php-mysql mariadb-client curl

RUN sed -i 's#listen = /run/php/php7.4-fpm.sock#listen = 0.0.0.0:9000#' /etc/php/7.4/fpm/pool.d/www.conf

COPY ./conf/script.sh /
# COPY ./conf/wp-config.php /
RUN chmod +x /script.sh
# EXPOSE 9000

CMD ["/script.sh"]