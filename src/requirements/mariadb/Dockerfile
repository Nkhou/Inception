FROM debian:bullseye 
# Update and install MariaDB server and client
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y mariadb-server mariadb-client
    # apt-get clean  \
    # rm -rf /var/lib/apt/lists/*

# Copy configuration file if needed
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Copy and set permissions for the startup script
COPY ./tools/script.sh /script.sh
RUN chmod +x /script.sh

# Expose MariaDB port
EXPOSE 3306

# Set the entrypoint
CMD ["/script.sh"]