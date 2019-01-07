#!/bin/bash

brew update
#brew upgrade

BREW_PREFIX=$(brew --prefix)

brew tap caskroom/cask
brew tap homebrew/services

# Dev
brew install qcachegrind --with-graphviz

brew install ccache boost cmake bison flex yajl openssl@1.1 mysql-connector-c++
brew install nagios-plugins

# Database
brew install mariadb
brew services start mariadb

# Redis
brew install redis
brew services start redis

# final cleanup
brew cleanup

# Bootstrap later
# icinga2 api setup
# cd /usr/local/icinga/icinga2/var/lib/icinga2/certs
# HOST_NAME=mbpmif.int.netways.de
# icinga2 pki new-cert --cn ${HOST_NAME} --csr ${HOST_NAME}.csr --key ${HOST_NAME}.key
# icinga2 pki sign-csr --csr ${HOST_NAME}.csr --cert ${HOST_NAME}.crt
# echo "const NodeName = \"${HOST_NAME}\"" >> /usr/local/icinga/icinga2/etc/icinga2/constants.conf
