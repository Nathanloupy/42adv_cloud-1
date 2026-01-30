#!/bin/sh

echo "Executing Wordpress launch script"
set -e

# create directory to use in nginx container later and also to setup the wordpress conf
cd /var/www/wordpress

if [ ! -f /usr/local/bin/wp ]; then
    echo "Installing Wordpress cli"
    wget -O wp-cli.phar https://github.com/wp-cli/wp-cli/releases/download/v2.12.0/wp-cli-2.12.0.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

if [ ! -f wp-config.php ]; then
    echo "Executing Wordpress setup"
    php -d memory_limit=512M /usr/local/bin/wp core download
    wp config create --dbname=${MYSQL_DATABASE} --dbuser=${MYSQL_USER} --dbpass=${MYSQL_PASSWORD} --dbhost=mariadb:3306 --dbprefix=wp_
    wp core install --url=https://nlederge.42.fr/ --title="${WP_TITLE}" --admin_user=${WP_ADMIN_USER} --admin_password=${WP_ADMIN_PWD} --admin_email=${WP_ADMIN_EMAIL} --skip-email
    wp user create ${WP_USER} ${WP_USER_EMAIL} --user_pass=${WP_USER_PASSD} --role=author --porcelain
    mkdir -p /run/php
fi

exec php-fpm82 -F
