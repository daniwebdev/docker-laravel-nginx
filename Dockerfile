# Use the official Debian base image
FROM debian:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Update the package index and install necessary packages
RUN apt-get update && \
    apt-get install -y \
    curl \
    gnupg2 \
    ca-certificates \
    lsb-release \
    apt-transport-https

# Add the PHP repository
RUN curl -sSL https://packages.sury.org/php/README.txt | bash -x

# Install PHP 8.3-FPM
RUN apt-get update && \
    apt-get install -y \
    php8.3-fpm \
    php8.3-cli \
    php8.3-mysql \
    php8.3-pgsql \
    php8.3-zip \
    php8.3-gd \
    php8.3-grpc \
    php8.3-curl \
    php8.3-mbstring \
    php8.3-xml \
    php8.3-swoole \
    php8.3-redis

RUN apt-get install -y unzip

# Install Nginx
RUN apt-get install -y nginx

# # Install Supervisor
# RUN apt-get install supervisor -y

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Node.js (LTS version)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y nodejs

# Install bun
RUN curl -fsSL https://bun.sh/install | bash # for macOS, Linux, and WSL

# Configure Nginx
RUN rm /etc/nginx/sites-enabled/default
COPY docker-files/server.conf /etc/nginx/sites-enabled/default

# add custom php config
COPY docker-files/php.ini /etc/php/8.3/fpm/conf.d/99-docker.ini

# clean cache apt
RUN apt-get clean

# Expose the necessary ports
EXPOSE 80 443

# Copy start script
COPY docker-files/start.sh /start.sh
RUN chmod +x /start.sh

# Set entrypoint
ENTRYPOINT ["/start.sh"]
