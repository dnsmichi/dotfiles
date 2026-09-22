# Homebrew: executable paths and environment.
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv zsh)"
fi

# User-installed commands, including the standalone Codex CLI.
# Keep PATH entries unique, with ~/.local/bin taking precedence.
typeset -U path PATH
path=("$HOME/.local/bin" $path)
export PATH
