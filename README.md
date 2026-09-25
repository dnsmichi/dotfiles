# Macbook Pro dotfiles and setup at GitLab

**Goal**: Bootstrap my work Macbook with software setup and settings automation.

Current hardware: Macbook Pro 14 inch, M1 Max, 32 GB RAM, 2021 M1 Silicon architecture.

Archive:

- 2026-09: The setup with Powerlevel10k is documented in [this blog post](https://dnsmichi.at/2022/03/11/new-zsh-theme-on-macos-powerlevel10k/) at [this commit](https://gitlab.com/dnsmichi/dotfiles/-/tree/701851b5cb36dc3fc2796e2e0f7fa3038fbd611a)
- 2023-05: The setup for the previous 16 inch, 2019 model can be found [at this commit](https://gitlab.com/dnsmichi/dotfiles/-/tree/4bd8993aad5e798fff3e67365f81407bb65e5b87). The setup is explained in-depth in [dotfiles - Document and automate your Macbook setup](https://about.gitlab.com/blog/2020/04/17/dotfiles-document-and-automate-your-macbook-setup/).

[TOC]

## Essentials

| Type            | Tools |
|-----------------|-------|
| Credentials     | [1Password](https://1password.com/product/mac/), [1Password for Safari/Chrome](https://apps.apple.com/us/app/1password-for-safari/id1569813296?) |
| Backup          | [Google Drive for Desktop](https://support.google.com/a/users/answer/13022292?hl=de#drive_desktop_install) |
| Agentic AI      | [Agentic AI](#agentic-ai): GitLab Duo Agent Platform, [Claude Code/Desktop](https://handbook.gitlab.com/handbook/tools-and-tips/ai/claude/), [Glean](https://handbook.gitlab.com/handbook/eta/ai/tools/glean/) |
| Containers      | [Rancher Desktop](https://rancherdesktop.io/)  |
| Browser         | [Google Chrome](https://www.google.com/chrome/), Safari |
| DevRel          | [Adobe Creative Cloud](https://www.adobe.com/creativecloud.html) (Premiere Pro, etc.) - enterprise license, [Screen Studio](https://screen.studio/download) (approved license) - [handbook](https://handbook.gitlab.com/handbook/marketing/developer-relations/developer-advocacy/content/#recording-with-screen-studio) |
| Editor          | JetBrains IDE Toolbox ([license required](https://handbook.gitlab.com/handbook/tools-and-tips/editors-and-ides/jetbrains-ides/licenses/) for IntelliJ IDEA, PyCharm, GoLand, RubyMine, CLion, RustRover, Rider, DataGrip, etc.). |

## Environment

### Git and compilers

Install Git and compilers/SDK using Xcode install.

```shell
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -license accept
```

neovim with lazyvim and treesitter requires compiling against
native SDK.

### Terminal

| Type            | Tools |
|-----------------|-------|
| Terminal app    | [Ghostty](https://ghostty.org/). [iTerm2](https://iterm2.com/) as backup |
| Shell           | ZSH and [Starship](https://starship.rs/) |
| Shell history   | [Atuin](https://atuin.sh/) in addition to ZSH history |
| Package manager | [Homebrew](https://brew.sh/) for packages, [mise](https://mise.jdx.dev/) for dev envs (NodeJs, Ruby, etc.)
| Editor          | [neovim](https://neovim.io/) |
| Agents          | [Claude Code](https://about.gitlab.com/blog/claude-code-and-gitlab/), [GitLab Duo CLI](https://docs.gitlab.com/user/gitlab_duo_cli/) |

### Package manager

#### Homebrew

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Packages are managed in [Brewfile](Brewfile).

#### Mise

```shell
curl https://mise.run | sh
~/.local/bin/mise --version
```

Globally installed language frameworks are configured in [.config/mise/config.toml](.config/mise/config.toml).
To reinstall them, run:

```shell
mise install
```

## Setup

After cloning this repository, run:

```shell
./setup.sh
```

The script checks for Xcode Command Line Tools, installs Homebrew when needed,
and applies the small [Brewfile](Brewfile).

> **Important**: `setup.sh` is safe to rerun: it installs and updates
Brewfile packages, does not modify macOS defaults, and ensures all symlinks are
in place.

Setup also links each skill under `skills/` into `~/.claude/skills/`,
`~/.agents/skills/`, and `~/.gitlab/duo/skills/` for Claude Code, Codex, and
GitLab Duo, using the same skill directory name for each tool.
Existing matching links are left in place; conflicting files or
links stop setup for review. These links expose the public skills only; personal
AI configuration stays in the home directory.

Ghostty is installed and updated directly from ghostty.org. Its tracked
configuration lives in [.config/ghostty](.config/ghostty) and uses matching
light and dark themes based on the macOS appearance setting.
The Brewfile installs JetBrainsMono Nerd Font, which provides the optional
symbols used by Starship.

Optional macOS preferences live in [.macos](.macos). Review the script before
applying it, then run:

```shell
zsh .macos
```

It covers keyboard and trackpad behavior, Finder paths and extensions, Dock
visibility, immediate authentication after sleep, screenshots, muted system
UI sounds, and the macOS application firewall. It does not change shell
startup files, power settings, hostnames, hidden system directories, or
application-specific preferences.

The reviewed GitHub CLI telemetry opt-out is applied directly by `setup.sh`
and is safe to rerun. Other privacy changes remain narrowly scoped and opt-in;
macOS preferences still require running `.macos` explicitly.

[setup.sh](setup.sh) links the tracked configuration to its destination in the HOME
directory `~`. All paths need to remain the same, e.g. `.config/starship.toml`.
If that link has been replaced with a regular file, it stops and shows a
recursive diff instead of overwriting local changes.
Merge any wanted changes into this repository, remove the local file,
and rerun the script.

## Tools and Settings

### Agentic AI

#### GitLab Duo Agent Platform

Provisioned access as team member, and Developer Advocate in [gitlab.com/gitlab-da](https://gitlab.com/gitlab-da).

#### GitLab Duo CLI

Installed via `glab` CLI in the [Brewfile](Brewfile). The [ZSH alias](.config/zsh/aliases.zsh) `duo` runs `glab duo cli`.

1. [GitLab Duo CLI in the Dev Advocacy Handbook](https://handbook.gitlab.com/handbook/marketing/developer-relations/developer-advocacy/dev-environments/#gitlab-duo-cli)
1. Add the Agentic Skills from [skills/](skills/), see README for instructions.

#### Claude Code

1. Follow the [Developer Advocacy handbook](https://handbook.gitlab.com/handbook/marketing/developer-relations/developer-advocacy/dev-environments/#claude-code)
1. Add the Agentic Skills from [skills/](skills/), see README for instructions.

#### Codex

1. Follow the [Developer Advocacy handbook](https://handbook.gitlab.com/handbook/marketing/developer-relations/developer-advocacy/dev-environments/#codex)
1. Add the Agentic Skills from [skills/](skills/), see README for instructions.

### Glean

Follow the [handbook](https://handbook.gitlab.com/handbook/eta/ai/tools/glean/) for access and setup.

### Productivity

#### Neovim with LazyVim

Started off a fresh git clone following https://www.lazyvim.org/installation

Modified [.config/nvim](.config/nvim) and symlinked into HOME. The editor uses the
Gruvbox hard-contrast theme and follows the macOS light/dark appearance setting,
matching the Ghostty themes.

Note: lazyvim uses treesitter which requires a compiler/SDK match with
full XCode installation.

#### ZSH history with Atuin

Press `Ctrl-R` to search history with Atuin. Up and Down keep Zsh's native
history navigation. [Native history settings](.config/zsh/history.zsh) save
commands incrementally to `~/.zsh_history`, without importing commands from
other active terminal sessions into the current shell.

Import existing history with

```shell
atuin import auto
```

#### ZSH completion and editor

[Completion settings](.config/zsh/completions.zsh) load Homebrew completions
and initialize Zsh's completion system. Tab offers case-insensitive matching,
then partial and substring matching, with selectable, grouped results.
The completion cache lives under `${XDG_CACHE_HOME:-$HOME/.cache}/zsh`.

`.zshrc` loads history, completion, aliases, and functions explicitly, followed
by tool integrations. Syntax highlighting loads last. `EDITOR` and `VISUAL`
are both set to `nvim` for commands that open an external editor.

#### Sudo

```shell
sudo vim /private/etc/sudoers.d/mfriedrich

mfriedrich ALL=(ALL) NOPASSWD: ALL
```

#### TinyCast - launcher and emoji picker

[TinyCast](https://tinycast.dev/) is installed through Homebrew in [Brewfile](Brewfile). It provides app
launcher, search and emoji picker as a Spotlight alternative. The current shortcuts are:

- `Cmd+Space` launches TinyCast.
- `Cmd+2` opens the emoji picker.

On a fresh macOS setup:

1. Open `Settings > Keyboard > Keyboard Shortcuts`.
1. Disable the Spotlight shortcuts so `Cmd+Space` can launch TinyCast.
1. Start TinyCast and confirm its launcher shortcut is `Cmd+Space`.
1. Open TinyCast, search for **Settings**, and open it.
1. Select **Emoji & Symbols**.
1. Enable **Search Emoji & Symbols**, click its shortcut field, and press `Cmd+2`.

#### VS Code

Install VS Code manually so its own updater controls its release cycle. Its user settings are tracked in
[.config/vscode/settings.json](.config/vscode/settings.json). `setup.sh` links that
file to VS Code's macOS user-settings location.
The editor follows macOS light and dark appearance automatically, using the built-in
Light Modern and Dark Modern themes.

The tracked inventory lives in [vscode/extensions.txt](vscode/extensions.txt). After
installing VS Code and any extensions manually, discover what is present with:

```shell
bash ./vscode-extensions-install.sh --discover
```

Review the result, then update the tracked inventory from the installed set with:

```shell
bash ./vscode-extensions-install.sh --update-inventory
```

Run the script without an option to install the tracked inventory on another Mac.
Review the generated inventory before committing it; manually installed extensions
can be adopted later without changing the script.

#### Settings

**1Password** overrides the screenshot shortcut `cmd+shift+4+space` by default with `shift+cmd+space`.
Clear it in `1Password → Settings → General → Global keyboard shortcuts → Show Quick Access`.

#### Ghostty

If Ghostty needs to remove protected application data, such as leftover
files under `~/Library/`, grant it access in:

`System Settings > Privacy & Security > Full Disk Access`

Enable Ghostty, restart it, and rerun the cleanup command. `sudo` alone cannot
bypass macOS privacy protection for these directories.

#### Finder

Open Finder and navigate into `Settings > Sidebar` to add

- User home (user name)
- System root (Macbook name)

#### Zoom

https://handbook.gitlab.com/handbook/tools-and-tips/zoom/

`Settings > General`: Untick `Ask me to confirm when I leave a meeting`.
`Settings > Audio`: Tick `Mute my mic when joining`.
`Settings > Keyboard Shortcuts`: Mute/Unmute my audio: `cmd 1`.

## Backup

Use Google Drive for Desktop, Chrome profile sync, and 1Password for credentials/SSH keys.

Keep personal `.codex`, `.claude`, and `.cursor` configuration in the home
directory and private backups. Do not symlink these configurations into this
public repository. Public, reusable skills can stay in `skills/`.

Close applications that write to these directories before copying. Run this
from the home directory, adjusting the source list for files that exist on the
machine. Each backup gets a new directory outside the repository:

```shell
cd "$HOME"
umask 077
backup_dir="$HOME/backup/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir/home"
cp -RL .ssh .gnupg .env .claude .codex .cursor .agents .config \
  .zsh_history .claude.json .ansible "$backup_dir/home/"
```

`cp -RL` copies the files behind symlinks, including linked dotfiles and skills.
Review any copy errors before continuing; running applications can leave sockets
that cannot be copied. This is a backup of the selected paths, not the whole home
directory.

Create a tarball, then encrypt it with `7z` from the Brewfile's `p7zip` package:

```shell
tar -czf "$backup_dir/home.tar.gz" -C "$backup_dir" home
7z a -t7z -mhe=on -p "$backup_dir/home.tar.gz.7z" "$backup_dir/home.tar.gz"
7z t "$backup_dir/home.tar.gz.7z"
```

Enter a strong password at the prompt and save it in 1Password. Upload only
`home.tar.gz.7z` to Google Drive after verification succeeds. The copied `home/`
directory and `home.tar.gz` contain unencrypted private keys, credentials, and
application data; keep the staging directory outside Google Drive and remove
those unencrypted copies after checking the backup.

To verify a restore, download the encrypted archive and extract it into a new
local directory. Replace the archive path below with the downloaded file:

```shell
restore_dir="$(mktemp -d "$HOME/backup/restore.XXXXXX")"
7z x /path/to/home.tar.gz.7z -o"$restore_dir"
tar -xzf "$restore_dir/home.tar.gz" -C "$restore_dir"
```

Inspect the restored files in `"$restore_dir/home"` before copying anything back
into the home directory.

## Development

### GitLab Development Kit (GDK)

Follow the [one-line installation](https://gitlab.com/gitlab-org/gitlab-development-kit/-/tree/main/doc?ref_type=heads#one-line-installation) and use [mise](https://gitlab.com/gitlab-org/gitlab-development-kit/-/blob/main/doc/howto/mise.md) (requirement since 2025-04).

Alternatively, use [GDK-in-a-box](https://docs.gitlab.com/development/contributing/first_contribution/configure-dev-env-gdk-in-a-box/) with Docker containers.

### GitLab Docs

The CI/CD pipelines for GitLab docs use [linting](https://docs.gitlab.com/ee/development/documentation/testing.html#install-linters) which can be installed locally to test problems faster.

```shell
yarn global add markdownlint-cli2
yarn global add markdownlint-cli

mise plugin add vale && mise install vale
```

The [VS Code editor integration](https://docs.gitlab.com/ee/development/documentation/testing.html#configure-editors) is managed through [vscode-extensions-install.sh](vscode-extensions-install.sh).

```shell
cd ~/dev/work/gitlab-org/gitlab

yarn install

./scripts/lint-doc.sh
```

## Troubleshooting

### Zsh warns about insecure completion directories

When opening Ghostty, Zsh may prompt:

```text
zsh compinit: insecure directories, run compaudit for list.
Ignore insecure directories and continue [y] or abort compinit [n]?
```

Run the following to identify the affected directories:

```shell
autoload -Uz compaudit
compaudit
```

On this workstation, `/opt/homebrew/share` was owned by the current user but
group-writable. Check its permissions and remove group write access:

```shell
ls -ld /opt/homebrew/share
chmod g-w /opt/homebrew/share
```

Run `compaudit` again; no output means the check passed. Open a new Ghostty
tab to confirm completion initializes without prompting. This fix needs no
`sudo`, recursive permission changes, or completion-cache deletion.

If the audit lists different paths, inspect their ownership and permissions
before changing them. Keep the normal `compinit` security checks enabled.
See [Homebrew's Zsh completion guidance](https://docs.brew.sh/Shell-Completion#zsh).

### DNS troubleshooting

If DNS causes problems on macOS:

```shell
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder
sudo killall -9 mDNSResponder
```

### Homebrew binary incompatibilities after macOS upgrades

On major version upgrades, binaries might be incompatible or need a local rebuild.
You can enforce a reinstall by running the two commands below, the second command
only reinstalls all application casks.

```shell
brew reinstall $(brew list)

brew reinstall $(brew list --cask)
```

When Xcode and compilers break, re-install the command line tools.

```shell
sudo rm -rf /Library/Developer/CommandLineTools
sudo xcode-select --install
```

### Git xcrun errors on macOS Ventura upgrades

```shell
xcrun: error: invalid active developer path
```

You need to explicity agree to the terms of services for the developer tools.

```shell
xcode-select --install
```

### Settings do not work after upgrades

The settings in [.macos](.macos) use macOS internal APIs on the command line. Sometimes the configuration settings change, for example with the Trackpad on macOS Ventura. To debug and capture which settings are in effect, create a new Git repository somewhere, and persist the system settings output.

```shell
mkdir $HOME/dev/work/system-settings
cd $HOME/dev/work/system-settings
git init

defaults read > settings.txt

git add settings.txt
git commit -av -m "Initial settings"
```

Then navigate into the Systems settings GUI, change parameters, export the system settings into the same file, and analyze the Git diff to figure out the correct parameter names and values.

```shell
defaults read > settings.txt

git diff
```

Example from [June 2023](https://gitlab.com/dnsmichi/dotfiles/-/commit/f16809989ba2d65fc73e1274356b6f2c6cfde1db)

## Thanks

- Starship Gruvbox Rainbow preset https://starship.rs/presets/gruvbox-rainbow
- [.macos](.macos) inspiration
  - [Setting examples](https://github.com/mathiasbynens/dotfiles/blob/master/.macos)
  - [macos Ventura settings](https://github.com/gretzky/dotfiles/blob/main/macos/.macos)
  - [command overview](https://github.com/herrbischoff/awesome-macos-command-line).

## Contributing

The main repository is hosted on GitLab.com, mirrored to GitHub.com: https://gitlab.com/dnsmichi/dotfiles
