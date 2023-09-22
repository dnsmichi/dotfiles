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

Powerlevel10k fonts for Oh-My-ZSH terminal:

1. Download the font files from https://github.com/romkatv/powerlevel10k#manual-font-installation (backup in [fonts/](fonts/)). 
1. Double-click to open them all to follow "Install Font".

#### Security app permissions for iTerm2

Navigate into `Settings > Security and Privacy > App Management` and allow iTerm2 to modify apps. Otherwise you will see this warning on macOS Ventura 13.4.1. 

```
Warning: Your terminal does not have App Management permissions, so Homebrew will delete and reinstall the app.
This may result in some configurations (like notification settings or location in the Dock/Launchpad) being lost.
To fix this, go to Settings > Security and Privacy > App Management and turn on the switch for your terminal.
```

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

Use Google drive and Chrome profile sync to migrate backup data.

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

#### VS Code

Configuration: [vscode/settings.json](vscode/settings.json) (cmd shift p, search for `settings json`).

Initial setup:

```shell
cp vscode/settings.json ~/Library/Application\ Support/Code/User/
```

Notable changes from the default configuration:

1. Auto-save enabled: `"files.autoSave": "afterDelay",`
1. Word-wrap enabled: `"editor.wordWrap": "on",`
1. Change font family to `meslolgs nf` to [print ZSH icons in the VS Code terminal](https://stackoverflow.com/questions/73528388/vscode-terminal-not-showing-icons-on-terminal-on-zsh): `"terminal.integrated.fontFamily": "meslolgs nf",`
1. GitLab Duo Code Suggestions enabled: `"gitlab.aiAssistedCodeSuggestions.enabled": true,`
1. GitLab Workflow extension debug enabled: `"gitlab.debug": true,`


Sync:

```shell
cp ~/Library/Application\ Support/Code/User/settings.json vscode/ 
```

##### VS Code Extensions

Run the following script to install VS Code extensions:

```
./vscode-extensions-install.sh
```

You can regenerate the list of extensions using the following command:

```
code --list-extensions | xargs -L 1 echo code --install-extension > vscode-extensions-install.sh
```

#### asdf

[asdf](https://asdf-vm.com/) is installed with [Homebrew](Brewfile) and helps manage different programming languages and environments.

NodeJS:
```
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf list all nodejs
asdf install nodejs 20.3.0
asdf local nodejs 20.3.0
```


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

Open the extensions and record keyboard shortcut commands. I use the emoji search very extensively, and have recorded cmd + ` for faster access.

### Virtualization and Containers

CLI Tools:

1. [Rancher Desktop](https://rancherdesktop.io/) (provides local Kubernetes, and `docker` compatible CLI) - **manual download**
1. `docker-compose`, `vagrant`, `lima`, `podman` via [Brewfile](Brewfile)

Cloud:

CLI tools managed with Homebrew in [Brewfile](Brewfile): Google Cloud, AWS, Hetzner Cloud, Civo Cloud.

Kubernetes clusters are managed in GKE, GitLab community group.

In 2022, I decided to switch to [Rancher Desktop](https://rancherdesktop.io/), and evaluate podman, nerdctl, etc. in the future. More tips can be found in the [GitLab handbook](https://about.gitlab.com/handbook/tools-and-tips/mac/#docker-desktop).

Vagrant and Lima are installed for local Linux VM demos and workshops. Vagrant on Apple M1 Silicon needs Rosetta 2 being installed.

```
$ sudo softwareupdate --install-rosetta --agree-to-license
```

I prefer [lima](https://lima-vm.io/) for Linux VM management, for example in https://gitlab.com/gitlab-de/workshops/observability/learn-ebpf-2023 

**Note**: VirtualBox requires the developer preview for Apple Silicon M1. This cannot be managed with Homebrew. [Download and install it](https://www.virtualbox.org/wiki/Downloads), it may contain bugs and is far from production ready: https://forums.virtualbox.org/viewtopic.php?f=8&t=107344 2023-06-06 status: Cannot boot Ubuntu 23.04 via Vagrant. 


## Settings

These are manual settings as they require user awareness.

### FileVault

Enable Encryption ([required for GitLab team members with Jamf](https://about.gitlab.com/handbook/business-technology/end-user-services/onboarding-access-requests/endpoint-management/jamf/#why-jamf).
See [here](https://support.apple.com/en-us/HT204837) for detailed instructions.

### 1Password

1Password8 overrides the screenshot shortcut `cmd+shift+4+space` by default. Replace it with something else, or clear it in `Settings > General > Keyboard Shortcuts`. 

#### AWS CLI auth with 1Password CLI and Touch ID

Follow https://developer.1password.com/docs/cli/shell-plugins/aws/ to

1. Install the 1Password CLI
2. Connect 1Password CLI with the 1Password app
3. Run `op signin` and `op plugin init aws`

The required ZSH environment is sourced via [.oh-my-zsh/custom/1password.zsh](.oh-my-zsh/custom/1password.zsh). 

### Keyboard

`Settings > Keyboard > Keyboard Shortcuts`:

1. Disable all Spotlight options in preparation for enabling Raycast as default shortcut using `cmd + space`.

### Raycast

Start Raycast from the Applications folder in Finder, and change the hotkey to `Cmd+Space`.
Ensure that Spotlight is disabled in the system preferences.

### Finder

Open Finder and navigate into `Settings > Sidebar` to add

- User home (user name)
- System root (Macbook name)

### Zoom

https://handbook.gitlab.com/handbook/tools-and-tips/zoom/

`Settings > General`: Untick `Ask me to confirm when I leave a metting`
`Settings > Audio`: Mute my mic when joining
`Settings > Keyboard Shortcuts`: Mute/Unmute my audio: `cmd 1`.

## Additional Applications

* Google Chrome
* JetBrains Toolbox (license required)
* NTFS for Mac (license required, I own a private license)
* Spotify (account required)
* Telegram (account required)

### Handbook

Following the [GitLab tools and tipshandbook](https://handbook.gitlab.com/handbook/tools-and-tips/).


### Homebrew

Managed as casks in [Brewfile](Brewfile).

* Firefox (in order to reproduce UX bugs)
* VLC
* Wireshark


## Additional Hints

### iterm2

Documentation for initial settings:

1. Create a new profile in `Settings > Profile` named `Dark`
     - `Colors > Color presets > Dark background`
     - `Session > Status bar enabled` and `Configure Status Bar`. Add `git state`, `CPU utilization`, `Memory utilization`. Click `Auto-Rainbow`.
1. Mark `dark` profile and select `Other Actions > Set as default`.
1. Export the Dark profile as JSON and upload into the [iterm2](iterm2/) directory. 

#### Font config for ZSH Powerline10k

> **Note**: This is persisted in the iterm2 profile already.


Navigate to **iterm2** `Settings > Profiles > Text > Font` and search for `Meslo` to select the font. Save and restart iTerm2.


### Other projects

More insights can be found in these lists:

- [Setting examples](https://github.com/mathiasbynens/dotfiles/blob/master/.macos)
- [macos Ventura settings](https://github.com/gretzky/dotfiles/blob/main/macos/.macos)
- [command overview](https://github.com/herrbischoff/awesome-macos-command-line).

## Development

### GitLab Development Kit (GDK)

Follow the [one-line installation](https://gitlab.com/gitlab-org/gitlab-development-kit/-/tree/main/doc?ref_type=heads#one-line-installation) and use asdf (requirement).

### GitLab Docs

The CI/CD pipelines for GitLab docs use [linting](https://docs.gitlab.com/ee/development/documentation/testing.html#install-linters) which can be installed locally to test problems faster.

```
yarn global add markdownlint-cli2
yarn global add markdownlint-cli

asdf plugin add vale && asdf install vale
```

The [VS Code editor integration](https://docs.gitlab.com/ee/development/documentation/testing.html#configure-editors) is managed through [vscode-extensions-install.sh](vscode-extensions-install.sh).

```shell
cd ~/dev/work/gitlab-org/gitlab

yarn install 

./scripts/lint-doc.sh
```


### GitLab CLI

Install Golang to setup the [development environment](https://gitlab.com/gitlab-org/cli/-/blob/main/CONTRIBUTING.md). Export the variables `GITLAB_TOKEN` and `GITLAB_TEST_HOST` to run all integration tests.

```
export GITLAB_TOKEN=xxx
# GitLab CLI dev tests
# https://gitlab.com/dnsmichi/test
export GITLAB_TEST_HOST=https://gitlab.com
```

```shell
make
make test
```

## DevSecOps

Anything that runs in the infrastructure and needs to be automated.

### Linux VM Upgrades via Ansible

See [ansible/](ansible/) for details.

## Upgrades


### Homebrew 

### Oh-my-ZSH and Themes

```
cd ~/.oh-my-zsh
git pull

cd ~/.oh-my-zsh/custom/themes/powerlevel10k
git pull
```

### Troubleshooting

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

### Settings do not work after upgrades

The settings in [.macos](.macos) use macOS internal APIs on the command line. Sometimes the configuration settings change, for example with the Trackpad on macOs Ventura.

To debug and capture which settings are in effect, create a new Git repository somewhere, and persist the system settings output.

```
mkdir $HOME/dev/work/system-settings
cd $HOME/dev/work/system-settings
git init

defaults read > settings.txt

git add settings.txt
git commit -av -m "Initial settings"
```

Then navigate into the Systems settings GUI, change parameters, export the system settings into the same file, and analyze the Git diff to figure out the correct parameter names and values.

```
defaults read > settings.txt

git diff
```

Example with Trackpad and right-click:

```diff
     "com.apple.AppleMultitouchTrackpad" =     {
         ActuateDetents = 1;
-        Clicking = 0;
+        Clicking = 1;
         DragLock = 0;
         Dragging = 0;
         FirstClickThreshold = 1;
         ForceSuppressed = 0;
         SecondClickThreshold = 1;
-        TrackpadCornerSecondaryClick = 0;
+        TrackpadCornerSecondaryClick = 2;
         TrackpadFiveFingerPinchGesture = 2;
         TrackpadFourFingerHorizSwipeGesture = 2;
         TrackpadFourFingerPinchGesture = 2;
@@ -463,7 +464,7 @@
         TrackpadHorizScroll = 1;
         TrackpadMomentumScroll = 1;
         TrackpadPinch = 1;
-        TrackpadRightClick = 1;
+        TrackpadRightClick = 0;
         TrackpadRotate = 1;
         TrackpadScroll = 1;
         TrackpadThreeFingerDrag = 0;
```

Requiring the current settings to be changed to https://gitlab.com/dnsmichi/dotfiles/-/commit/f16809989ba2d65fc73e1274356b6f2c6cfde1db in June 2023.

### Touch ID does not work

The magic keyboard with Touch ID does not work after the Macbook went to sleep.

- https://www.reddit.com/r/mac/comments/13hd4aa/magic_keyboard_with_touch_id_no_working_after/
- https://www.reddit.com/r/macmini/comments/12cw4mf/touch_id_issues_on_mac_mini_m2/ 
- https://support.apple.com/en-us/HT212225#:~:text=For%20Magic%20Keyboard%20with%20Touch,Restart%20your%20Mac 
