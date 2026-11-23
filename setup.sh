#!/usr/bin/env bash
# Set up and maintain the personal macOS development environment.
# Safe to run again: Homebrew reconciles the Brewfile and this script does not
# change macOS defaults or write shell configuration.

set -euo pipefail

readonly REPOSITORY_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
readonly BREWFILE="${REPOSITORY_DIR}/Brewfile"
readonly BREW_INSTALL_PREFIX="/opt/homebrew"
# Same path as repo-sync.sh, which keeps the clone up to date.
readonly GITLAB_AI_SKILLS_DIR="${HOME}/dev/work/gitlab-org/ai/skills"
readonly GITLAB_AI_SKILLS_URL="https://gitlab.com/gitlab-org/ai/skills.git"

# Skills linked from the gitlab-org/ai/skills clone, unchanged.
readonly GITLAB_AI_SKILLS=(
  glab
  gitlab-pipeline-watch
  gitlab-babysit-mr
  handoff
  gitlab-docs-change
  gitlab-docs-review
)

log() {
  printf '\n==> %s\n' "$*"
}

fail() {
  printf 'Error: %s\n' "$*" >&2
  exit 1
}

require_macos() {
  [[ "$(uname -s)" == "Darwin" ]] || fail "This setup script supports macOS only."
}

require_command_line_tools() {
  if xcode-select -p >/dev/null 2>&1; then
    return
  fi

  log "Requesting Xcode Command Line Tools"
  xcode-select --install || true
  fail "Finish installing the Xcode Command Line Tools, then run ./setup.sh again."
}

ensure_homebrew() {
  if [[ ! -x "${BREW_INSTALL_PREFIX}/bin/brew" ]]; then
    log "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  eval "$("${BREW_INSTALL_PREFIX}/bin/brew" shellenv zsh)"
}

install_packages() {
  [[ -f "${BREWFILE}" ]] || fail "Brewfile not found: ${BREWFILE}"

  log "Installing and updating Brewfile dependencies"
  brew bundle install --file "${BREWFILE}"
}

apply_privacy_defaults() {
  if ! command -v gh >/dev/null 2>&1; then
    log "Skipping GitHub CLI privacy default; gh is not installed"
    return
  fi

  log "Applying reviewed privacy defaults"
  gh config set telemetry disabled
}

ensure_managed_link() {
  local relative_path="$1"
  ensure_link "${REPOSITORY_DIR}/${relative_path}" "${2:-${HOME}/${relative_path}}"
}

ensure_link() {
  local source_path="$1" destination_path="$2"

  [[ -e "${source_path}" ]] || fail "Managed config source not found: ${source_path}"

  if [[ -L "${destination_path}" ]]; then
    if [[ "$(readlink "${destination_path}")" == "${source_path}" ]]; then
      return
    fi

    fail "Managed config link points somewhere else: ${destination_path} -> $(readlink "${destination_path}")"
  fi

  if [[ -e "${destination_path}" ]]; then
    printf 'Managed config was replaced by a regular file or directory: %s\n' "${destination_path}" >&2
    printf 'Review the differences below, merge the changes into the repository if needed, then remove the local file and rerun setup.\n\n' >&2
    if [[ -d "${source_path}" && -d "${destination_path}" ]]; then
      diff -ur -- "${source_path}" "${destination_path}" >&2 || true
    elif [[ -f "${source_path}" && -f "${destination_path}" ]]; then
      diff -u -- "${source_path}" "${destination_path}" >&2 || true
    else
      printf 'Managed config type differs between source and destination.\n' >&2
    fi
    fail "Refusing to replace ${destination_path}"
  fi

  log "Linking ${destination_path}"
  mkdir -p "$(dirname "${destination_path}")"
  ln -s "${source_path}" "${destination_path}"
}

# For apps that ignore symlinks, such as Herdr for icons.
ensure_managed_copy() {
  local relative_path="$1"
  local source_path="${REPOSITORY_DIR}/${relative_path}"
  local destination_path="${HOME}/${relative_path}"

  [[ -f "${source_path}" ]] || fail "Managed copy source not found: ${source_path}"

  if [[ -e "${destination_path}" || -L "${destination_path}" ]]; then
    if [[ ! -L "${destination_path}" ]] && cmp -s -- "${source_path}" "${destination_path}"; then
      return
    fi

    printf 'Managed copy differs from the repository: %s\n' "${destination_path}" >&2
    printf 'Review the differences below, merge the changes into the repository if needed, then remove the local file and rerun setup.\n\n' >&2
    diff -u -- "${source_path}" "${destination_path}" >&2 || true
    fail "Refusing to replace ${destination_path}"
  fi

  log "Copying ${destination_path}"
  mkdir -p "$(dirname "${destination_path}")"
  cp -- "${source_path}" "${destination_path}"
}

