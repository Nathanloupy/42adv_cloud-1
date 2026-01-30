FROM alpine:3.19

RUN apk update \
    && apk add wget \
    && apk add curl \
    && apk add php82 php82-fpm php82-phar php82-mysqli php82-iconv

RUN mkdir -p /var/www/wordpress

COPY conf/php-fpm.conf /etc/php82/php-fpm.conf
COPY conf/www.conf /etc/php82/php-fpm.d/www.conf

COPY ./tools/config_wordpress.sh /config_wordpress.sh

RUN chmod +x /config_wordpress.sh

CMD [ "/config_wordpress.sh" ]