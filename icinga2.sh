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
