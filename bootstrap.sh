#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin master

function sync() {
	rsync --exclude ".git/" \
		--exclude "doc/"
		--exclude ".DS_Store" \
		--exclude ".macos" \
		--exclude "bootstrap.sh" \
		--exclude "README.md" \
		--exclude "LICENSE" \
		-avh --no-perms . ~;
	source ~/.bash_profile;

	for file in .{bashrc,bash_prompt,bash_aliases,bash_functions}; do
		[ -r "~/$file" ] && [ -f "~/$file" ] && sudo ln -sf "~/$file" "/root/$file";
	done;
	unset file;
}

sync

unset sync;
