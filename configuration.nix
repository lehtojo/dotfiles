{ config, pkgs, ... }:

let
  username = "lehtojo";
in
{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "${username}";
  networking.networkmanager.enable = true;

  # Time & Internationalisation 
  time.timeZone = "Europe/Helsinki";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fi_FI.UTF-8";
    LC_IDENTIFICATION = "fi_FI.UTF-8";
    LC_MEASUREMENT = "fi_FI.UTF-8";
    LC_MONETARY = "fi_FI.UTF-8";
    LC_NAME = "fi_FI.UTF-8";
    LC_NUMERIC = "fi_FI.UTF-8";
    LC_PAPER = "fi_FI.UTF-8";
    LC_TELEPHONE = "fi_FI.UTF-8";
    LC_TIME = "fi_FI.UTF-8";
  };

  # Windowing system & Desktop Environment
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true; # Use Gnome Desktop

  # Autologin
  # Note: Disk encryption and lock screen are being used
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "lehtojo";

  # Autologin fix?
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Keyboard
  services.xserver.xkb = {
    layout = "fi";
    variant = "nodeadkeys";
  };

  console.keyMap = "fi";

  # Enable CUPS to print documents
  services.printing.enable = false;

  # Sound
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;

    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    #jack.enable = true; # JACK applications?
  };

  # Touchpad (enabled by default in most cases)
  # services.xserver.libinput.enable = true;

  # User account (use passwd to set password)
  users.users."${username}" = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    packages = with pkgs; [
       android-tools
       clang_18 # C++ Compiler
       cmake # C/C++ Build Tool
       discord # Chat App
       dotnet-sdk_8 # C# Compiler
       gdb # Debugger
       gcc14 # C++ Compiler
       gh # Github CLI
       gnumake # C/C++ Build Tool
       lua-language-server # Lua LSP for Neovim
       neofetch # System Info CLI
       neovim # Code Editor (CLI)
       nodejs_22 # JS Development Tool
       nodePackages.typescript-language-server # Typescript LSP for Neovim
       omnisharp-roslyn # C# LSP for Neovim
       libvirt # Virtualization Library
       qemu # Virtual Machine
       qemu_kvm # Virtual Machine
       papirus-icon-theme # Icon Theme
       python312Full # Python
       pyright # Python LSP for Neovim
       ripgrep # Utility for searching files with text
       ruff-lsp # Python LSP for Neovim
       rustup # Rust
       rust-analyzer # Rust LSP for Neovim
       speedcrunch # Calculator App
       stunnel # SSL/TLS Wrapper
       tmux # Terminal Multiplexer
       virt-manager # Virtual Machine Manager
       vscode # Code Editor
       whitesur-gtk-theme # GUI Theme
       xsel # Clipboard manager (at least needed by Neovim)

       # Hyprland:
       # feh # Image Viewer
       # hyprshot # Screenshot App
       # patchelf # ELF File Utility (e.g. changing interpreter of an executable)
       # playerctl # Tool for media controls
    ];
  };

  # Programs
  programs.firefox.enable = true;
  programs.hyprland.enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System packages
  environment.systemPackages = with pkgs; [
     direnv # Environment Manager (installs packages on folder level)
     git # Source Control Tool
     htop # System Resource Viewer CLI
     kitty # Terminal
     nix-direnv # Extension for direnv
     nerd-fonts.fira-code # Font
     p7zip # File Compression Tools
     vim # Text Editor (CLI)
     wget # Network Download Utility CLI

     # Hyprland:
     # brightnessctl # Screen Brightness Controller
     # hyprlock # Lock Screen
     # pavucontrol # Audio Control App
     # waybar # GUI Status Bar
     # wofi # App Search GUI
     # wpaperd # Wallpaper Changer
     # xfce.thunar # File Manager GUI
  ];

  fonts.packages = with pkgs; [
     nerd-fonts.fira-code # Font
  ];

  # Virtualization
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  # C#
  # programs.nix-ld.enable = true;

  # OpenSSH
  # services.openssh.enable = true;

  # Firewall
  # networking.firewall.enable = false;
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # Before changing this value read the documentation 
  system.stateVersion = "24.11";

  # Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Nvidia:

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
  };

  # Load Nvidia driver for Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the Nvidia open source kernel module.
    # Support is limited to the Turing and later architectures:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;   
  };
}

