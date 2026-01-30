FROM alpine:3.19

RUN apk update \
    && apk add mariadb mariadb-client

COPY conf/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf

COPY tools/init_db.sh /tmp/init_db.sh

RUN chmod +x /tmp/init_db.sh

ENTRYPOINT [ "/tmp/init_db.sh" ]
