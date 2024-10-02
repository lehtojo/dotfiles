{ config, pkgs, ... }:

let
  username = "lehtojo";
  home = "/home/${username}";
in {
  home.username = "${username}";
  home.homeDirectory = "${home}";

  # Let home manager install and manage itself
  programs.home-manager.enable = true;

  # Before changing the value read the documentation
  home.stateVersion = "24.05";

  # User packages
  home.packages = [];

  # Environment variables
  home.sessionVariables = {
    EDITOR = "vim";
    DOTNET_ROOT = "${pkgs.dotnet-sdk_8}";
  };

  # GTK
  gtk.enable = true;
  gtk.theme.name = "WhiteSur-Dark";
  gtk.theme.package = pkgs.whitesur-gtk-theme;
  gtk.iconTheme.name = "Papirus-Dark";
  gtk.iconTheme.package = pkgs.papirus-icon-theme;

  # Wallpapers
  home.file.".wallpaper.jpg".source = ./wallpapers/0.jpg;

  # Neovim
  home.file.".config/nvim/init.lua".source = ./nvim/init.lua;

  # Shell
  programs.bash = {
    enable = true;
    # Unsetting "SSH_ASKPASS" seems to fix a system wide freeze when using git on Hyprland (installing and executing x11_ssh_askpass froze the system).
    # This issue did not happen on Gnome.
    initExtra = "PS1='\\u:\\w\\$ '\neval \"$(direnv hook bash)\"\nexport PATH=$PATH:${home}/.dotfiles/\nunset SSH_ASKPASS";
    shellAliases = {
      ll = "ls -la";
      ".." = "cd ..";
    };
  };

  # Git
  programs.git = {
    enable = true;
    userEmail = "joonas.eemil.lehto@gmail.com";
    userName = "Joonas Lehto";
  };

  # Virtualization
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
    };
    "org/gnome/desktop/background" = {
      picture-uri = "file://${home}/.dotfiles/wallpapers/0.jpg";
      picture-uri-dark = "file://${home}/.dotfiles/wallpapers/0.jpg";
    };
    "org/gnome/desktop/wm/keybindings" = {
      move-to-workspace-left = ["<Shift><Super>Left"];
      move-to-workspace-right = ["<Shift><Super>Right"];
      switch-to-workspace-left = ["<Control><Super>Left"];
      switch-to-workspace-right = ["<Control><Super>Right"];
    };
    "org/gnome/shell" = {
      favorite-apps = ["org.gnome.Nautilus.desktop" "firefox.desktop" "discord.desktop" "code.desktop" "org.gnome.Console.desktop"];
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = ":minimize,maximize,close";
      mouse-button-modifier = "<Alt>";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Terminal";
      command = "kgx";
      binding = "<Super>t";
    };
  };
}
