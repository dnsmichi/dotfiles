# General Zsh configuration.
export EDITOR="nvim"
export VISUAL="$EDITOR"

source "$HOME/.config/zsh/history.zsh"
source "$HOME/.config/zsh/completions.zsh"
source "$HOME/.config/zsh/aliases.zsh"
source "$HOME/.config/zsh/functions.zsh"

# Shell env - Starship
eval "$(starship init zsh)"

# Mise
eval "$(~/.local/bin/mise activate zsh)"

# Search all history with Ctrl-R; keep arrow keys under Zsh's control.
eval "$(atuin init zsh --disable-up-arrow)"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="$HOME/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

# Load syntax highlighting after completion and other shell integrations.
if [[ -r "${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
