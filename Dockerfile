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
