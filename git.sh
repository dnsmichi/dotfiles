#!/usr/bin/env bash

REPOS_GH_ICINGA=("icinga2" "icingaweb2" "icinga-vagrant")
REPOS_GL_ICINGA=()
REPOS_GH_NET=()
REPOS_GL_NET=()

GIT_EMAIL_ICINGA="michael.friedrich@icinga.com"

mkdir -p $HOME/dev/icinga
cd $HOME/dev/icinga
for r in $REPOS_GH_ICINGA; do
	test -d $r || git clone https://github.com/icinga/$r.git
	cd $r
	git config user.email $GIT_EMAIL_ICINGA
	cd ..
done
