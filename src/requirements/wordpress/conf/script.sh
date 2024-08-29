#!/bin/bash
set -e
sleep 10
# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check for required environment variables
required_vars=(MYSQL_DATABASE MYSQL_USER DB_PASSWORD DB_HOST DOMAIN_NAME WP_TITLE WP_ADMIN_USR WP_ADMIN_PWD WP_ADMIN_EMAIL WP_USR WP_EMAIL WP_PWD)
for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        echo "Error: $var is not set"
        exit 1
    fi
done
echo "Attempting to connect to database at host: $DB_HOST"
echo "Database User: $MYSQL_USER"
echo "Database Name: $MYSQL_DATABASE"

# Function to check MySQL connection
check_mysql_connection() {
    mysqladmin ping -h"$DB_HOST" -u"$MYSQL_USER" -p"$DB_PASSWORD" >/dev/null 2>&1
}

# Wait for database with a timeout
timeout=300  # 5 minutes timeout
elapsed=0
while ! check_mysql_connection && [ $elapsed -lt $timeout ]; do
    echo "Waiting for database connection... (${elapsed}s elapsed)"
    sleep 5
    elapsed=$((elapsed + 5))
done

if [ $elapsed -ge $timeout ]; then
    echo "Error: Unable to connect to the database after ${timeout} seconds"
    echo "Please check your database credentials and connection details"
    exit 1
fi

echo "Successfully connected to the database"

# Create directories
echo "Creating directories..."
mkdir -p /var/www/html

# Navigate to html directory
cd /var/www/html

# Clean any existing files
echo "Cleaning existing files..."
rm -rf *

# Download WP-CLI if not already installed
if ! command_exists wp; then
    echo "Downloading WP-CLI..."
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

# Download WordPress core files
echo "Downloading WordPress core files..."
wp core download --allow-root

# Configure wp-config.php
echo "Configuring wp-config.php..."
wp config create --dbname="$MYSQL_DATABASE" --dbuser="$MYSQL_USER" --dbpass="$MYSQL_ROOT_PASSWORD" --dbhost="$DB_HOST" --allow-root

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

# Check Redis connection and enable Redis Cache if available
if command_exists redis-cli && redis-cli ping > /dev/null 2>&1; then
    echo "Enabling Redis Cache..."
    wp redis enable --allow-root
else
    echo "Warning: Redis is not accessible. Skipping Redis Cache setup."
fi

# Set appropriate permissions
echo "Setting file permissions..."
chown -R www-data:www-data /var/www/html
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;

# Start PHP-FPM
echo "Starting PHP-FPM..."
exec /usr/sbin/php-fpm7.3 -F