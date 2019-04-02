FROM php:7.3.3-apache

RUN mkdir -p /app
WORKDIR /app

# Copy project
COPY --chown=www-data:www-data . /app

# Install Debian packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    openssh-client \
    zip \
    unzip

# Enable Apache2 conf
COPY docker/php/app.ini /usr/local/etc/php/conf.d
COPY docker/apache/app.conf /etc/apache2/sites-available/app.conf
RUN a2dissite 000-default.conf && a2ensite app.conf && a2enmod rewrite && service apache2 restart

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer
RUN composer install

# Final Touch
RUN . ~/.bashrc
RUN apt clean && \
        rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN php artisan cache:clear
RUN php artisan config:clear

RUN chown -R www-data:www-data \
        /app/storage \
        /app/bootstrap/cache

WORKDIR /app