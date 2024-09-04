#!/bin/bash

sleep 15

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

mkdir /run/php

cd /var/www/html && wp core download --allow-root
 
mv wp-config-sample.php wp-config.php && wp config set SERVER_PORT 3306 --allow-root

wp config set MYSQL_DATABASE $MYSQL_DATABASE --allow-root --path=/var/www/html
wp config set DB_USER $MYSQL_ROOT --allow-root --path=/var/www/html
wp config set DB_PASSWORD $MYSQL_ROOT_PASSWORD --allow-root --path=/var/www/html
wp config set DB_HOST 'mariadb:3306' --allow-root --path=/var/www/html

wp core install --url=$WP_URL --title=INCEPTION --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PWD --admin_email=$WP_ADMIN_EMAIL --allow-root --path=/var/www/html

wp user create $WP_USER $WP_USER_EMAIL --role=author --user_pass=$WP_PWD --allow-root --path=/var/www/html

/usr/sbin/php-fpm7.4 -F