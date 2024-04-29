FROM debian:bullseye
# RUN sh -c  'apt-get update -y && apt-get upgrade -y && \
#     apt-get install -y mariadb-server'

RUN apt update && apt -y install mariadb-server

# RUN chown -R mysql: /var/lib/mysql
# COPY ./conf/myconf.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY ./conf/script.sh /script.sh
RUN chmod +x /script.sh

# EXPOSE 3306
# CMD ["/script.sh"]

ENTRYPOINT [ "./script.sh" ]
