FROM php:8.2-fpm

# Set proxy environment variables (if needed)
ARG HTTP_PROXY
ARG HTTPS_PROXY
ARG NO_PROXY

ENV http_proxy=${HTTP_PROXY}
ENV https_proxy=${HTTPS_PROXY}
ENV no_proxy=${NO_PROXY}

# Install system utilities
RUN apt-get update && apt-get install -y \
    procps \
    iproute2 \
    net-tools \
    # ...other packages...
    && rm -rf /var/lib/apt/lists/*

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    libldap2-dev \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure ldap --with-ldap \
    && docker-php-ext-install ldap\
    && docker-php-ext-install pdo pdo_mysql mysqli

# Optionally install other extensions
#RUN docker-php-ext-install pdo pdo_mysql

# Copy custom PHP config (this is optional; you already mount it)
# COPY ./etc/php/php.ini /usr/local/etc/php/php.ini
