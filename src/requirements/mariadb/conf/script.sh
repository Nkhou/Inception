#!/bin/bash

service mysql start

mysql -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
mysql -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mysql -u "$MYSQL_ROOT" -p "$MYSQL_ROOT_PASSWORD" -e "ALTER USER \`${MYSQL_ROOT}\`@'localhost' IDENTIFIED BY \`${MYSQL_ROOT_PASSWORD}\`;"
mysql -e "FLUSH PRIVILEGES;"
# mysqladmin -u $MYSQL_ROOT -p $MYSQL_ROOT_PASSWORD shutdown
# exec mysqld_safe