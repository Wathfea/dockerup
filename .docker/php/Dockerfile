# Set master image
ARG PROJECT_PHP_VERSION
FROM php:${PROJECT_PHP_VERSION}-fpm-alpine

LABEL maintainer="Perlusz Dávid (perlusz.david@pentacom.hu)"

# Set working directory
ARG PROJECT_PATH
WORKDIR /var/www/html/${PROJECT_PATH}

RUN echo "UTC" > /etc/timezone

# Installing bash
RUN apk add bash
RUN sed -i 's/bin\/ash/bin\/bash/g' /etc/passwd

# Install Additional dependencies
RUN apk update && apk add --no-cache \
    build-base shadow supervisor \
    php7-common \
    php7-pdo \
    php7-pdo_mysql \
    php7-mysqli \
    php7-mcrypt \
    php7-mbstring \
    php7-xml \
    php7-openssl \
    php7-json \
    php7-phar \
    php7-zip \
    php7-gd \
    php7-dom \
    php7-session \
    php7-zlib \
    nodejs \
    nodejs-npm \
    zsh \
    yarn \
    imagemagick-dev \
    autoconf \
    make \
    wkhtmltopdf

# Add and Enable PHP-PDO Extenstions
RUN docker-php-ext-install pdo pdo_mysql
RUN docker-php-ext-enable pdo_mysql
RUN docker-php-ext-install pcntl

RUN pecl channel-update pecl.php.net \
    && pecl install imagick \
    && docker-php-ext-enable imagick

###########################################################################
# Composer
###########################################################################
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Remove Cache
RUN rm -rf /var/cache/apk/*

COPY supervisord.conf /etc/supervisord.conf
COPY supervisor.d /etc/supervisor.d
COPY .zshconfig /.zshrc

# Use the default production configuration ($PHP_INI_DIR variable already set by the default image)
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Add UID '1000' to www-data
RUN usermod -u 1000 www-data

# Copy existing application directory
COPY . .

# Install Composer packages
ARG INSTALL_BASE_PACKAGES=false
RUN if [ ${INSTALL_BASE_PACKAGES} = true ]; then \
    composer require nunomaduro/larastan && \
    composer require barryvdh/laravel-debugbar && \
    composer require spatie/laravel-permission && \
    composer require spatie/laravel-activitylog && \
    composer require predis/predis && \
    composer require laravel/horizon && \
    composer require friendsofphp/php-cs-fixer && \
    composer require arcanedev/log-viewer && \
    composer require diglactic/laravel-breadcrumbs \
;fi

RUN chown -R www-data:www-data .

ENV ENABLE_CRONTAB 1
ENV ENABLE_HORIZON 1
ENV PROJECT_PATH ${PROJECT_PATH}
# ENV ENABLE_WORKER 1 # no need  to enable worker here as Horizon will create and manage workers itself
# ENV CURRENT_USER www-data

ENTRYPOINT ["sh", "/var/www/html/.docker/docker-entrypoint.sh"]

CMD supervisord -n -c /etc/supervisord.conf
