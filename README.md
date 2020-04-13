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
* GitHub/GitLab Tokens in `.env`
* Custom settings for OhMyZSH

```
cd backup/
cp -r .ssh .gnupg .env .oh-my-zsh $HOME/
```

> **Note**:
>
> The `dotenv` plugin is enabled in OhMyZSH which automatically
> reads the `.env` tokens from the user's home directory.

### Dot files

```
git clone https://gitlab.com/dnsmichi/dotfiles.git
cd dotfiles
```

Sync the files.

```
./bootstrap.sh
```

Apply macOS settings.

```
./.macos
```

Install Homebrew and OhMyZSH.

```
./brew_once.sh
```

Install tools and applications with Homebrew.

```
./brew.sh
```

Note: `brew.sh` can be re-run later on, ensuring the same state.

## Essentials

### Tools

These tools are managed without Homebrew on purpose, e.g. for manual updates.

* Workflows: [Alfred](https://www.alfredapp.com/) including my Powerpack license
  * [HTTP Status Codes](https://github.com/ilstar/http_status_code)
  * [DNS: Dig](https://github.com/phallstrom/AlfredDig)
  * [Colors](https://github.com/zenorocha/alfred-workflows#colors-v202--download)
  * [Emoji](https://github.com/carlosgaldino/alfred-emoji-workflow)
  * [Encode/Decode](https://github.com/zenorocha/alfred-workflows#encodedecode-v180--download)
  * [Gmail](https://github.com/fniephaus/alfred-gmail)
  * [Gmail filters](https://github.com/inlet/alfred-workflow-gmail-filters)
  * [Sketch](https://madbitco.github.io/sketchflow/)
  * [Google Translate](https://github.com/xfslove/alfred-google-translate)
  * [Python Library](https://gitlab.com/deanishe/alfred-workflow)


#### Virtualization

* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)


## Preferences

### FileVault

Enable Encryption (required for GitLab employees and recommended for everyone).
See [here](https://support.apple.com/en-us/HT204837) for detailed instructions.

### Firewall

Enable it.

### Keyboard

`Shortcuts`: Disable Spotlight in preparation for enabling Alfred next.

### Alfred

Start Alfred from the Applications folder, and change the hotkey to `Cmd+Space`.
Ensure that Spotlight is disabled in the system preferences.

### Finder

`Preferences > Sidebar` and add

- User home
- System root

## Additional Applications

* Google Chrome
* Docker (account required)
* JetBrains Toolbox (license required)
* NTFS for Mac (license required, I own a private license)
* Paw (license required, I own a private license)
* Spotify (account required)
* Telegram (account required)

### Handbook

Following the [GitLab handbook](https://about.gitlab.com/handbook/tools-and-tips/):

* [Loom](https://www.loom.com/)


### Homebrew

* Atom
* Firefox (in order to reproduce UX bugs)
* VLC
* Wireshark


