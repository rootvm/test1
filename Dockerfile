FROM php:7.1-fpm-alpine
RUN apk add --no-cache libmcrypt libbz2 libpng libxslt gettext openssl geoip libmemcached cyrus-sasl freetype libjpeg-turbo python && \
	apk add rabbitmq-c --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/main
RUN apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing gnu-libiconv
