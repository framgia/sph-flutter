FROM php:8.2-rc-fpm

ENV COMPOSER_ALLOW_SUPERUSER=1
# Set working directory
WORKDIR /var/www

# Add docker php ext repo
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

# Install php extensions
RUN chmod +x /usr/local/bin/install-php-extensions && sync && \
    install-php-extensions mbstring zip exif pcntl gd memcached pgsql pdo pdo_pgsql

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    libzip-dev \
    unzip \
    git \
    libonig-dev \
    curl \
    libmemcached-dev \
    zlib1g-dev \
    libssl-dev

# Install supervisor
RUN apt-get install -y supervisor

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Copy code to /var/www
COPY --chown=www:www-data . /var/www

# add root to www group
RUN chmod -R ug+w /var/www/storage

# Copy nginx/php/supervisor configs
# RUN cp docker/supervisor.conf /etc/supervisord.conf
# RUN cp docker/php.ini /usr/local/etc/php/conf.d/app.ini
# RUN cp docker/nginx.conf /etc/nginx/sites-enabled/default

# PHP Error Log Files
# RUN mkdir /var/log/php
# RUN touch /var/log/php/errors.log && chmod 777 /var/log/php/errors.log

# Deployment steps
RUN composer install --optimize-autoloader --no-dev

EXPOSE 8000

# CMD php artisan serve --port=8000 --host=0.0.0.0

USER $user