#!/bin/bash


mysqld_safe &

sleep 3

echo "Creating database ${MYSQL_DATABASE}..."
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;" || echo "Failed to create database"

echo "Creating user ${MYSQL_USER}..."
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" || echo "Failed to create user"

echo "Granting privileges..."
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%';" || echo "Failed to grant privileges"

echo "Flushing privileges..."
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES;" || echo "Failed to flush privileges"

echo "Database setup completed"

mysqladmin -u root -p"$MYSQL_ROOT_PASSWORD" shutdown

echo "MariaDB shutdown..."
mysqld_safe
