#!/bin/bash

echo "Starting MariaDB setup script"

echo "Starting MariaDB server..."
service mariadb start

echo "Waiting for MariaDB to be ready..."
until mysqladmin ping >/dev/null 2>&1; do
  echo "Still waiting..."
  sleep 2
done
echo "MariaDB is ready"

echo "Checking for root password..."
if [ -n "$MYSQL_ROOT_PASSWORD" ]; then
  echo "Root password is set. Proceeding with database setup."
  
  echo "Creating database ${MYSQL_DATABASE}..."
  mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;" || echo "Failed to create database"
  
  echo "Creating user ${MYSQL_USER}..."
  mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" || echo "Failed to create user"
  
  echo "Granting privileges..."
  mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%';" || echo "Failed to grant privileges"
  
  echo "Flushing privileges..."
  mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;" || echo "Failed to flush privileges"
  
  echo "Database setup completed"
else
  echo "MYSQL_ROOT_PASSWORD is not set. Cannot initialize database."
  exit 1
fi

echo "Keeping MariaDB running..."
tail -f /dev/null
# mysql -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
# mysql -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';"
# mysql -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';"
# mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}'; "

# mysql -u root -p$MYSQL_ROOT_PASSWORD -e "FLUSH PRIVILEGES;"
# mysqladmin -u root -p$MYSQL_ROOT_PASSWORD shutdown
# mysqld_safe

