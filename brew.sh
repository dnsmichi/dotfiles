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
brew install htop-osx pidof pstree

brew install vim --with-override-system-vi
brew install grep
brew install openssh
brew install screen
brew install gmp

brew install binutils
brew install nmap
brew install socat
brew install xz p7zip

brew install git git-lfs tig hub
brew install lynx
brew install rename
brew install rlwrap
brew install ssh-copy-id
brew install tree

# REST APIs with JSON
brew install jq jo

# GnuPG
brew install gnupg pinentry

mkdir -p ~/.gnupg
echo "no-emit-version" >> ~/.gnupg/gpg.conf
echo "no-tty" >> ~/.gnupg/gpg.conf
echo "#default-key <key-uid>" >> ~/.gnupg/gpg.conf

cat > ~/.gnupg/gpg-agent.conf <<EOF
pinentry-program /usr/local/bin/pinentry
default-cache-ttl 60000
max-cache-ttl 720000
EOF

gpg-connect-agent killagent /bye
gpg-connect-agent /bye

# Dev
# Use ninja instead of make
brew install ninja

# Ruby
brew install ruby

# Python
brew install python
brew install python2

pip install --upgrade pip setuptools
pip3 install --upgrade pip setuptools

# Go
brew install go

# Redis
brew install redis
brew services start redis

################################
# Casks
brew cask install java apache-directory-studio
brew cask install atom visual-studio-code firefox
brew cask install macvim vlc
brew cask install wireshark tcpflow xquartz poedit
brew cask install docker wireshark jitsi
brew cask install github

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
