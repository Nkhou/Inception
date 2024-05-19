#!/bin/bash


# Create directories
echo "Creating directories..."
mkdir -p /var/www/html

# Navigate to html directory
cd /var/www/html

# Clean any existing files
echo "Cleaning existing files..."
rm -rf *

# Download WP-CLI
echo "Downloading WP-CLI..."
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

# Make WP-CLI executable
chmod +x wp-cli.phar

# Move WP-CLI to a directory in PATH
mv wp-cli.phar /usr/local/bin/wp

# Download WordPress core files
echo "Downloading WordPress core files..."
wp core download --allow-root

# Move wp-config-sample.php to wp-config.php
echo "Configuring wp-config.php..."
mv wp-config-sample.php wp-config.php

# Update wp-config.php with database credentials
sed -i -r "s/database_name_here/$DB_NAME/1" wp-config.php
sed -i -r "s/username_here/$DB_USER/1" wp-config.php
sed -i -r "s/password_here/$DB_PWD/1" wp-config.php

# Install WordPress
echo "Installing WordPress..."
wp core install --url="$DOMAIN_NAME" --title="$WP_TITLE" --admin_user="$WP_ADMIN_USR" --admin_password="$WP_ADMIN_PWD" --admin_email="$WP_ADMIN_EMAIL" --skip-email --allow-root

# Create additional WordPress user
echo "Creating WordPress user..."
wp user create "$WP_USR" "$WP_EMAIL" --role=author --user_pass="$WP_PWD" --allow-root

# Install and activate Astra theme
echo "Installing and activating Astra theme..."
wp theme install astra --activate --allow-root

# Install and activate Redis Cache plugin
echo "Installing and activating Redis Cache plugin..."
wp plugin install redis-cache --activate --allow-root

# Update all plugins
echo "Updating all plugins..."
wp plugin update --all --allow-root

# Modify PHP-FPM configuration to listen on port 9000 instead of a socket
echo "Configuring PHP-FPM to listen on port 9000..."
sed -i 's|listen = /run/php/php7.3-fpm.sock|listen = 9000|g' /etc/php/7.3/fpm/pool.d/www.conf

# Create PHP-FPM run directory
echo "Creating PHP-FPM run directory..."
mkdir -p /run/php

# Enable Redis Cache
echo "Enabling Redis Cache..."
wp redis enable --allow-root

# Start PHP-FPM in foreground
echo "Starting PHP-FPM..."
/usr/sbin/php-fpm7.3 -F
