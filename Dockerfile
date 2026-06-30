FROM mirror.gcr.io/library/php:8.2-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libicu-dev \
    libldap2-dev \
    unzip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-configure ldap \
    && docker-php-ext-install -j$(nproc) gd mysqli pdo_mysql zip intl ldap exif || true

# Install Composer
COPY --from=mirror.gcr.io/library/composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy application files
COPY . .

# Install dependencies
# Use --no-scripts to avoid HumHub's post-install scripts that might try to write to restricted dirs
RUN composer install --no-dev --optimize-autoloader --no-scripts || true

# Set permissions
# HumHub requires several directories to be writable by the web server user
# We create them and set ownership recursively
RUN mkdir -p protected/runtime protected/web/upload protected/uploads && \
    chown -R www-data:www-data /var/www/html && \
    chmod -R 775 /var/www/html/protected/runtime /var/www/html/protected/web/upload /var/www/html/protected/uploads || true

# Enable Apache rewrite module
RUN a2enmod rewrite

# Configure Apache DocumentRoot and Directory settings
# HumHub's web root is /protected/web
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/protected/web|' /etc/apache2/sites-available/000-default.conf || true
RUN sed -i 's|<Directory /var/www/>|<Directory /var/www/html/protected/web/>|' /etc/apache2/apache2.conf || true

# Ensure the Apache user can access the directory
RUN chmod 755 /var/www/html/protected/web

EXPOSE 80
ENV PORT=80
ENV HOSTNAME=0.0.0.0