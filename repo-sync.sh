#!/usr/bin/env bash
# Clone and update the GitLab repository inventory: whole groups including
# subgroups, and individually selected projects.
# Safe to rerun: existing clones are fetched and fast-forwarded only when their
# working tree is clean; local changes and diverged branches are left alone.

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
INVENTORY_DIR="${SCRIPT_DIR}/repos"
REPOSITORIES_DIR="${REPOSITORIES_DIR:-${HOME}/dev/work}"
SHORTCUTS_DIR="${SHORTCUTS_DIR:-${HOME}/dev}"

# Namespaces linked into SHORTCUTS_DIR for fast typing, as "<namespace>:<link name>",
# e.g. ~/dev/da -> ~/dev/work/gitlab-da for Developer Advocacy work.
SHORTCUTS=(
  gitlab-da:da
)

failures=()

require_command() {
  command -v "$1" >/dev/null 2>&1 || {
    printf 'Error: %s is not installed. Run ./setup.sh first.\n' "$1" >&2
    exit 1
  }
}

require_glab_auth() {
  glab auth status --hostname gitlab.com >/dev/null 2>&1 || {
    printf 'Error: glab is not authenticated. Run:\n' >&2
    printf '  glab auth login --hostname gitlab.com --git-protocol ssh\n' >&2
    exit 1
  }
}

# Prints the entries of <name>.txt and the untracked <name>.local.txt, without
# comments or blank lines. Each entry is a full group or project path.
read_inventory() {
  local name="$1" inventory_file
  for inventory_file in "${INVENTORY_DIR}/${name}.txt" "${INVENTORY_DIR}/${name}.local.txt"; do
    [[ -f "${inventory_file}" ]] || continue
    sed -e 's/[[:space:]]*#.*$//' -e '/^[[:space:]]*$/d' "${inventory_file}"
  done
}

# Prints "<path_with_namespace> <ssh_url>" for each active project in the group
# and its subgroups. Projects shared from other groups are excluded.
list_group_projects() {
  local group="$1"
  glab api --paginate --output ndjson \
    "groups/${group//\//%2F}/projects?include_subgroups=true&archived=false&with_shared=false&per_page=100" |
    jq -r '"\(.path_with_namespace) \(.ssh_url_to_repo)"'
}

relative_path() {
  printf '%s' "${1#"${REPOSITORIES_DIR}/"}"
}

clone_project() {
  local destination="$1" url="$2"
  printf 'Cloning %s\n' "$(relative_path "${destination}")"
  mkdir -p "$(dirname "${destination}")"
  git clone --quiet "${url}" "${destination}" </dev/null
}

update_project() {
  local destination="$1"

  git -C "${destination}" fetch --quiet --prune </dev/null

  if [[ -n "$(git -C "${destination}" status --porcelain)" ]]; then
    printf 'Skipping %s: local changes\n' "$(relative_path "${destination}")"
    return
  fi

  if ! git -C "${destination}" rev-parse --abbrev-ref '@{upstream}' >/dev/null 2>&1; then
    printf 'Skipping %s: no upstream branch\n' "$(relative_path "${destination}")"
    return
  fi

  git -C "${destination}" merge --quiet --ff-only '@{upstream}' 2>/dev/null ||
    printf 'Skipping %s: branch has diverged from upstream\n' "$(relative_path "${destination}")"
}

sync_project() {
  local path="$1" url="$2"
  local destination="${REPOSITORIES_DIR}/${path}"

  if [[ -d "${destination}/.git" ]]; then
    update_project "${destination}" || failures+=("${path}: update failed")
  elif [[ -e "${destination}" ]]; then
    failures+=("${path}: ${destination} exists but is not a Git repository")
  else
    clone_project "${destination}" "${url}" || failures+=("${path}: clone failed")
  fi
}

sync_group() {
  local group="$1" path url projects

  printf '\n==> %s\n' "${group}"
  projects="$(list_group_projects "${group}")" || {
    failures+=("${group}: could not list projects")
    return
  }

  while read -r path url; do
    [[ -n "${path}" ]] || continue
    sync_project "${path}" "${url}"
  done <<<"${projects}"
}

ensure_shortcut() {
  local namespace="${1%%:*}" link_name="${1#*:}"
  local source_path="${REPOSITORIES_DIR}/${namespace}"
  local link_path="${SHORTCUTS_DIR}/${link_name}"

  [[ -d "${source_path}" ]] || return 0

  if [[ -L "${link_path}" ]]; then
    [[ "$(readlink "${link_path}")" == "${source_path}" ]] && return
    failures+=("${link_path}: link points somewhere else: $(readlink "${link_path}")")
  elif [[ -e "${link_path}" ]]; then
    failures+=("${link_path}: exists and is not a link to ${source_path}")
  else
    printf 'Linking %s -> %s\n' "${link_path}" "${source_path}"
    mkdir -p "${SHORTCUTS_DIR}"
    ln -s "${source_path}" "${link_path}"
  fi
}

main() {
  if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    printf 'Usage: %s\n' "${0##*/}"
    printf 'Clones or updates every group in repos/groups{,.local}.txt and every\n'
    printf 'project in repos/projects{,.local}.txt into REPOSITORIES_DIR\n'
    printf '(default: ~/dev/work), and links shortcuts such as ~/dev/da -> gitlab-da\n'
    printf 'into SHORTCUTS_DIR (default: ~/dev).\n'
    return
  fi

  require_command glab
  require_command jq
  require_glab_auth

  local path
  while IFS= read -r path; do
    sync_group "${path}"
  done < <(read_inventory groups)

  printf '\n==> Selected projects\n'
  while IFS= read -r path; do
    sync_project "${path}" "git@gitlab.com:${path}.git"
  done < <(read_inventory projects)

  local shortcut
  for shortcut in "${SHORTCUTS[@]}"; do
    ensure_shortcut "${shortcut}"
  done

  if ((${#failures[@]} > 0)); then
    printf '\nFailures:\n' >&2
    printf '  %s\n' "${failures[@]}" >&2
    exit 1
  fi

  printf '\nAll repositories are up to date in %s\n' "${REPOSITORIES_DIR}"
}

main "$@"
