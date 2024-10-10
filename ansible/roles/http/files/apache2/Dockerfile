FROM php:8.3-apache

ARG UID=48
ARG GID=48

RUN groupadd -g $GID apache && \
    useradd -m -s /bin/bash -u $UID -g $GID apache

ENV APACHE_DOCUMENT_ROOT /home/www/new/https
ENV APACHE_RUN_USER apache
ENV APACHE_RUN_GROUP apache

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

RUN a2enmod authnz_ldap
RUN a2enmod authz_groupfile
RUN a2enmod userdir

COPY userdir2.conf /etc/apache2/mods-enabled/userdir.conf
