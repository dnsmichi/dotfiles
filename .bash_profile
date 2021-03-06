# general
# =========================================================

# macOS Catalina with zsh as default
export BASH_SILENCE_DEPRECATION_WARNING=1

# Imports
for file in ~/.{bash_prompt,bash_aliases,bash_functions}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s checkwinsize

# some more ls aliases
alias ls='ls -G'
alias ll='ls -G -l'
alias la='ls -G -A'
#alias l='ls -CF'
alias du='du -kh'       # Makes a more readable output.
alias df='df -kTh'
alias lt='ls -lhtr'

alias duh='du -d 1 -h' # -d 1 is --max-depth=1 on linux

# bash completion
test -f /usr/local/etc/bash_completion && source /usr/local/etc/bash_completion

# GitHub tokens
test -f $HOME/.github_tokens && source $HOME/.github_tokens

# Homebrew
export PATH="/usr/local/sbin:/usr/local/bin:$PATH"
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"

# Golang
export PATH="$PATH:$HOME/go/bin"

# hub
test -f /usr/local/etc/bash_completion.d/hub.bash_completion.sh && source /usr/local/etc/bash_completion.d/hub.bash_completion.sh

# gnupg
export "GPG_TTY=$(tty)"

# vagrant - too many open files
ulimit -n 1024

# SSH
# =========================================================

# fix ssh -A
ssh-add $HOME/.ssh/id_rsa > /dev/null 2>&1

# DEV
# =========================================================

# Docker
alias docker_prune="docker container prune --force --filter until=24h && docker image prune --all --force --filter until=24h"

# Git
alias git_prune="git branch -vv | grep 'origin/.*: gone]' | awk '{print \$1}' | xargs git branch -d"

# ccache is managed with symlinks to avoid collision with cgo
export PATH="/opt/ccache:$PATH"

# go
export GOPATH="$HOME/go"
test -f $GOPATH && export PATH=$PATH:$(go env GOPATH)/bin

# lldb (use System's Python path)
alias lldb="PATH=/usr/bin /usr/bin/lldb"

# icinga
alias authors="git log --use-mailmap | grep ^Author: | cut -f2- -d' ' | sort | uniq > AUTHORS"

# coredumps
#ulimit -c unlimited

# Avoid objc fork crashes
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

export I2_USER=$(id -u -n)
export I2_GROUP=$(id -g -n)
export I2_GENERIC="-DCMAKE_INSTALL_PREFIX=/usr/local/icinga/icinga2 -DICINGA2_USER=$I2_USER -DICINGA2_GROUP=$I2_GROUP -DOPENSSL_INCLUDE_DIR=/usr/local/opt/openssl@1.1/include -DOPENSSL_SSL_LIBRARY=/usr/local/opt/openssl@1.1/lib/libssl.dylib -DOPENSSL_CRYPTO_LIBRARY=/usr/local/opt/openssl@1.1/lib/libcrypto.dylib -DICINGA2_PLUGINDIR=/usr/local/sbin -DICINGA2_WITH_PGSQL=OFF -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DBoost_NO_BOOST_CMAKE=ON"

export I2_DEBUG="-DCMAKE_BUILD_TYPE=Debug -DICINGA2_UNITY_BUILD=OFF $I2_GENERIC"
export I2_RELEASE="-DCMAKE_BUILD_TYPE=RelWithDebInfo -DICINGA2_WITH_TESTS=ON -DICINGA2_UNITY_BUILD=ON $I2_GENERIC"

alias i2_debug="mkdir -p debug; cd debug; cmake -GNinja $I2_DEBUG ..; cd ..; ninja -C debug install"
alias i2_release="mkdir -p release; cd release; cmake -GNinja $I2_RELEASE ..; cd ..; ninja -C release install"

export PATH=/usr/local/icinga/icinga2/sbin/:$PATH
test -f /usr/local/icinga/icinga2/etc/bash_completion.d/icinga2 && source /usr/local/icinga/icinga2/etc/bash_completion.d/icinga2

export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# icingacli
export PATH=/usr/local/icinga/icingaweb2/bin:$PATH
alias icingacli="ICINGAWEB_CONFIGDIR=/usr/local/icinga/icingaweb2/etc icingacli"

# misc
# =========================================================
export PATH=$PATH:/usr/local/opt/go/libexec/bin

PATH="/Users/michi/perl5/bin${PATH+:}${PATH}"; export PATH;
PERL5LIB="/Users/michi/perl5/lib/perl5${PERL5LIB+:}${PERL5LIB}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/Users/michi/perl5${PERL_LOCAL_LIB_ROOT+:}${PERL_LOCAL_LIB_ROOT}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/Users/michi/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/michi/perl5"; export PERL_MM_OPT;

# ruby
PATH="/usr/local/opt/ruby/bin:$PATH"; export PATH;
