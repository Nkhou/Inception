#!/bin/bash

service mariadb start
# sleep 10
# cat 2> /dev/null
until mysqladmin ping >/dev/null 2>&1; do
  echo "Still waiting..."
  sleep 2
done

echo "MariaDB is ready"

echo "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE ;" > db1.sql
echo "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD' ;" >> db1.sql
echo "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' ;" >> db1.sql
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD' ;" >> db1.sql
echo "FLUSH PRIVILEGES;" >> db1.sql

mysql < db1.sql
# if mysql -u root < db1.sql; then
#    echo "Database setup completed successfully"
# else
#    echo "Failed to execute SQL commands"
#    exit 1
# fi

#  echo "Removing SQL commands file..."
#  rm db1.sql

kill $(cat /var/run/mysqld/mysqld.pid)

mysqld
# mysql -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
# mysql -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';"
# mysql -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';"
# mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}'; "

# mysql -u root -p$MYSQL_ROOT_PASSWORD -e "FLUSH PRIVILEGES;"
# mysqladmin -u root -p$MYSQL_ROOT_PASSWORD shutdown
# mysqld_safe

