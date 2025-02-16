FROM php:8.3-fpm-alpine

# System dependencies including fish
RUN apk add --no-cache \
    fish \
    linux-headers \
    postgresql-dev \
    postgresql-libs \
    git \
    curl \
    zip \
    unzip \
    libzip-dev \
    autoconf \
    dpkg-dev dpkg \
    file \
    g++ \
    gcc \
    libc-dev \
    make \
    pkgconf \
    re2c

# PHP extensions
RUN docker-php-ext-install \
    pdo \
    pdo_pgsql

# PECL extensions
RUN pecl install apcu && \
    pecl install xdebug && \
    docker-php-ext-enable \
    apcu \
    xdebug

# Composer
COPY --from=composer:2.6.5 /usr/bin/composer /usr/bin/composer

WORKDIR /app

# Symfony user with fish as default shell
RUN adduser -u 1000 -D symfony && \
    chown symfony:symfony /app && \
    sed -i 's/\/bin\/ash/\/usr\/bin\/fish/g' /etc/passwd

# Fish configuration for symfony user
USER symfony
RUN mkdir -p ~/.config/fish && \
    echo 'set -gx PATH $PATH /usr/local/bin' > ~/.config/fish/config.fish

# Set fish as default shell
SHELL ["/usr/bin/fish", "-c"]

# Copy php.ini and xdebug.ini configuration
COPY docker/dev/php/conf.d/php.ini /usr/local/etc/php/conf.d/php.ini
COPY docker/dev/php/conf.d/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

CMD ["php-fpm"]
