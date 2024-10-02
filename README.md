# Desktop Configuration

## Installation
- Place this repository **exactly** at `~/.dotfiles`
- **Merge** [configuration.nix](./configuration.nix) into existing configuration at `/etc/nixos/configuration.nix`
- Rebuild the system by running `sudo nixos-rebuild switch`
- Setup [Home Manager](https://nix-community.github.io/home-manager/) (Standalone)
- Update desktop by running `update.sh` in `~/.dotfiles`

## Manual
- Firefox
  - Login into Mozilla and Google
  - Disable "widget.gtk.non-native-titlebar-buttons.enabled" in "about:config"
- Visual Studio Code
  - Login
