#!/bin/bash

brew update
#brew upgrade

BREW_PREFIX=$(brew --prefix)

brew tap caskroom/cask
brew tap homebrew/services

# Database
brew install mariadb

# PHP & Apache
# Mojave finally kills unsigned PHP modules from its own apache.
# https://github.com/Homebrew/homebrew-core/issues/32436
brew install httpd
brew install php

cp /usr/local/etc/httpd/httpd.conf /usr/local/etc/httpd/httpd.conf.orig

find /usr/local/etc/httpd -name httpd.conf -exec sed -i "s,DirectoryIndex .*,DirectoryIndex index.php index.html,g" {} \;

cat >>/usr/local/etc/httpd/httpd.conf <<EOF
Listen 80

LoadModule rewrite_module lib/httpd/modules/mod_rewrite.so
LoadModule proxy_module lib/httpd/modules/mod_proxy.so
LoadModule proxy_fcgi_module lib/httpd/modules/mod_proxy_fcgi.so

<FilesMatch \.php$>
   SetHandler application/x-httpd-php
</FilesMatch>
EOF

brew services restart httpd

find /usr/local/etc/php -name php.ini -exec sed -i "s,^;date.timezone =.*,date.timezone = 'Europe/Berlin',g" {} \;

brew services start php

git clone https://github.com/icinga/icingaweb2.git /usr/local/icinga/icingaweb2
cd /usr/local/icinga/icingaweb2


mkdir -p /usr/local/etc/httpd/conf.d
echo "Include /usr/local/etc/httpd/conf.d/*" >> /usr/local/etc/httpd/httpd.conf

./bin/icingacli setup config webserver apache --document-root /usr/local/icinga/icingaweb2/public --config /usr/local/icinga/icingaweb2/etc --enable-fpm --fpm-uri 127.0.0.1:9000 > /usr/local/etc/httpd/conf.d/icingaweb2.conf

brew services restart httpd

# debug help:
# lsof -i :9000
# /usr/local/opt/php/sbin/php-fpm -i

# final cleanup
brew cleanup
