FROM webdevops/php-apache-dev:7.2

MAINTAINER Helmut Hoffer von Ankershoffen <helmuthva@googlemail.ccom>

USER root

# Install some base packages
RUN apt-get update && \
    apt-get install -y apt-utils software-properties-common procps less nano vim telnet iputils-ping sudo mariadb-client && \
    apt-get clean

# Install missing apcu-bc and mcrypt extension for PHP
RUN apt-get update && \
    apt-get install -y libmcrypt-dev && \
    apt-get clean && \
    printf "\n" | pecl install apcu_bc && \
    printf "\n" | pecl install mcrypt-1.0.2 && \
    docker-php-ext-enable mcrypt

# Switch to user application
USER application
WORKDIR /app

# Configure composer including auth and prestissimo for parallel downloads
RUN composer config -g -- disable-tls true && \
    composer config -g github-oauth.github.com 63d7a590600f031d5017323c6c6c196cf82c3d7d && \
    composer global require hirak/prestissimo

# Copy base composer definitions and install (which should not change often)
COPY --chown=application:application /composer.base.json /app/composer.json
COPY --chown=application:application /composer.base.lock /app/composer.lock
RUN COMPOSER_DISCARD_CHANGES=1 composer install --no-scripts

# Copy current composer definitions and install (which change given added extensions, theme etc.)
COPY --chown=application:application /composer.json /app/
COPY --chown=application:application /composer.lock /app/
RUN COMPOSER_DISCARD_CHANGES=1 composer install

# Dump optimized autoloader cacheable by apcu
RUN composer dump-autoload -o --apcu

# Copy container configuration
COPY /container/ /

# Copy non-vendor source code of app
COPY --chown=application:application / /app/
RUN rm -rf /app/container

EXPOSE 80/tcp

ENV PHP_DATE_TIMEZONE='Europe/Berlin' \
    PHP_DISPLAY_ERRORS=0 \
    \
    PHP_MEMORY_LIMIT='2048M' \
    PHP_MAX_EXECUTION_TIME=60 \
    \
    PHP_POST_MAX_SIZE='50M' \
    PHP_UPLOAD_MAX_FILESIZE='50M' \
    \
    PHP_OPCACHE_MEMORY_CONSUMPTION=512 \
    PHP_OPCACHE_MAX_ACCELERATED_FILES=130987 \
    PHP_OPCACHE_VALIDATE_TIMESTAMPS=0 \
    PHP_OPCACHE_REVALIDATE_FREQ=0 \
    PHP_OPCACHE_INTERNED_STRINGS_BUFFER=32 \
    \
    PHP_DEBUGGER='none' \
    PHP_DISMOD='ioncube,ldap,mongodb,sqlite3,pdo_sqlite' \
    \
    FPM_PROCESS_MAX=0 \
    FPM_PM_MAX_CHILDREN=29 \
    FPM_PM_START_SERVERS=29 \
    FPM_PM_MIN_SPARE_SERVERS=29 \
    FPM_PM_MAX_SPARE_SERVERS=29 \
    FPM_MAX_REQUESTS=1000 \
    FPM_REQUEST_TERMINATE_TIMEOUT='120s' \
    \
    WEB_DOCUMENT_ROOT='/app/pub' \
    \
    APP_STAGE=production \
    APP_MODE=prod \
    APP_UNATTENDED_UPGRADE=true \
    APP_INSTALL_SAMPLE_DATA=true \
    APP_CRON=true \
    \
    APP_RABBITMQ_HOST='rabbitmq' \
    APP_REDIS_HOST='redis' \
    APP_DB_HOST='db' \
    APP_ES_HOST='es'
