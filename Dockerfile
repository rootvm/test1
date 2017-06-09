# =========================================== #
# FIRST STEP - BUILDING PHP EXTENSIONS        #
# =========================================== #

FROM php:7.1-fpm-alpine AS build-env

# PREPARE
RUN docker-php-source extract

RUN apk add --no-cache \
    coreutils \
    libmcrypt-dev \
    bzip2-dev \
    libpng-dev \
    libxslt-dev \
    gettext-dev \
    autoconf \
    g++ \
    make \
    cmake \
	geoip-dev \
	libmemcached-dev \
	cyrus-sasl-dev \
	pcre-dev \
	git \
	file \
	freetype-dev \
	libjpeg-turbo-dev \
	re2c

RUN apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/main \
	libressl-dev \
	rabbitmq-c-dev

# =================== #
# PHP CORE EXTENSIONS #
# =================== #

RUN docker-php-ext-configure \
    gd --with-freetype-dir=/usr/lib --with-jpeg-dir=/usr/lib --with-png-dir=/usr/lib

RUN docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) \
    mcrypt \
    mysqli \
    bz2 \
    opcache \
    calendar \
    gd \
    pcntl \
    xsl \
    soap \
    shmop \
    sysvmsg \
    sysvsem \
    sysvshm \
    sockets \
    pdo_mysql \
    wddx

RUN docker-php-ext-enable opcache

# =============== #
# PECL EXTENSIONS #
# =============== #

RUN pecl channel-update pecl.php.net

RUN pecl install \
	amqp \
	apcu \
	geoip-beta \
	msgpack \
	igbinary


# ================= #
# CUSTOM EXTENSIONS #
# ================= #

RUN git clone --branch php7 --single-branch --depth 1 https://github.com/php-memcached-dev/php-memcached
RUN cd php-memcached && phpize && ./configure --enable-memcached-igbinary && make -j$(getconf _NPROCESSORS_ONLN) && make install

# blitz
RUN git clone --branch php7 --single-branch --depth 1 https://github.com/alexeyrybak/blitz.git blitz
RUN cd blitz && phpize && ./configure && make -j$(getconf _NPROCESSORS_ONLN) && make install

# handlersocketi
RUN git clone --branch badoo-7.0 --single-branch --depth 1 https://github.com/tony2001/php-ext-handlersocketi.git handlersocketi
RUN cd handlersocketi && phpize && ./configure  && make -j$(getconf _NPROCESSORS_ONLN)  && make install

# pinba
RUN git clone --branch master --single-branch --depth 1 https://github.com/tony2001/pinba_extension.git pinba
RUN cd pinba && phpize && ./configure && make -j$(getconf _NPROCESSORS_ONLN) && make install

# protobuf
RUN git clone --branch php7 --single-branch --depth 1 https://github.com/serggp/php-protobuf protobuf
RUN cd protobuf && phpize && ./configure && make -j$(getconf _NPROCESSORS_ONLN) && make install

# xdebug
run git clone --single-branch --depth 1 https://github.com/xdebug/xdebug
RUN cd xdebug && phpize && ./configure --enable-xdebug && make && make INSTALL_ROOT=/build-dev install




# =========================================== #
# SECOND STEP - BUILDING PHP CONTAINER ITSELF #
# =========================================== #

FROM php:7.1-fpm-alpine
RUN apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing gnu-libiconv
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php
COPY --from=build-env /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/
COPY --from=build-env /usr/local/etc/php/conf.d/* /artifacts/usr/local/etc/php/conf.d/
RUN find /usr/local/lib/php/extensions/ -name *.so | xargs -I@ sh -c 'ln -s @ /usr/local/lib/php/extensions/`basename @`'

ADD root /
