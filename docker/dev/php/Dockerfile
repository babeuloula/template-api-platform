FROM php:7.4-fpm

RUN \
    apt-get update \
    && apt-get install -y --fix-missing \
        apt-utils \
        gnupg \
        nano \
        unzip \
        git \
        gcc \
        g++ \
        make \
        bash-completion \
        wget \
    && echo "deb http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list \
    && echo "deb-src http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list \
    && curl -sS --insecure https://www.dotdeb.org/dotdeb.gpg | apt-key add - \
    && apt-get update \
    && apt-get install -y \
        zlib1g-dev \
        libzip-dev \
        libpng-dev \
        libfreetype6-dev \
        libjpeg-dev \
        libpng-dev \
        libxml2-dev \
        libxslt-dev \
        libmagickwand-dev \
        libonig-dev \
    && pecl install -o -f xdebug imagick \
    && docker-php-ext-configure intl \
    && docker-php-ext-install zip pdo_mysql bcmath intl json mbstring dom xml exif \
    && docker-php-ext-enable xdebug imagick \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && truncate -s 0 /var/log/*log

# Setting up PHP's timezone
ARG TZ
RUN echo "date.timezone = ${TZ}" > ${PHP_INI_DIR}/conf.d/timezone.ini

# Setting up xDebug
ARG XDEBUG_REMOTE_HOST
ARG XDEBUG_REMOTE_PORT
RUN set -xe; \
    mkdir -p /xdebug; \
    chown -R www-data:www-data /xdebug; \
    chmod -R ugo+rw /xdebug; \
    echo "xdebug.remote_enable=On" >> ${PHP_INI_DIR}/conf.d/docker-php-ext-xdebug.ini; \
    echo "xdebug.remote_autostart=On" >> ${PHP_INI_DIR}/conf.d/docker-php-ext-xdebug.ini; \
    echo "xdebug.remote_connect_back=On" >> ${PHP_INI_DIR}/conf.d/docker-php-ext-xdebug.ini; \
    echo "xdebug.remote_host="${XDEBUG_REMOTE_HOST} >> ${PHP_INI_DIR}/conf.d/docker-php-ext-xdebug.ini; \
    echo "xdebug.remote_port="${XDEBUG_REMOTE_PORT} >> ${PHP_INI_DIR}/conf.d/docker-php-ext-xdebug.ini; \
    echo "xdebug.idekey=docker-server" >> ${PHP_INI_DIR}/conf.d/docker-php-ext-xdebug.ini;

# Install composer
RUN \
    curl -sl https://getcomposer.org/composer-stable.phar -o /usr/local/bin/composer; \
    chmod +x /usr/local/bin/composer;

# Create user
ARG UID
RUN \
    useradd -ms /bin/bash --uid ${UID} docker \
    && usermod -a -G www-data docker \
    && mkdir -p /home/docker/.npm-global \
    && wget -O /home/docker/.bashrc https://gist.githubusercontent.com/babeuloula/3911e3192bdade918c26a43885f31a0a/raw/d37620f6e28606a0db0642687b57afc3acb45f48/.bashrc \
    && chown -R docker:docker /home/docker \
    && chown -R docker /var/www/html
USER docker

# Setting up user
RUN \
    composer global require hirak/prestissimo; \
    echo "set linenumbers" > /home/docker/.nanorc

WORKDIR /var/www/html
