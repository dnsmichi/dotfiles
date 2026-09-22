#!/usr/bin/env bash
# Install and maintain the personal VS Code extension inventory.
# Safe to rerun: `code --install-extension` leaves installed extensions in place.

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
INVENTORY_FILE="${SCRIPT_DIR}/vscode/extensions.txt"

require_code() {
  command -v code >/dev/null 2>&1 || {
    printf 'Error: VS Code CLI (code) is not available. Enable it from VS Code:\n' >&2
    printf "  Command Palette → Shell Command: Install 'code' command in PATH\n" >&2
    exit 1
  }
}

read_inventory() {
  [[ -f "${INVENTORY_FILE}" ]] || {
    printf 'Error: extension inventory not found: %s\n' "${INVENTORY_FILE}" >&2
    exit 1
  }

  sed -e 's/[[:space:]]*#.*$//' -e '/^[[:space:]]*$/d' "${INVENTORY_FILE}"
}

discover_extensions() {
  code --list-extensions | sort -fu
}

update_inventory() {
  local temporary_file
  temporary_file="$(mktemp)"
  trap 'rm -f "${temporary_file}"' EXIT

  {
    printf '%s\n' '# Personal VS Code extension inventory.'
    printf '%s\n' '# Generated from extensions installed by the VS Code CLI.'
    discover_extensions
  } >"${temporary_file}"

  mv "${temporary_file}" "${INVENTORY_FILE}"
  trap - EXIT
  printf 'Updated %s\n' "${INVENTORY_FILE}"
}

install_inventory() {
  local extension
  while IFS= read -r extension; do
    printf 'Installing %s\n' "${extension}"
    code --install-extension "${extension}"
  done < <(read_inventory)
}

main() {
  if [[ "${1:-install}" == "--help" || "${1:-install}" == "-h" ]]; then
    printf 'Usage: %s [install|--discover|--update-inventory]\n' "${0##*/}"
    return
  fi

  require_code

  case "${1:-install}" in
    install)
      install_inventory
      ;;
    --discover)
      discover_extensions
      ;;
    --update-inventory)
      update_inventory
      ;;
    *)
      printf 'Unknown option: %s\n' "$1" >&2
      exit 2
      ;;
  esac
}

main "$@"
