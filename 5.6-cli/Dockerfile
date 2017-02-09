FROM php:5.6-cli

MAINTAINER Thomas Glachant <thomas@glachant.fr>

# Xdebug default config
ENV PHP_XDEBUG_ENABLED=0
ENV PHP_XDEBUG_HOST=0.0.0.0
ENV PHP_XDEBUG_IDEKEY=PHPSTORM
ENV PHP_XDEBUG_PORT=9000
ENV PHP_XDEBUG_MAX_NESTING_LEVEL=1024
# PHP IDE CONFIG
ENV PHP_IDE_CONFIG="serverName=docker"

# Instal php requirements
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        curl libcurl3 libcurl3-dev php5-curl php5-mcrypt \
        libicu-dev \
        libxml2-dev \
        libbz2-dev re2c libpng++-dev \
        libpng3 libjpeg-dev libvpx-dev zlib1g-dev libgd-dev libssl-dev \
        libtidy-dev libxslt1-dev libmagic-dev libexif-dev file libssh2-1-dev git wget \
        libpcre3-dev \
        yui-compressor libjpeg-progs optipng \
        git \
        unzip \
    && docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) curl \
    && docker-php-ext-install -j$(nproc) pdo pdo_mysql fileinfo iconv intl json mbstring \
    && docker-php-ext-install -j$(nproc) dom bz2 mysqli pcntl phar posix \
    && docker-php-ext-install -j$(nproc) simplexml soap tidy tokenizer xml xmlreader xmlrpc \
    && docker-php-ext-install -j$(nproc) xmlwriter xsl zip bcmath calendar ctype \
    && docker-php-ext-install -j$(nproc) exif \
    && docker-php-ext-install -j$(nproc) fileinfo \
    && docker-php-ext-install -j$(nproc) sockets \
    && docker-php-ext-install -j$(nproc) opcache \
    && pecl install redis-2.2.8 xdebug apcu-4.0.11 \
    && docker-php-ext-enable redis \
    && docker-php-ext-enable apcu \
    && docker-php-ext-enable xdebug \
    && docker-php-ext-enable apcu\
    # Install node requirements
    && curl -sL https://deb.nodesource.com/setup_6.x | bash - && apt-get install -y nodejs \
    # Clean apt cache
    && rm -rf /var/lib/apt/lists/* \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set timezone
RUN rm /etc/localtime ; ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime

# Set user for permissions
RUN usermod -u 1000 www-data

# Set workdir as project root
WORKDIR /var/www/symfony

# Add php custom config
COPY config/php.ini /usr/local/etc/php/

# Add custom entry point
COPY entrypoint.sh /bin/entrypoint.sh

# Launch entrypoint
CMD exec /bin/bash /bin/entrypoint.sh
