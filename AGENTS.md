# Workstation dotfiles

This repository defines Michael Friedrich's macOS workstation environment for
work at GitLab and is hosted at `dnsmichi/dotfiles`.

## Project navigation

- `README.md` describes the current workstation and the step-by-step setup of a new Macbook.
- `Brewfile` is the source of truth for Homebrew-managed command-line tools.
- `setup.sh` installs missing Brewfile dependencies and maintains links on macOS.
- `.config/vscode/settings.json` contains the tracked VS Code user settings; `vscode/extensions.txt`
  and `vscode-extensions-install.sh` maintain the manually reviewable extension inventory.
- `repos/groups.txt` (recursive) and `repos/projects.txt` (selected) list the
  GitLab repositories that `repo-sync.sh` clones and updates under `~/dev/work/`.
  Private projects whose paths are already publicly known, such as
  `gitlab-com/content-sites/internal-handbook`, may be tracked. Other private
  paths go in the untracked `repos/*.local.txt` files; ask before tracking them.

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

## README structure

- Keep the top-level parts in this order: Setup checklist, Setup, Contributing
  to GitLab, Reference, Maintenance, Troubleshooting. "Contributing to GitLab"
  covers optional tools for GitLab itself (GDK, docs linting), not this repository.
- Setup steps follow the order a new Macbook needs them. A step may only depend
  on earlier steps; move a step up rather than referencing a later one.
- The README has no `[TOC]`. The Setup checklist is the navigation for the
  setup order. It is a Markdown ordered list using `1.` for every item, with
  one link per heading and no checkboxes, because checkboxes cannot be ticked
  in a rendered README. It is two levels deep: `###` phases (Base system,
  Credentials and GitLab, Agentic AI, Personal settings) as top-level items, and
  `####` steps nested with three spaces. `#####` sub-sections are not listed.
  Add new steps to the phase whose earlier steps they depend on.
- `.gitlab/issue_templates/new-macbook-setup.md` is the tickable checklist for
  tracking a setup in an issue. It lists all heading levels under Setup,
  including `#####` sub-sections, indented by three spaces per level. It adds
  `[ ] ` to every item and uses absolute links of the form
  `https://gitlab.com/dnsmichi/dotfiles/-/blob/main/README.md#<anchor>`,
  because relative anchors do not resolve in issues.
- Keep both lists in sync with the Setup headings. The README list equals the
  first two levels of the template, with the same items, order, and nesting.
- Do not put numbers in headings, and do not refer to steps by number such as
  "step 7". Link to the section by its heading name instead, so renaming or
  inserting a step does not break references.
- When adding, renaming, or removing a setup step, update its checklist entry
  and every link to its heading.
- Keep heading anchors unique. When two headings would produce the same or a
  confusingly similar anchor, rename them to describe what the section does,
  for example "Restore an encrypted backup" instead of a second "Backup".
- Setup explains what to do; Reference explains what is configured and where it
  lives; Maintenance covers recurring tasks such as backups and inventory updates.
- Mention automated behavior once, in the step that triggers it, for example the
  skills and configuration links created by `setup.sh`.
- Start every `##` part and `###` section with a one- or two-sentence intro that
  says what it covers, before any sub-heading, list, or code block.

## Validation

- For shell-script changes, run `bash -n` on each changed script, for example
  `bash -n setup.sh repo-sync.sh`.
- For `.macos` changes, run `zsh -n .macos` without applying the preferences.
- Run `git diff --check` after edits.
- For `README.md` changes, check that every in-page link `](#...)` matches a
  heading, no two headings produce the same anchor, and every relative file
  link points to an existing file.
- For Setup checklist or setup heading changes, check that the README list
  matches the first two levels of the issue template, and that the template
  covers every `###`, `####`, and `#####` heading under Setup. Compare with
  `diff` after normalizing the template: drop items indented by six or more
  spaces, remove `[ ] `, and strip the absolute README URL down to `#<anchor>`.
- Do not run `./setup.sh` as a validation step: it changes the machine by
  installing packages. Run it only when explicitly requested.
- Do not run `./repo-sync.sh` with the tracked inventory as a validation step:
  it clones many gigabytes into `~/dev/work/`. Test it from a copy with a small
  `repos/` inventory and `REPOSITORIES_DIR` set to a temporary directory.

## Local conventions

- The checkout lives at `~/dev/work/dotfiles`.
- Keep work repositories under `~/dev/work/`. `repo-sync.sh` mirrors the GitLab
  namespace, for example `~/dev/work/gitlab-org/cli`, and links `~/dev/da` to
  `~/dev/work/gitlab-da` for fast access. This checkout stays at
  `~/dev/work/dotfiles`, so do not add `dnsmichi/dotfiles` to the inventory.
- Track public-safe work identity settings, including the Git author name,
  work email address, and public signing key. Keep credentials, private keys,
  and confidential work configuration local and untracked.
