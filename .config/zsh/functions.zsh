# ZSH Functions

# Create a directory and enter it.
mkcd() {
  [[ $# -eq 1 ]] || {
    print -u2 "usage: mkcd DIRECTORY"
    return 2
  }

  mkdir -p -- "$1" && cd -- "$1"
}

# Jump to the root of the current Git repository.
croot() {
  local root
  root=$(git rev-parse --show-toplevel 2>/dev/null) || {
    print -u2 "not inside a Git repository"
    return 1
  }

  cd -- "$root"
}

# Reload the interactive shell configuration.
reload-zsh() {
  source "$HOME/.zshrc"
}

# Create and enter a temporary working directory.
tmpd() {
  local dir
  dir=$(mktemp -d "${TMPDIR:-/tmp}/zsh.XXXXXX") || return
  cd -- "$dir"
}
