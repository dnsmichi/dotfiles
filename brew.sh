#!/bin/bash

# This installs homebrew itself, and also the command line tools in silent mode
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"


brew update
brew upgrade

BREW_PREFIX=$(brew --prefix)

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

brew install git
brew install lynx
brew install rename
brew install rlwrap
brew install ssh-copy-id
brew install tree

# Dev
brew install qcachegrind --with-graphviz

brew install ccache boost cmake bison flex yajl openssl@1.1 mysql-connector-c++
brew install nagios-plugins

brew install mariadb
ln -sfv /usr/local/opt/mariadb/*.plist ~/Library/LaunchAgents
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mariadb.plist

brew install php

brew install redis
brew services start redis

################################
# Casks
brew tap caskroom/cask

brew cask install apache-directory-studio atom filezilla firefox macvim vlc wireshark tcpflow xquartz poedit

# Gimp
brew cask install gimp
cd /Applications/GIMP.app/Contents/Resources/share/gimp/2.0/scripts/
wget http://registry.gimp.org/files/arrow.scm

# final cleanup
brew cleanup
