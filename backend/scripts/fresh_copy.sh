#!/usr/bin/env bash
echo "Running composer"
composer install --no-dev --working-dir=/var/www/html

echo "Caching config..."
php artisan config:cache

echo "Caching routes..."
php artisan route:cache

echo "Running migrations..."
if [ "$1" = "--seed" ]; then
    echo "Running migrations with seed"
    php artisan migrate:fresh --seed
else
    echo "Running migrations w/o seed"
    php artisan migrate:fresh
fi

echo "Done"