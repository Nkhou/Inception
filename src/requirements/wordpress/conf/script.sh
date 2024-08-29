#!/bin/bash
set -e

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}
network_diagnostics() {
    log "Running network diagnostics..."
    log "Container IP address:"
    hostname -I
    log "Container DNS settings:"
    cat /etc/resolv.conf
    log "Pinging mariadb:"
    ping -c 4 mariadb
    log "Trying to connect to mariadb:"
    nc -zv mariadb 3306
    log "Environment variables:"
    env | grep -E 'MYSQL|WORDPRESS|WP'
}
wait_for_db() {
    log "Waiting 10 seconds before attempting database connection..."
    sleep 10

    log "Waiting for database to be ready..."
    for i in {1..30}; do
        if mysql -h mariadb -u'root' -p"$MYSQL_ROOT_PASSWORD" -e "SELECT 1" >/dev/null 2>&1; then
            log "Database is ready"
            return 0
        fi
        log "Still waiting for database... (Attempt $i/30)"
        log "Connection error: $(mysql -h mariadb -u"root" -p"$MYSQL_ROOT_PASSWORD" -e "SELECT 1" 2>&1)"
        sleep 5
    done
    log "Database did not become ready in time"
    return 1
}

setup_wordpress() {
    log "Setting up WordPress..."

    # Ensure the target directory exists
    mkdir -p /var/www/html
    cd /var/www/html || exit 1

    # Download and install WP-CLI if not already present
    if [ ! -f "/usr/local/bin/wp" ]; then
        log "Downloading WP-CLI..."
        curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
        chmod +x wp-cli.phar
        mv wp-cli.phar /usr/local/bin/wp
    fi

    # Download WordPress core
    log "Downloading WordPress..."
    wp core download --allow-root || { log "Failed to download WordPress"; exit 1; }

    # Create wp-config.php
    log "Creating wp-config.php..."
    wp config create --dbname="$MYSQL_DATABASE" --dbuser="$MYSQL_USER" --dbpass="$MYSQL_PASSWORD" --dbhost="mariadb" --allow-root || { log "Failed to create wp-config.php"; exit 1; }

    # Install WordPress
    log "Installing WordPress..."
    wp core install --url="$DOMAIN_NAME" --title="INCEPTION" --admin_user="$WP_ADMIN_USR" --admin_password="$WP_ADMIN_PWD" --admin_email="$WP_EMAIL" --allow-root || { log "Failed to install WordPress"; exit 1; }

    # Create additional user
    log "Creating additional user..."
    wp user create "$WP_USR" "$WP_EMAIL" --role=author --user_pass="$WP_PWD" --allow-root || { log "Failed to create additional user"; exit 1; }

    log "WordPress setup completed successfully"
}

main() {
    log "Starting WordPress setup script"

    # Check for required environment variables
    required_vars="MYSQL_DATABASE MYSQL_USER MYSQL_PASSWORD DOMAIN_NAME WP_ADMIN_USR WP_ADMIN_PWD WP_EMAIL WP_USR WP_EMAIL WP_PWD"
    for var in $required_vars; do
        if [ -z "${!var}" ]; then
            log "Error: Required environment variable $var is not set."
            exit 1
        fi
    done

    
    # Ensure /run/php directory exists
    mkdir -p /run/php

    # Wait for database to be ready
    wait_for_db || exit 1

    # Setup WordPress
    setup_wordpress

    # Start PHP-FPM
    log "Starting PHP-FPM..."
    exec /usr/sbin/php-fpm7.4 -F
}

main