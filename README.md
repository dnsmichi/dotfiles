# Macbook Pro dotfiles and setup at GitLab

This repository contains everything to bootstrap my Macbook Pro (16 inch, 2019).

> **Note**: The old version is located [here](https://github.com/dnsmichi/dotfiles).
>
> The new version focuses on using macOS Catalina defaults such as ZSH.
> Development environments are not necessarily installed locally but in Docker or in the cloud.

In addition to the files stored in this repository, the following
instructions are needed to fully setup a Macbook Pro.

## Upgrades

On major version upgrades from Catalina to future versions, ensure to re-install all Homebrew binaries.

```
brew reinstall $(brew list)

brew cask install --force $(brew cask list)
```

When Xcode and compilers break, re-install the command line tools.

```
xcode-select --install
```

## Preparations

### iterm2

Install it manually from the [website](https://www.iterm2.com/), start it and add it to the deck.

Initial settings:

- Create a new profile in `Preferences > Profile` named `white`
     - `Colors > Color presets > Tango Light`
     - `Session > Status bar enabled` and `Configure Status Bar`. Add `git state`, `CPU utilization`, `Memory utilization`. Click `Auto-Rainbow`.
- Mark `white` profile and select `Other Actions > Set as default`.

### Homebrew

Install it once.

```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

### Sudo

Note: I keep this disabled for improved security, though some sessions may require heavy sudo usage.

```
sudo vim /private/etc/sudoers.d/mfriedrich

#mfriedrich  ALL=(ALL) NOPASSWD: ALL
```

### Backup

Copy the following files in your home directory:

* SSH Keys
* GPG Keys
* GitHub/GitLab Tokens
* SSH Aliases in `.zsh_aliases`

```
cd backup/
cp -r .ssh .gnupg .github_tokens .gitlab_tokens .zsh_aliases $HOME/
```

### Dot files

```
git clone https://gitlab.com/dnsmichi/dotfiles.git
cd dotfiles
./bootstrap.sh
./.macos
./brew_once.sh
./brew.sh
```

Note: `brew.sh` can be re-run later on, ensuring the same state.

## Essentials

### Tools

These tools are managed without Homebrew on purpose, e.g. for manual updates.

* Workflows: [Alfred](https://www.alfredapp.com/) including my Powerpack license

#### Virtualization

* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)


## System Preferences

### Keyboard

`Keyboard`: Enable tab-tab for everything.

`Shortcuts`: Disable Spotlight.


### Trackpad

`Point & Click > Secondary click` and select `Click in bottom right corner`.

### Security & Privacy

- Turn on Filevault and encrypt everything, if not done during the setup
- Turn on the firewall

### Time Machine

**TODO:** Get a backup drive.


## User Preferences

### Alfred

Start Alfred from the Applications folder, and change the hotkey to `Cmd+Space`.
Ensure that Spotlight is disabled in the system preferences.

### Finder

`Preferences > Sidebar` and add

- User home
- System root

### Mail

`Preferences > General`:

- `New messages sound`: None
- `Play sounds for other mail actions`: unticked

`Preferences > Viewing`:

- `Show most recent message at the top`: ticked


## Additional Applications

* Google Chrome
* Docker (account required)
* JetBrains Toolbox (license required)
* NTFS for Mac (license required, I own a private license)
* Paw (license required, I own a private license)
* Spotify (account required)
* Telegram (account required)

### Homebrew

* Atom
* Firefox (in order to reproduce UX bugs)
* VLC
* Wireshark


