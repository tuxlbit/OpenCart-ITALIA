# Versione di PHP dell'immagine: si cambia da docker/.env.docker
ARG PHP_VERSION=8.4

FROM php:${PHP_VERSION}-fpm

# Fuso orario
ENV TZ=Europe/Rome
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Pacchetti di sistema
RUN apt-get update && apt-get install -y --no-install-recommends \
        supervisor cron tzdata default-mysql-client \
    && rm -rf /var/lib/apt/lists/*

# Estensioni PHP richieste da OpenCart
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/
RUN install-php-extensions \
    apcu \
    gd \
    intl \
    memcached \
    mysqli \
    opcache \
    pdo_mysql \
    redis \
    zip

# Utente dell'applicazione
ARG PHP_UNAME=www-data
ARG PHP_UID=33
ENV PHP_UNAME=${PHP_UNAME}
ENV PHP_UID=${PHP_UID}

RUN if ! id -u "$PHP_UNAME" >/dev/null 2>&1; then \
        useradd -m -G www-data,root -u "$PHP_UID" -d "/home/$PHP_UNAME" "$PHP_UNAME"; \
    fi && \
    chown -R "$PHP_UNAME":www-data /var/www && \
    chmod -R g+w /var/www

ENV HOME=/home/$PHP_UNAME

# php.ini di OpenCart
COPY php.ini /usr/local/etc/php/conf.d/opencart.ini

# PHP-FPM e supervisor
COPY docker/php/supervisor/supervisord.conf /etc/supervisor/supervisord.conf
COPY docker/php/supervisor/services/ /etc/supervisor/conf.d/services/

# Avvio
COPY docker/php/docker-opencart-entrypoint /usr/local/bin/
# Se il file arriva da un clone su Windows puo' avere terminazioni CRLF: senza
# questa normalizzazione Linux non troverebbe l'interprete indicato nella prima riga.
RUN sed -i 's/\r$//' /usr/local/bin/docker-opencart-entrypoint \
    && chmod +x /usr/local/bin/docker-opencart-entrypoint \
    && find /etc/supervisor -type f -exec sed -i 's/\r$//' {} +

WORKDIR /var/www

ENTRYPOINT ["docker-opencart-entrypoint"]
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
