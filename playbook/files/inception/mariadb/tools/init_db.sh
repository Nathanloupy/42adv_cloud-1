#!/bin/sh

echo "Executing MariaDB launch script"

mkdir -p /var/log/mariadb/
mkdir -p /run/mysqld/
chown mysql:mysql /run/mysqld/

touch /var/log/mariadb/mariadb.log
chown mysql:mysql /var/log/mariadb/
chown mysql:mysql /var/log/mariadb/mariadb.log

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Executing MariaDB setup"
    LOG_FILE='/var/log/mariadb/mariadb.log'
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
    mysqld --skip-name-resolve --skip-networking=0 2>&1 > $LOG_FILE &
    PIDFORK=$!

    until tail $LOG_FILE | grep -q "Version:"; do
		sleep 0.2
	done

    MYSQL_DATABASE=${MYSQL_DATABASE:-""}
    MYSQL_USER=${MYSQL_USER:-""}
    MYSQL_PASSWORD=${MYSQL_PASSWORD:-""}
    MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-""}

    mysql -u root -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
    mysql -u root -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    mysql -u root -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"
    mysql -u root -e "DROP USER ''@'localhost';"
    mysql -u root -e "DROP USER ''@'$(hostname)';"
    mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
    mysql -u root -p$MYSQL_ROOT_PASSWORD -e "FLUSH PRIVILEGES;"

    kill -s TERM "$PIDFORK"
    wait "$PIDFORK"
    rm -f $LOG_FILE
fi

exec mysqld --user=mysql