link_skills() {
  local skill_file skill_name
  for skill_file in "${REPOSITORY_DIR}"/skills/*/SKILL.md; do
    [[ -f "${skill_file}" ]] || continue
    skill_name="${skill_file%/SKILL.md}"
    skill_name="${skill_name##*/}"

    ensure_managed_link "skills/${skill_name}" "${HOME}/.claude/skills/${skill_name}"
    ensure_managed_link "skills/${skill_name}" "${HOME}/.agents/skills/${skill_name}"

    ensure_managed_link "skills/${skill_name}" "${HOME}/.gitlab/duo/skills/${skill_name}"
  done
}

# Clones gitlab-org/ai/skills when missing. The project is public, so this works
# before glab is authenticated; repo-sync.sh updates it later.
ensure_gitlab_ai_skills() {
  if [[ -d "${GITLAB_AI_SKILLS_DIR}/.git" ]]; then
    return
  fi
  [[ -e "${GITLAB_AI_SKILLS_DIR}" ]] &&
    fail "${GITLAB_AI_SKILLS_DIR} exists but is not a Git repository"

  log "Cloning gitlab-org/ai/skills into ${GITLAB_AI_SKILLS_DIR}"
  mkdir -p "$(dirname "${GITLAB_AI_SKILLS_DIR}")"
  git clone --quiet "${GITLAB_AI_SKILLS_URL}" "${GITLAB_AI_SKILLS_DIR}"
}

link_gitlab_ai_skills() {
  local skill_name source_path
  for skill_name in "${GITLAB_AI_SKILLS[@]}"; do
    source_path="${GITLAB_AI_SKILLS_DIR}/skills/${skill_name}"
    ensure_link "${source_path}" "${HOME}/.claude/skills/${skill_name}"
    ensure_link "${source_path}" "${HOME}/.agents/skills/${skill_name}"
    ensure_link "${source_path}" "${HOME}/.gitlab/duo/skills/${skill_name}"
  done
}

main() {
  require_macos
  require_command_line_tools
  ensure_homebrew
  install_packages
  apply_privacy_defaults

  # Managed symlinks. Each path is relative to both the repository and HOME.
  local relative_path
  local managed_paths=(
    .agents/AGENTS.md
    .zprofile
    .zshrc
    .gitconfig
    .ssh/config
    .ssh/config.local
    .ssh/allowed_signers
    .ssh/gitlab_work.pub
    .config/atuin/config.toml
    .config/cmux/cmux.json
    .config/ghostty/config.ghostty
    .config/herdr-app/programs.json
    .config/herdr-app/settings.json
    .config/herdr-app/themes/gruvbox-dark-hard.json
    .config/herdr-app/themes/gruvbox-light-hard.json
    .config/mise/config.toml
    .config/nvim
    .config/starship.toml
    .config/zsh/aliases.zsh
    .config/zsh/completions.zsh
    .config/zsh/functions.zsh
    .config/zsh/history.zsh
    .config/zsh/keybindings.zsh
  )

  for relative_path in "${managed_paths[@]}"; do
    ensure_managed_link "${relative_path}"
  done

  # Herdr does not load icons through symlinks, so copy them.
  local icon_file
  for icon_file in "${REPOSITORY_DIR}"/.config/herdr-app/my-icons/*.svg; do
    [[ -f "${icon_file}" ]] || continue
    ensure_managed_copy "${icon_file#"${REPOSITORY_DIR}"/}"
  done

  # Claude Code, Codex, and GitLab Duo read global instructions from their own directories.
  ensure_managed_link .agents/AGENTS.md "${HOME}/.claude/CLAUDE.md"
  ensure_managed_link .agents/AGENTS.md "${HOME}/.codex/AGENTS.md"
  ensure_managed_link .agents/AGENTS.md "${HOME}/.gitlab/duo/AGENTS.md"

  # VS Code stores user settings in macOS's Application Support directory.
  ensure_managed_link \
    .config/vscode/settings.json \
    "${HOME}/Library/Application Support/Code/User/settings.json"

  link_skills
  ensure_gitlab_ai_skills
  link_gitlab_ai_skills

  log "Bootstrap complete"
  printf 'Open a new terminal, then run: brew doctor\n'
}

main "$@"
