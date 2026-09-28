# Use emacs-style line editing. Zsh switches to vi mode on its own when
# $EDITOR or $VISUAL contains "vi", which breaks Ctrl-A/Ctrl-E. Ghostty sends
# those for Cmd+Left/Right.
bindkey -e

# Plain Zsh does not bind Home, End, and forward delete. Terminals send them as
# escape sequences, so map them to line editing widgets. This covers Ghostty,
# iTerm2, and SSH sessions alike.

# Home/End (Fn+Left/Right on Mac keyboards), in normal and application cursor mode.
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[OH' beginning-of-line
bindkey '^[OF' end-of-line

# Also bind the sequences the terminal reports in its terminfo entry, in case
# they differ from the ones above.
[[ -n "${terminfo[khome]}" ]] && bindkey "${terminfo[khome]}" beginning-of-line
[[ -n "${terminfo[kend]}" ]] && bindkey "${terminfo[kend]}" end-of-line

# Forward delete (Fn+Backspace) deletes the character under the cursor
# instead of printing "~".
bindkey '^[[3~' delete-char
