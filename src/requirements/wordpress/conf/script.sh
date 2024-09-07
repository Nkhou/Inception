#!/bin/bash

sleep 15

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

mkdir /run/php

cd /var/www/html && wp core download --allow-root
 
mv wp-config-sample.php wp-config.php && wp config set SERVER_PORT 3306 --allow-root
echo $MYSQL_DATABASE
echo $MYSQL_USER
echo $MYSQL_PASSWORD
wp config set DB_NAME $MYSQL_DATABASE --allow-root --path=/var/www/html
wp config set DB_USER $MYSQL_USER --allow-root --path=/var/www/html
wp config set DB_PASSWORD $MYSQL_PASSWORD --allow-root --path=/var/www/html
wp config set DB_HOST 'mariadb:3306' --allow-root --path=/var/www/html

echo "hello"

wp core install --url=$WP_URL --title=INCEPTION --admin_user=$MYSQL_USER --admin_password=$MYSQL_PASSWORD --admin_email=$WP_ADMIN_EMAIL --allow-root --path=/var/www/html --skip-email

wp user create $WP_USER $WP_EMAIL --role=author --user_pass=$WP_PWD --allow-root

/usr/sbin/php-fpm7.4 -F