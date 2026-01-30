#!/bin/bash
set -e

echo "Starting WordPress with Apache and auto-configuration..."

# Run the original WordPress entrypoint in the background
# This sets up wp-config.php and prepares WordPress files
docker-entrypoint.sh apache2-foreground &
APACHE_PID=$!

# Wait for WordPress to be ready (wp-config.php created by docker-entrypoint.sh)
echo "Waiting for WordPress files to be ready..."
until [ -f /var/www/html/wp-config.php ]; do
    sleep 2
done

echo "wp-config.php found, waiting for Apache to start..."
sleep 5

# Check if WordPress is already installed
if ! wp core is-installed --path=/var/www/html --allow-root 2>/dev/null; then
    echo "WordPress not installed. Running auto-installation..."

    # Only install if we can connect to the database
    echo "Database connection successful! Installing WordPress..."

    # Install WordPress core
    wp core install --path=/var/www/html --allow-root \
        --url="${WORDPRESS_URL:-https://localhost}" \
        --title="${WORDPRESS_TITLE:-My WordPress Site}" \
        --admin_user="${WORDPRESS_ADMIN_USER:-admin}" \
        --admin_password="${WORDPRESS_ADMIN_PWD:-admin123}" \
        --admin_email="${WORDPRESS_ADMIN_EMAIL:-admin@example.com}" \
        --skip-email

    echo "WordPress core installed successfully!"
else
    echo "WordPress is already installed. Skipping installation."
fi

# Wait for Apache process
wait $APACHE_PID
