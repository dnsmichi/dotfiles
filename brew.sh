#!/bin/bash

# This installs homebrew itself, and also the command line tools in silent mode
#/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"


brew update
brew upgrade

BREW_PREFIX=$(brew --prefix)

brew tap caskroom/cask
brew tap homebrew/services

# coreutils
brew install coreutils
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

brew install moreutils
brew install findutils
brew install gnu-sed --with-default-names
brew install gnu-tar gawk gnutls gnu-indent gnu-getopt --with-default-names

brew install bash
brew install bash-completion2

if ! fgrep -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
  echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells;
  chsh -s "${BREW_PREFIX}/bin/bash";
fi;

brew install wget --with-iri
brew install gnupg
brew install htop-osx pidof

brew install vim --with-override-system-vi
brew install grep
brew install openssh
brew install screen
brew install gmp

brew install binutils
brew install nmap
brew install socat
brew install xz

brew install git tig hub
brew install lynx
brew install rename
brew install rlwrap
brew install ssh-copy-id
brew install tree

# Dev
brew install qcachegrind --with-graphviz

brew install ccache boost cmake bison flex yajl openssl@1.1 mysql-connector-c++
brew install nagios-plugins

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

# Ruby
brew install ruby

# Python

# Redis
brew install redis
brew services start redis

################################
# Casks
brew cask install apache-directory-studio atom filezilla firefox macvim vlc wireshark tcpflow xquartz poedit

# Gimp
brew cask install gimp
#mkdir -p "/Applications/GIMP.app/Contents/Resources/share/gimp/2.0/scripts/"
#cd /Applications/GIMP.app/Contents/Resources/share/gimp/2.0/scripts/
#wget http://registry.gimp.org/files/arrow.scm

# Vagrant
brew cask install vagrant
vagrant plugin install vagrant-parallels
vagrant plugin install vagrant-openstack-provider
vagrant plugin install vagrant-vbguest

# final cleanup
brew cleanup
