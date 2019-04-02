FROM php:7.3.3-apache

RUN mkdir -p /app
WORKDIR /app

# Copy project
RUN usermod -u 1000 www-data && groupmod -g 1000 www-data
COPY --chown=www-data:www-data . /app

# Install Debian packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    apt-utils \
    git \
    openssh-client \
    zip \
    unzip

# Requirements Laravel5.8: Install PHP modules, the rest is installed by default
RUN docker-php-ext-install pdo_mysql bcmath

# Enable Apache2 conf
COPY docker/php/app.ini /usr/local/etc/php/conf.d
COPY docker/apache/app.conf /etc/apache2/sites-available/app.conf
RUN a2dissite 000-default.conf && a2ensite app.conf && a2enmod rewrite && service apache2 restart

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer
RUN composer install

# Cleaning Temp files
RUN . ~/.bashrc
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# File permissions for Laravel storage and bootstrap
RUN chown -R www-data:www-data \
    /app/storage \
    /app/bootstrap/cache
RUN chmod -R 755 \
    /app/storage \
    /app/bootstrap/cache

WORKDIR /app