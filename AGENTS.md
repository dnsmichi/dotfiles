# Workstation dotfiles

This repository defines Michael Friedrich's macOS workstation environment for
work at GitLab and is hosted at `dnsmichi/dotfiles`.

## Project navigation

- `README.md` describes the current workstation and manual prerequisites.
- `Brewfile` is the source of truth for Homebrew-managed command-line tools.
- `setup.sh` installs missing Brewfile dependencies and maintains links on macOS.
- `.config/vscode/settings.json` contains the tracked VS Code user settings; `vscode/extensions.txt`
  and `vscode-extensions-install.sh` maintain the manually reviewable extension inventory.

## Working rules

- Keep the repository public-safe. Never commit secrets, credentials, private
  hostnames, internal infrastructure details, or personal/work context that is
  not intended for public sharing.
- Use local, untracked configuration for machine-specific or confidential
  values. Commit sanitized examples only when they are useful.
- Keep the setup small. Add a dependency, configuration layer, or automation
  only for a demonstrated need, and document why it exists.
- Preserve the current learning sequence: Ghostty and tmux, then Starship,
  then Neovim. Do not add cmux unless explicitly requested.
- Ghostty is installed and updated directly from ghostty.org; do not add it to
  `Brewfile` unless the user changes that decision. Track its configuration in
  `.config/ghostty/` to mirror its target location under the home directory.
- Keep Homebrew package declarations grouped by purpose in `Brewfile`.
- Keep `.macos` opt-in and limited to public-safe, personal macOS preferences;
  do not invoke it from `setup.sh` automatically.
- Keep privacy and telemetry changes tool-specific. Reviewed command-line opt-outs
  may run during setup; macOS preference changes remain opt-in.
- Make `setup.sh` safe to rerun. It may install and upgrade Brewfile packages,
  but must not change macOS defaults or modify shell startup files without
  explicit user direction.

## Validation

- For shell-script changes, run `bash -n setup.sh`.
- For `.macos` changes, run `zsh -n .macos` without applying the preferences.
- Run `git diff --check` after edits.
- Do not run `./setup.sh` as a validation step: it changes the machine by
  installing packages. Run it only when explicitly requested.

## Local conventions

- The checkout lives at `~/dev/work/dotfiles`.
- Keep work repositories under `~/dev/work/`.
- Track public-safe work identity settings, including the Git author name,
  work email address, and public signing key. Keep credentials, private keys,
  and confidential work configuration local and untracked.
