# Homebrew's command completions and the additional zsh-completions package.
# Set paths explicitly so completion also works in non-login shells.
typeset -U fpath
for _completion_dir in \
  "${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh/site-functions" \
  "${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh-completions"; do
  [[ -d "$_completion_dir" ]] && fpath=("$_completion_dir" $fpath)
done
unset _completion_dir

# Keep the cache outside the repository and retain compinit's normal checks.
_completion_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
mkdir -p "$_completion_cache"
autoload -Uz compinit
compinit -d "$_completion_cache/zcompdump-$ZSH_VERSION"
unset _completion_cache

# Try case-insensitive matching, then partial and substring matching.
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zmodload zsh/complist
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}%B-- %d --%b%f'
