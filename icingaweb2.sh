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


# Setup
./bin/icingacli setup config directory --group `id -g -n` --config /usr/local/icinga/icingaweb2/etc
echo "Use the setup token and navigate to https://localhost/icingaweb2/setup"
./bin/icingacli setup token create --config /usr/local/icinga/icingaweb2/etc
#
#mysql -e 'create database icingaweb2;'
#mysql -e "grant all on icingaweb2.* to 'icingaweb2'@'localhost' identified by 'icingaweb2';"
#mysql icingaweb2 < /usr/local/icinga/icingaweb2/etc/schema/mysql.schema.sql
#mysql icingaweb2 -e "INSERT INTO icingaweb_user (name, active, password_hash) VALUES ('icingaadmin', 1, '$2y$10$7orMB9H1qUDbOBk9Qg/OWeTgfNKfvdSRgITOzJfsOJQSzvion/x6W');"
#
#test -f /usr/local/icinga/icingaweb2/etc/config.ini || cat >/usr/local/icinga/icingaweb2/etc/config.ini <<EOF
#[global]
#show_stacktraces = "1"
#show_application_state_messages = "1"
#config_backend = "db"
#config_resource = "icingaweb_db"
#
#[logging]
#log = "php"
#level = "ERROR"
#application = "icingaweb2"
#EOF
#
#test -f /usr/local/icinga/icingaweb2/etc/authentication.ini || cat >/usr/local/icinga/icingaweb2/etc/authentication.ini <<EOF
#[icingaweb2]
#backend = "db"
#resource = "icingaweb_db"
#EOF
#
#test -f /usr/local/icinga/icingaweb2/etc/roles.ini || cat >/usr/local/icinga/icingaweb2/etc/roles.ini <<EOF
#[Administrators]
#users = "icingaadmin"
#permissions = "*"
#groups = "Administrators"
#EOF
#
#test -f /usr/local/icinga/icingaweb2/etc/resources.ini || cat >/usr/local/icinga/icingaweb2/etc/resources.ini <<EOF
#[icingaweb_db]
#type = "db"
#db = "mysql"
#host = "localhost"
#port = ""
#dbname = "icingaweb2"
#username = "icingaweb2"
#password = "icingaweb2"
#charset = ""
#use_ssl = "0"
#
#[icinga_ido]
#type = "db"
#db = "mysql"
#host = "localhost"
#port = ""
#dbname = "icinga"
#username = "icinga"
#password = "icinga"
#charset = ""
#use_ssl = "0"
#EOF
#
#test -f /usr/local/icinga/icingaweb2/etc/modules/monitoring/config.ini || cat >/usr/local/icinga/icingaweb2/etc/modules/monitoring/config.ini <<EOF
#[security]
#protected_customvars = "*pw*,*pass*,community"
#EOF
#
#test -f /usr/local/icinga/icingaweb2/etc/modules/monitoring/backends.ini || cat >/usr/local/icinga/icingaweb2/etc/modules/monitoring/backends.ini <<EOF
#[icinga]
#type = "ido"
#resource = "icinga_ido"
#EOF
#
#test -f /usr/local/icinga/icingaweb2/etc/modules/monitoring/commandtransport.ini || cat >/usr/local/icinga/icingaweb2/etc/modules/monitoring/commandtransport.ini <<EOF
#[icinga2]
#transport = "api"
#host = "localhost"
#port = "5665"
#username = "root"
#password = "icinga"
#EOF
#
#./bin/icingacli module enable monitoring

# Finished

brew cleanup
