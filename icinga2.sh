#!/bin/bash

brew update
#brew upgrade

BREW_PREFIX=$(brew --prefix)

brew tap caskroom/cask
brew tap homebrew/services

# Dev
brew install qcachegrind --with-graphviz

brew install ccache boost cmake bison flex yajl openssl@1.1 mysql-connector-c++
brew install monitoring-plugins

# Database
brew install mariadb
brew services start mariadb

mkdir -p /usr/local/etc/my.cnf.d

# Redis
brew install redis
brew services start redis

# final cleanup
brew cleanup

# Bootstrap later

# mysql_secure_connection
# root:netways
# vim $HOME/.my.cnf

# [client]
# user = root
# password = netways

# mysql -e 'create database icinga;'
# mysql -e "grant all on icinga.* to 'icinga'@'localhost' identified by 'icinga';"
# mysql icinga < $HOME/dev/icinga/icinga2/lib/db_ido_mysql/schema/mysql.sql

# icinga2 api setup
# cd /usr/local/icinga/icinga2/var/lib/icinga2/certs
# HOST_NAME=mbpmif.int.netways.de
# icinga2 pki new-cert --cn ${HOST_NAME} --csr ${HOST_NAME}.csr --key ${HOST_NAME}.key
# icinga2 pki sign-csr --csr ${HOST_NAME}.csr --cert ${HOST_NAME}.crt
# echo "const NodeName = \"${HOST_NAME}\"" >> /usr/local/icinga/icinga2/etc/icinga2/constants.conf
