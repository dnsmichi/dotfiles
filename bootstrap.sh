#!/bin/bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin master

function sync() {
	rsync --exclude ".git/" \
		--exclude ".DS_Store" \
		--exclude ".macos" \
		--exclude "bootstrap.sh" \
		--exclude "README.md" \
		--exclude "LICENSE" \
		-avh --no-perms . ~;
	source ~/.bash_profile;
}

sync

unset sync;
