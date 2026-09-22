# Native history remains available alongside Atuin's searchable database.
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000

setopt EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_VERIFY

# Save commands as they are entered, without importing other active sessions.
# Use Atuin's Ctrl-R search when history across sessions is wanted.
unsetopt SHARE_HISTORY INC_APPEND_HISTORY_TIME
setopt INC_APPEND_HISTORY
