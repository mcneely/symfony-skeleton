FROM php:7.4-cli-buster

COPY php.ini /usr/local/etc/php/php.ini
COPY xdebug.ini /xdebug.ini

RUN apt-get update && \
    pecl install xdebug && \
    apt-get install -y --no-install-recommends \
    acl apt-transport-https apt-utils \
    build-essential curl debconf \
    git gnupg gnupg1 gnupg2 \
    libjpeg-dev libldb-dev libldap2-dev libonig-dev libpq-dev libpng-dev libssl-dev libxml2 libxml2-dev libxpm-dev libzip-dev libzip4 locales\
    mailutils nano openssl rsync sudo unzip wget zip zlib1g-dev && \
    apt-get autoremove && apt-get clean && rm -rf /var/lib/apt/lists/* && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen && \
    docker-php-ext-install bcmath exif gd intl ldap opcache pdo_mysql pdo_pgsql sockets zip

COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

WORKDIR /var/www

RUN curl -sSk https://getcomposer.org/installer | php -- --disable-tls && mv composer.phar /usr/local/bin/composer &&\
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - &&\
    curl -sL https://deb.nodesource.com/setup_14.x | bash - &&\
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list &&\
    apt-get update && apt-get install -y --no-install-recommends --no-install-suggests supervisor nodejs yarn

COPY supervisor.conf /etc/supervisor/conf.d/supervisor.conf
CMD ["/entrypoint.sh"]