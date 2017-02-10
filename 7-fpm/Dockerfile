FROM php:7-fpm

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
RUN apt-get update && apt-get install -y --no-install-recommends \
        # GD requirements
        libjpeg62-turbo-dev libpng12-dev libfreetype6-dev \
        # iconv requirements
        libmcrypt-dev \
        # curl requirements
        libcurl3-dev \
        # intl requirements
        libicu-dev \
        # dom requirements
        libxml2-dev \
        # bz2 requirements
        libbz2-dev \
        # phar requirements
        libssl-dev \
        # tidy requirements
        libtidy-dev \
        # xsl requirements
        libxslt1-dev \
        # zip requirements
        zlib1g-dev \

    && docker-php-ext-configure \
        gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \

    && docker-php-ext-install -j$(nproc) \
        iconv mcrypt gd curl pdo pdo_mysql fileinfo intl json mbstring \
        dom bz2 mysqli pcntl phar posix soap tidy tokenizer xsl zip bcmath \
        ctype exif sockets opcache simplexml xml \

    && pecl install \
        redis xdebug apcu \

    && docker-php-ext-enable \
        redis apcu xdebug \
    
    # Clean apt cache
    && rm -rf /var/lib/apt/lists/* \
    && apt-get purge -y --auto-remove

# Install node
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && apt-get install -y nodejs \
    # Clean apt cache
    && rm -rf /var/lib/apt/lists/* \
    && apt-get purge -y --auto-remove

# Set workdir as project root
WORKDIR /var/www/symfony

# Set user for permissions
RUN usermod -u 1000 www-data

# Add php custom config
COPY config/php.ini /usr/local/etc/php/

# Add custom fpm config
RUN rm -f /usr/local/etc/php-fpm.d/www.conf
COPY config/www.conf /usr/local/etc/php-fpm.d/www.conf

# Add custom entry point
COPY docker-php-entrypoint /usr/local/bin/
