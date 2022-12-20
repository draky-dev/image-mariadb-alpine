FROM draky-dev/tools:0.0.3 AS draky-tools

FROM alpine:3.16.2

ENV MARIADB_VERSION "10.6.10-r0"

ENV DB_DATA_PATH "/var/lib/mysql"
ENV MYSQL_USER "mysql"

RUN apk add --update --no-cache \
       mariadb=${MARIADB_VERSION} \
       mariadb-client=${MARIADB_VERSION} \
       # pwgen \
    && mkdir -p /run/mysqld \
    && chown -R ${MYSQL_USER}:${MYSQL_USER} /run/mysqld \
    && mysql_install_db --user=${MYSQL_USER} --datadir=${DB_DATA_PATH} \
    && rm -f /var/cache/apk/*

COPY templates/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf

RUN apk add --update --no-cache \
       bash \
       # Provides 'envsubst' app, useful for templating.
       gettext \
       # For easier executing of commands as another user.
       sudo \
    && rm -f /var/cache/apk/*

COPY --from=draky-tools / /
COPY init.d/ /draky-tools.core.init.d/

VOLUME ["${DB_DATA_PATH}", "/draky-tools.init.d", "/draky-tools.bin", "/draky-tools.resources"]

ENTRYPOINT ["/draky-tools.entrypoint.sh"]

EXPOSE 3306

CMD mysqld_safe --user=${MYSQL_USER}
