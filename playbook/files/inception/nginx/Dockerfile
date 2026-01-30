FROM alpine:3.19

RUN apk update \
    && apk add nginx curl

RUN mkdir -p /etc/nginx/ssl

RUN apk add openssl \
    && openssl req -x509 -noenc -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt -subj "/C=FR/ST=GrandEst/L=Mulhouse/O=42Mulhouse/CN=nlederge"

RUN mkdir -p /var/run/nginx

COPY conf/nginx.conf /etc/nginx/nginx.conf

CMD [ "nginx", "-g", "daemon off;" ]