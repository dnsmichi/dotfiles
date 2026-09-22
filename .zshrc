# General ZSH config

# ~/.zshrc
source "$HOME/.config/zsh/aliases.zsh"
source "$HOME/.config/zsh/functions.zsh"

# Shell env - Starship
eval "$(starship init zsh)"

# Mise
eval "$(~/.local/bin/mise activate zsh)"

# Atuin shell history
eval "$(atuin init zsh)"

#ZSH syntax highlighting
if [[ -r "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# Other

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="$HOME/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
