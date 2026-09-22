#!/usr/bin/env bash
# Set up and maintain the personal macOS development environment.
# Safe to run again: Homebrew reconciles the Brewfile and this script does not
# change macOS defaults or write shell configuration.

set -euo pipefail

readonly REPOSITORY_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
readonly BREWFILE="${REPOSITORY_DIR}/Brewfile"
readonly BREW_INSTALL_PREFIX="/opt/homebrew"

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
  local source_path="${REPOSITORY_DIR}/${relative_path}"
  local destination_path="${2:-${HOME}/${relative_path}}"

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

main() {
  require_macos
  require_command_line_tools
  ensure_homebrew
  install_packages
  apply_privacy_defaults

  # Managed symlinks. Each path is relative to both the repository and HOME.
  local relative_path
  local managed_paths=(
    .zprofile
    .zshrc
    .gitconfig
    .ssh/config
    .config/atuin/config.toml
    .config/ghostty/config.ghostty
    .config/mise/config.toml
    .config/nvim
    .config/starship.toml
    .config/zsh/aliases.zsh
    .config/zsh/functions.zsh
  )

  for relative_path in "${managed_paths[@]}"; do
    ensure_managed_link "${relative_path}"
  done

  # VS Code stores user settings in macOS's Application Support directory.
  ensure_managed_link \
    .config/vscode/settings.json \
    "${HOME}/Library/Application Support/Code/User/settings.json"

  log "Bootstrap complete"
  printf 'Open a new terminal, then run: brew doctor\n'
}

main "$@"
