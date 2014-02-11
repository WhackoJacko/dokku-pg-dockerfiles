#!/bin/bash

if [[ ! -f /opt/postgresql/initialized ]]; then
    mkdir -p /opt/postgresql
    cp -a /var/lib/postgresql/* /opt/postgresql/
    chown -R postgres:postgres /opt/postgresql
    su postgres sh -c "/usr/lib/postgresql/9.1/bin/postgres --single  -D  /var/lib/postgresql/9.1/main  -c config_file=/etc/postgresql/9.1/main/postgresql.conf" <<< "UPDATE pg_database SET datistemplate = FALSE WHERE datname = 'template1';"
    su postgres sh -c "/usr/lib/postgresql/9.1/bin/postgres --single  -D  /var/lib/postgresql/9.1/main  -c config_file=/etc/postgresql/9.1/main/postgresql.conf" <<< "DROP DATABASE template1;"
    su postgres sh -c "/usr/lib/postgresql/9.1/bin/postgres --single  -D  /var/lib/postgresql/9.1/main  -c config_file=/etc/postgresql/9.1/main/postgresql.conf" <<< "CREATE DATABASE template1 WITH TEMPLATE = template0 ENCODING = 'UNICODE';"
    su postgres sh -c "/usr/lib/postgresql/9.1/bin/postgres --single  -D  /var/lib/postgresql/9.1/main  -c config_file=/etc/postgresql/9.1/main/postgresql.conf" <<< "UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template1';"
    su postgres sh -c "/usr/lib/postgresql/9.1/bin/postgres --single  -D  /var/lib/postgresql/9.1/main  -c config_file=/etc/postgresql/9.1/main/postgresql.conf" <<< "\c template1"
    su postgres sh -c "/usr/lib/postgresql/9.1/bin/postgres --single  -D  /var/lib/postgresql/9.1/main  -c config_file=/etc/postgresql/9.1/main/postgresql.conf" <<< "VACUUM FREEZE;"
    su postgres sh -c "/usr/lib/postgresql/9.1/bin/postgres --single  -D  /var/lib/postgresql/9.1/main  -c config_file=/etc/postgresql/9.1/main/postgresql.conf" <<< "UPDATE pg_database SET datallowconn = FALSE WHERE datname = 'template1';"
    su postgres sh -c "/usr/lib/postgresql/9.1/bin/postgres --single  -D  /var/lib/postgresql/9.1/main  -c config_file=/etc/postgresql/9.1/main/postgresql.conf" <<< "CREATE USER root WITH SUPERUSER PASSWORD '$1';"
    su postgres sh -c "/usr/lib/postgresql/9.1/bin/postgres --single  -D  /var/lib/postgresql/9.1/main  -c config_file=/etc/postgresql/9.1/main/postgresql.conf" <<< "CREATE DATABASE db WITH OWNER root ENCODING 'UTF8' TEMPLATE template1; ;"
    touch /opt/postgresql/initialized
fi
su postgres sh -c "/usr/lib/postgresql/9.1/bin/postgres           -D  /var/lib/postgresql/9.1/main  -c config_file=/etc/postgresql/9.1/main/postgresql.conf  -c listen_addresses=*"
