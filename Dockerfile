#
# Goal is to mimic a shared hosting environment. The Laravel should be within a subdirectory.
# In this file it will go to `/var/www/html/my-laravel` directory.
#
FROM php:8.1-apache
LABEL maintainer="Györk Bakonyi <gyork@bakonyi.info>"

ENV DOCKER_PATH .

RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    unzip \
    git \
    nano \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd pdo pdo_mysql

RUN a2enmod rewrite

# Copy Laravel application from /src directory
RUN mkdir /var/www/html/my-laravel
COPY ${DOCKER_PATH}/src /var/www/html/my-laravel
COPY ${DOCKER_PATH}/config/.htaccess /var/www/html
COPY ${DOCKER_PATH}/config/info.php /var/www/html


# owerwrite the default env file
COPY ${DOCKER_PATH}/config/.env /var/www/html/my-laravel/.env

# Set working directory
WORKDIR /var/www/html/my-laravel

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Laravel dependencies
RUN composer install --no-interaction --optimize-autoloader

# Set working directory again.
WORKDIR /var/www/html

# Change ownership of our applications
# RUN chown -R www-data:www-data /var/www/html

# Set the right permissions for Laravel
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/my-laravel/storage \
    && chmod -R 755 /var/www/html/my-laravel/bootstrap/cache


# Expose port 80 for Apache
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2-foreground"]
