FROM php:latest

RUN mkdir /db_admin
WORKDIR /db_admin

RUN apt-get update && apt-get install -y libpq-dev
RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql && \
docker-php-ext-install pdo pdo_pgsql pgsql

ADD . /db_admin
