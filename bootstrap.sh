#!/bin/zsh

cd ${0:a:h}

git pull origin main

function sync() {
	rsync --exclude ".git/" \
		--exclude "doc/" \
		--exclude ".DS_Store" \
		--exclude ".macos" \
		--exclude "bootstrap.sh" \
		--exclude "README.md" \
		--exclude "LICENSE" \
		-avh --no-perms . ~;
}

sync

unset sync;
