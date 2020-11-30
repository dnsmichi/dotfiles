#!/bin/zsh

brew update
brew upgrade

BREW_PREFIX=$(brew --prefix)

# coreutils
brew install coreutils
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"
ln -s "${BREW_PREFIX}/bin/greadlink" "${BREW_PREFIX}/bin/readlink"

brew install moreutils
brew install findutils
brew install gnu-sed
brew install gnu-tar gawk gnutls gnu-indent gnu-getopt

ln -s "${BREW_PREFIX}/bin/gtar" "${BREW_PREFIX}/bin/tar"

brew install wget
brew install vim

# System
brew install htop-osx pidof pstree grep openssh screen gmp binutils nmap socat rename rlwrap ssh-copy-id tree

# Images
brew install imagemagick

# Archive & Git
brew install xz p7zip git git-lfs tig hub

# JSON
brew install jq jo

# Dev: Ruby
brew install ruby

# Dev: Python 3
brew install python
pip install --upgrade pip setuptools

# Dev: Go
brew install go

# Dev: Redis
brew install redis
brew services start redis


################################
# Casks
brew cask install java
brew cask install visual-studio-code firefox
brew cask install vlc wireshark gimp inkscape handbrake

# Vagrant
brew cask install vagrant
#vagrant plugin install vagrant-parallels
#vagrant plugin install vagrant-openstack-provider
#vagrant plugin install vagrant-vbguest

# final cleanup
brew cleanup

