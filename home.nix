{ config, pkgs, ... }:

let
  username = "lehtojo";
  homeFolder = "/home/${username}";
in {
  home.username = "${username}";
  home.homeDirectory = "${homeFolder}";

  # Allow unfree packages such as VS Code
  nixpkgs.config.allowUnfree = true;

  # Let home manager install and manage itself
  programs.home-manager.enable = true;

  # Before changing the value read the documentation
  home.stateVersion = "24.05";

  # User packages
  home.packages = with pkgs; [
    android-studio
    gnome.gnome-tweaks
  ];

  # Environment variables
  home.sessionVariables = {
    EDITOR = "vim";
    DOTNET_ROOT = "${pkgs.dotnet-sdk_8}";
    XCURSOR_THEME = "We10XOS Cursors";
    XCURSOR_SIZE = "24";
  };

  # GTK
  gtk.enable = true;

  programs.gnome-shell = {
    enable = true;
    extensions = [
      { package = pkgs.gnomeExtensions.dash-to-dock; }
      { package = pkgs.gnomeExtensions.user-themes; }
      { package = pkgs.gnomeExtensions.blur-my-shell; }
    ];
  };

  # VS Code
  programs.vscode = {
    enable = true;
    extensions = with pkgs; [
      vscode-extensions.vscodevim.vim # Vim
      # C#:
      vscode-extensions.ms-dotnettools.csharp
      vscode-extensions.ms-dotnettools.vscode-dotnet-runtime
      # Rust:
      vscode-extensions.rust-lang.rust-analyzer
      vscode-extensions.vadimcn.vscode-lldb
    ];
  };

  # Neovim
  home.file.".config/nvim/init.lua".source = ./nvim/init.lua;

  # Icons
  home.file.".icons/cursors" = {
    source = ./cursors;
    recursive = true;
  };

  # Themes
  home.file.".themes" = {
    source = ./themes;
    recursive = true;
  };

  # Shell
  programs.bash = {
    enable = true;
    # Unsetting "SSH_ASKPASS" seems to fix a system wide freeze when using git on Hyprland (installing and executing x11_ssh_askpass froze the system).
    # This issue did not happen on Gnome.
    initExtra = ''
      PS1='\u:\w\$ '
      eval "$(direnv hook bash)"
      export PATH=$PATH:${homeFolder}/.dotfiles/
      unset SSH_ASKPASS
      export GITHUB_TOKEN=$(cat ~/github-access-token)
    '';
    shellAliases = {
      ll = "ls -la";
      gs = "git status";
      gc = "git commit";
      gps = "git push";
      gpl = "git pull";
      ed = "nvim";
      exp = "xdg-open .";
      suggest = "gh copilot suggest";
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
      color-scheme = "default";
      icon-theme = "Colloid";
    };
    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
    };
    "org/gnome/desktop/background" = {
      picture-uri = "file://${homeFolder}/.dotfiles/wallpapers/2.jpg";
      picture-uri-dark = "file://${homeFolder}/.dotfiles/wallpapers/2.jpg";
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
    "org/gnome/desktop/interface" = {
      enable-animations = false;
      show-battery-percentage = true;
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
    "org/gnome/settings-daemon/plugins/power" = {
      power-saver-profile-on-low-battery = true;
    };
    "org/gnome/desktop/session" = {
      idle-delay = 600;
    };
    "org/gnome/Console" = {
      theme = "auto";
    };
    "org/gnome/shell/extensions/user-theme" = {
      name = "Marble-pink-light";
    };
    "org/gnome/shell/extensions/dash-to-dock" = {
      apply-custom-theme = false;
      transparency-mode = "FIXED";
      running-indicator-style = "DASHES";
      isolate-workspaces = true;
      show-show-apps-button = false;
      custom-background-color = true;
      background-color = "rgb(255,255,255)";
    };
    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      blur = false;
    };
  };
}
