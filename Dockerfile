FROM mirror.gcr.io/library/php:8.2-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libicu-dev \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd mysqli zip intl pdo_mysql

# Enable Apache rewrite module
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Copy application files
COPY --chown=www-data:www-data . /var/www/html/

# HumHub requires specific directory structures and permissions for its protected folder
# We create the directories and set permissions explicitly
RUN mkdir -p /var/www/html/protected/runtime /var/www/html/protected/config /var/www/html/protected/uploads \
    && chown -R www-data:www-data /var/www/html/protected \
    && chmod -R 775 /var/www/html/protected/runtime /var/www/html/protected/config /var/www/html/protected/uploads

# Configure Apache DocumentRoot to point to the web folder if it exists, otherwise root
# HumHub typically serves from the root or a /web subdirectory depending on version/install
RUN sed -ri -e 's!/var/www/html!/var/www/html!g' /etc/apache2/sites-available/000-default.conf
RUN sed -ri -e 's!/var/www/html!/var/www/html!g' /etc/apache2/apache2.conf

ENV APACHE_DOCUMENT_ROOT /var/www/html

EXPOSE 80
ENV PORT=80
ENV HOSTNAME=0.0.0.0