#!/bin/bash

# Start PHP-FPM
service php8.3-fpm start

# Start Nginx
nginx -g 'daemon off;' &

# Tail access and error logs
tail -f /var/log/nginx/access.log /var/log/nginx/error.log
