FROM php:8.2-fpm

ENV http_proxy=http://10.0.249.120:3128
ENV https_proxy=http://10.0.249.120:3128
ENV no_proxy=localhost,127.0.0.1,10.0.0.0/8,172.16.0.0/12,.birosagiad.hu

RUN echo 'Acquire::http::Proxy "http://10.0.249.120:3128";' > /etc/apt/apt.conf.d/01proxy

# # Set proxy environment variables (if needed)
# ARG HTTP_PROXY
# ARG HTTPS_PROXY
# ARG NO_PROXY

# ENV http_proxy=${HTTP_PROXY}
# ENV https_proxy=${HTTPS_PROXY}
# ENV no_proxy=${NO_PROXY}

# # Set APT proxy
# RUN echo 'Acquire::http::Proxy "${http_proxy}";' > /etc/apt/apt.conf.d/01proxy


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
    libpq-dev \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure ldap --with-ldap \
    && docker-php-ext-install ldap \
    && docker-php-ext-install pdo pdo_pgsql

# Optionally install other extensions
#RUN docker-php-ext-install pdo pdo_mysql

# Copy custom PHP config (this is optional; you already mount it)
# COPY ./etc/php/php.ini /usr/local/etc/php/php.ini
