# Macbook Pro dotfiles and setup at GitLab

This repository contains everything to bootstrap my Macbook Pro.

- Current: Macbook Pro 14 inch, M1 Max, 32 GB RAM, 2021 M1 Silicon architecture.
- The previous setup for the 16 inch, 2019 model can be found [at this commit](https://gitlab.com/dnsmichi/dotfiles/-/tree/4bd8993aad5e798fff3e67365f81407bb65e5b87). The setup is explained in-depth in [dotfiles - Document and automate your Macbook setup](https://about.gitlab.com/blog/2020/04/17/dotfiles-document-and-automate-your-macbook-setup/).

The current ZSH theme is [Powerlevel10k, detailed in this blog post](https://dnsmichi.at/2022/03/11/new-zsh-theme-on-macos-powerlevel10k/).

In addition to the files stored in this repository, the following instructions are needed to fully setup a Macbook Pro.

## Preparations

### iterm2

Install iterm2 manually from the [website](https://www.iterm2.com/), drag it into the Applications folder, start it and add it to the deck.

1. Download the Dark and White profiles from this repository
1. Navigate into `Settings > Profile`.
1. At the bottom, click on `Other Actions` and select `Import JSON profiles`. Import the downloaded `Dark.json` file.
1. Mark `dark` profile and select `Other Actions > Set as default`.

Documentation for initial settings:

- Create a new profile in `Settings > Profile` named `white`
     - `Colors > Color presets > Tango Light`
     - `Session > Status bar enabled` and `Configure Status Bar`. Add `git state`, `CPU utilization`, `Memory utilization`. Click `Auto-Rainbow`.
- Repeat the settings for the `Dark` profile
- Mark `dark` profile and select `Other Actions > Set as default`.

#### Fonts for ZSH Powerline10k

Download the font files for `https://github.com/romkatv/powerlevel10k#manual-font-installation` from [fonts/](fonts/) and double-click to open them all to follow "Install Font".

Navigate to **iterm2** `Settings > Profiles > Text > Font` and search for `Meslo` to select the font. Save and restart iTerm2.

### Git (XCode)

Install it on the command line first, it will ask for permission.

```
xcode-select --install
```

### Sudo

```
sudo vim /private/etc/sudoers.d/mfriedrich

mfriedrich  ALL=(ALL) NOPASSWD: ALL
```

### Backup

Copy the following private secret files in your home directory:

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

These steps contain all the remaining setup steps: Homebrew, macOS system settings, applications. 

```
git clone https://gitlab.com/dnsmichi/dotfiles.git
cd dotfiles
```

Sync the files into the home directory.

```
./bootstrap.sh
```

Apply macOS settings. Review the file before applying.

```
./.macos
```

Install Homebrew and OhMyZSH.

```
./brew_once.sh
```

### Install tools and apps

Install tools and applications with Homebrew bundle.

```
brew bundle
```

This makes use of the [Brewfile](Brewfile) definitions.

[mas](https://github.com/mas-cli/mas) is used to install apps from the app store, and is itself installed with Homebrew first in the [Brewfile](Brewfile).

```
$ cat Brewfile

brew "mas"

...
mas "Slack", id: 803453959
```

**Note:** [GitLab uses Jamf for endpoint management](https://about.gitlab.com/handbook/business-technology/end-user-services/onboarding-access-requests/endpoint-management/jamf/) which provides a self-service application to manage essential apps. Since 2023-06, I am using this method in favor of Homebrew mas.

## Essentials

These tools are managed outside of Homebrew, and require additional work and documentation.

- [1Password 8](https://1password.com/product/mac/)
= [Zoom](https://zoom.us/download) (note the special download location for Apple M1 Silicon)
- Java 18+ Open Source
- Grammarly Desktop

### Tools

#### Chrome

For Macbook refreshments, enable the Profile sync functionality and mirror bookmarks, history, auto-completion, etc. This is essential for efficiency.

Extensions:

- [Okta](https://chrome.google.com/webstore/detail/okta-browser-plugin/glnpjglilkicbckjpbgcfkogebgllemb)
- [Zoom](https://chrome.google.com/webstore/detail/zoom-chrome-extension/kgjfgplpablkjnlkjmjdecgdpfankdle/related?hl=en)
- [1Password](https://chrome.google.com/webstore/detail/1password-%E2%80%93-password-mana/aeblfdkhhhdcdjpifhhbdiojplfjncoa)
- [Google Docs Offline](https://chrome.google.com/webstore/detail/google-docs-offline/ghbmnnjooekpmoecnnnilnnbdlolhkhi)
- [uBlock Origin](https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm)
- [Buffer](https://chrome.google.com/webstore/detail/buffer/noojglkidnpfjbincgijbaiedldjfbhh) (social media queue)
- [Window Resizer](https://chrome.google.com/webstore/detail/window-resizer/kkelicaakdanhinjdeammmilcgefonfh) (virtual screensharing that requires specific resolutions)

#### Raycast Extensions

- [Emoji search](https://www.raycast.com/FezVrasta/emoji) for [fast emoji access](https://about.gitlab.com/handbook/marketing/community-relations/developer-evangelism/social-media/#fast-emojis-workflows)

### Virtualization and Containers

I mostly use Docker and alternatives locally, required VMs run in Hetzner Cloud (private), GCP or AWS. `docker-compose` is installed separately. 

In 2022, I decided to switch to [Rancher Desktop](https://rancherdesktop.io/), and evaluate podman, nerdctl, etc. in the future. More tips can be found in the [GitLab handbook](https://about.gitlab.com/handbook/tools-and-tips/mac/#docker-desktop).

Vagrant and VirtualBox are installed for local Linux VM demos and workshops. Vagrant on Apple M1 Silicon needs Rosetta 2 being installed.

```
$ sudo softwareupdate --install-rosetta --agree-to-license
```

VirtualBox requires the developer preview for Apple Silicon M1. This cannot be managed with Homebrew. [Download and install it](https://www.virtualbox.org/wiki/Downloads).

## Preferences

These are manual settings as they require user awareness.

### FileVault

Enable Encryption ([required for GitLab team members with Jamf](https://about.gitlab.com/handbook/business-technology/end-user-services/onboarding-access-requests/endpoint-management/jamf/#why-jamf).
See [here](https://support.apple.com/en-us/HT204837) for detailed instructions.


### Keyboard

`Shortcuts`: Disable Spotlight in preparation for enabling Raycast as default shortcut using `cmd + space`.

### Raycast

Start Raycast from the Applications folder, and change the hotkey to `Cmd+Space`.
Ensure that Spotlight is disabled in the system preferences.

### Finder

Open Finder and navigate into `Settings > Sidebar` to add

- User home (user name)
- System root (Macbook name)

## Additional Applications

* Google Chrome
* JetBrains Toolbox (license required)
* NTFS for Mac (license required, I own a private license)
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

### Git xcrun errors on macOS Ventura upgrades

```
xcrun: error: invalid active developer path
```

You need to explicity agree to the terms of services for the developer tools.

```
xcode-select --install
```