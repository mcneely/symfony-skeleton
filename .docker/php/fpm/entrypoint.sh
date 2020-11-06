#!/usr/bin/env bash
APP_ENV=${APP_ENV:-prod}

if [[ ! "dev" == "$APP_ENV" ]]; then
    if [[ -e /usr/local/etc/php/conf.d/xdebug.ini ]]; then
        rm -f /usr/local/etc/php/conf.d/xdebug.ini
    fi
else
    ln -s /xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
fi

php-fpm