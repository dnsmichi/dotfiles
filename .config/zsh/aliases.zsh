# ZSH Aliases

# Start GitLab Duo CLI.
if command -v glab >/dev/null 2>&1; then
  alias duo='glab duo cli'
fi

# ll
if command -v eza >/dev/null 2>&1; then
  alias ll='eza -lah --group-directories-first'
else
  alias ll='ls -lah'
fi

# Use Neovim when the traditional Vim command is entered.
if command -v nvim >/dev/null 2>&1; then
  alias vim='nvim'
fi

# Remove merged local branches. Safe deletion (-d) is the default; use -D only
# when a merged branch needs force deletion. Git also prunes remote-tracking
# branches automatically on fetch via fetch.prune in .gitconfig.
git_prune() {
  local delete_flag="-d"
  if [[ "${1:-}" == "-d" || "${1:-}" == "-D" ]]; then
    delete_flag="$1"
    shift
  fi

  if (($#)); then
    printf 'Usage: git_prune [-d|-D]\n' >&2
    return 2
  fi

  local current_branch
  current_branch="$(git branch --show-current)" || return

  git for-each-ref --merged --format='%(refname:short)' refs/heads | while IFS= read -r branch; do
    [[ -z "$branch" || "$branch" == "$current_branch" || "$branch" == "main" || "$branch" == "master" ]] && continue
    git branch "$delete_flag" "$branch"
  done
}

# Explicitly prune remote-tracking branches from every configured remote.
git_fetch_prune() {
  git fetch --all --prune "$@"
}

# Compact kubectl aliases based on the conventions from kubectl-aliases.
if command -v kubectl >/dev/null 2>&1; then
  alias k='kubectl'
  alias kg='kubectl get'
  alias kd='kubectl describe'
  alias ka='kubectl apply -f'
  alias kdel='kubectl delete'
  alias kex='kubectl exec -it'
  alias klo='kubectl logs -f'
  alias kpf='kubectl port-forward'
fi
