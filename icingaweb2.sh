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

cat >>/usr/local/etc/httpd/httpd.conf <<EOF
Listen 80

LoadModule rewrite_module lib/httpd/modules/mod_rewrite.so
LoadModule php7_module /usr/local/opt/php/lib/httpd/modules/libphp7.so
<FilesMatch \.php$>
   SetHandler application/x-httpd-php
</FilesMatch>
 
<IfModule dir_module>
    DirectoryIndex index.php index.html
</IfModule>
EOF

brew services restart httpd

echo "date.timezone='Europe/Berlin'" >> /usr/local/etc/php/*/php.ini

brew services start php


# final cleanup
brew cleanup
