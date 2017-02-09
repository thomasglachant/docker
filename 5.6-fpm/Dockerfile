FROM php:5.6-fpm

MAINTAINER Thomas Glachant <thomas@glachant.fr>

#### START COMMON PHP ####

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
    && docker-php-ext-install -j$(nproc) sockets

# Specific geonaute
RUN apt-get install -y yui-compressor libjpeg-progs optipng

# Install node requirements
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs

# Install redis
RUN pecl install redis-2.2.8
RUN docker-php-ext-enable redis

# Install xdebug
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug

# Install opcache
RUN docker-php-ext-install opcache

# Install APCu
RUN pecl install apcu-4.0.11
RUN docker-php-ext-enable apcu

# Set timezone
RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime

# Set user for permissions
RUN usermod -u 1000 www-data

# Clean apt cache
RUN rm -rf /var/lib/apt/lists/*

# Set workdir as project root
WORKDIR /var/www/symfony

#### END COMMON PHP ####

# Add php custom config
COPY config/php.ini /usr/local/etc/php/

# Add custom fpm config
RUN rm -f /usr/local/etc/php-fpm.d/www.conf
COPY config/www.conf /usr/local/etc/php-fpm.d/www.conf

# Xdebug config
ARG PHP_XDEBUG_ENABLED=0
ARG PHP_XDEBUG_HOST=0.0.0.0
ARG PHP_XDEBUG_IDEKEY=PHPSTORM
ARG PHP_XDEBUG_PORT=9000
ARG PHP_XDEBUG_MAX_NESTING_LEVEL=1024

RUN if [ $PHP_XDEBUG_ENABLED -eq 1 ] ; then sed -e "s/\;zend_extension/zend_extension/" -i /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini ; else sed -e "s/^zend_extension/\;zend_extension/" -i /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini ; fi
RUN echo 'xdebug.default_enable = '"$PHP_XDEBUG_ENABLED"'' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo 'xdebug.remote_enable = '"$PHP_XDEBUG_ENABLED"'' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo 'xdebug.remote_host = '"$PHP_XDEBUG_HOST"'' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo 'xdebug.remote_port = '"$PHP_XDEBUG_PORT"'' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo 'xdebug.remote_handler = dbgp' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo 'xdebug.remote_autostart = '"$PHP_XDEBUG_ENABLED"'' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo 'xdebug.max_nesting_level = '"$PHP_XDEBUG_MAX_NESTING_LEVEL"'' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo 'xdebug.idekey = '"$PHP_XDEBUG_IDEKEY"'' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
