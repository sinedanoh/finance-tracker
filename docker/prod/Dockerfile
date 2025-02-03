# Build stage
FROM composer:2.6.5 AS composer
FROM php:8.2-fpm-alpine AS builder

COPY --from=composer /usr/bin/composer /usr/bin/composer

# Install build dependencies
RUN apk add --no-cache \
    postgresql-dev \
    git \
    unzip

# Install PHP extensions
RUN docker-php-ext-install \
    pdo \
    pdo_pgsql \
    opcache

# Copy application
COPY composer.* ./
RUN composer install --no-dev --no-scripts --no-autoloader

COPY . .
RUN composer dump-autoload --optimize

# Production stage
FROM php:8.2-fpm-alpine

# Install production dependencies
RUN apk add --no-cache \
    postgresql-libs

# Install PHP extensions
RUN docker-php-ext-install \
    pdo \
    pdo_pgsql \
    opcache

# Copy PHP configuration
COPY docker/prod/php/conf.d/opcache.ini /usr/local/etc/php/conf.d/
COPY docker/prod/php/conf.d/php.prod.ini /usr/local/etc/php/conf.d/

# Copy application from builder
COPY --from=builder /var/www/html/vendor /var/www/html/vendor
COPY . /var/www/html

# Create symfony user
RUN adduser -u 1000 -D symfony && \
    chown -R symfony:symfony /var/www/html

USER symfony

WORKDIR /var/www/html
