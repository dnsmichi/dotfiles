# Macbook Pro dotfiles and setup at GitLab

This repository contains everything to bootstrap my Macbook Pro (16 inch, 2019). This setup is explained in-depth in [dotfiles - Document and automate your Macbook setup](https://about.gitlab.com/blog/2020/04/17/dotfiles-document-and-automate-your-macbook-setup/).

In addition to the files stored in this repository, the following instructions are needed to fully setup a Macbook Pro.

## Preparations

### iterm2

Install it manually from the [website](https://www.iterm2.com/), start it and add it to the deck.

Initial settings:

- Create a new profile in `Preferences > Profile` named `white`
     - `Colors > Color presets > Tango Light`
     - `Session > Status bar enabled` and `Configure Status Bar`. Add `git state`, `CPU utilization`, `Memory utilization`. Click `Auto-Rainbow`.
- Mark `white` profile and select `Other Actions > Set as default`.

### Git (XCode)

Install it on the command line first, it will ask for permission.

```
xcode-select --install
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

Install tools and applications with Homebrew bundle.

```
brew bundle
```

This makes use of the [Brewfile](Brewfile) definitions.

## Essentials

### Tools

#### Raycast Extensions

- [Emoji search](https://www.raycast.com/FezVrasta/emoji) for [fast emoji access](https://about.gitlab.com/handbook/marketing/community-relations/developer-evangelism/social-media/#fast-emojis-workflows)
- [GitLab](https://www.raycast.com/tonka3000/gitlab)
- [Weather](https://www.raycast.com/tonka3000/weather)
- [Speedtest](https://www.raycast.com/tonka3000/speedtest)

### Virtualization and Containers

I only use Docker locally, required VMs run in Hetzner Cloud (private), GCP or AWS. Docker for Mac provides the `docker-compose` binary required to run demo environments. 

VirtualBox needs work with Kernel modules. I highly recommend to get a [Parallels license](https://www.parallels.com/de/products/desktop/buy/) instead. 

## Preferences

These are manual settings as they require user awareness.

### FileVault

Enable Encryption ([required for GitLab team members](https://about.gitlab.com/handbook/business-ops/team-member-enablement/onboarding-access-requests/#full-disk-encryption) and recommended for everyone).
See [here](https://support.apple.com/en-us/HT204837) for detailed instructions.

CLI:

```
sudo fdesetup status

sudo fdesetup enable
```


### Keyboard

`Shortcuts`: Disable Spotlight in preparation for enabling Raycast as default shortcut using `cmd + space`.

### Raycast

Start Raycast from the Applications folder, and change the hotkey to `Cmd+Space`.
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

* Firefox (in order to reproduce UX bugs)
* VLC
* Wireshark

## Additional Hints

More insights can be found in these lists:

- [Setting examples](https://github.com/mathiasbynens/dotfiles/blob/master/.macos)
- [command overview](https://github.com/herrbischoff/awesome-macos-command-line).


## Upgrades

On major version upgrades, binaries might be incompatible or need a local rebuild. 
You can enforce a reinstall by running the two commands below, the second command
only reinstalls all application casks.

```
brew reinstall $(brew list)

brew reinstall $(brew list --cask)
```

When Xcode and compilers break, re-install the command line tools.

```
sudo rm -rf /Library/Developer/CommandLineTools
sudo xcode-select --install
```
