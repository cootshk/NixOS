{ pkgs, username, locale, timezone, inputs, ... }: {
  nixpkgs.config.allowUnfree = true;

  imports = [
    ../common.nix
    ../../modules/hardware/nvidia.nix
    ../../modules/hardware/opengl.nix
    ../../modules/desktop/hyprland # Enable Hyprland window manager
    ../../modules/desktop/plasma
    #Plasma 6
    #../../modules/desktop/plasma6.nix
    #../../modules/programs/games
    ./hardware-configuration.nix
  ];

  # Home-manager config
  home-manager.users.${username} = {
    imports = [ inputs.catppuccin.homeModules.catppuccin ];
    home.username = username;
    home.homeDirectory = "/home/${username}";

    home.stateVersion = "23.11"; # Please read the comment before changing.

    home.sessionVariables = {
      # EDITOR = "emacs";
    };

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
  };

  networking.hostName = "nixos"; # Define your hostname.
  networking.enableIPv6 = true; # IPv6 Support
  networking.nameservers = [ "1.1.1.1" "192.168.100.1" "1.0.0.1" ];
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Timezone and locale
  time.timeZone = timezone;
  i18n.defaultLocale = locale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = locale;
    LC_IDENTIFICATION = locale;
    LC_MEASUREMENT = locale;
    LC_MONETARY = locale;
    LC_NAME = locale;
    LC_NUMERIC = locale;
    LC_PAPER = locale;
    LC_TELEPHONE = locale;
    LC_TIME = locale;
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "us";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    extraGroups =
      [ "networkmanager" "wheel" "video" "audio" "docker" "libvirtd" ];
  };

  environment.systemPackages = with pkgs; [
    age
    gnupg
    pinentry-all
    wget
    gnumake
    xdotool
    vim
    xorg.xwininfo
    yad
    steamtinkerlaunch
    blockbench
    qemu
    quickemu
    #catppuccin
    #catppuccin-gtk
    #catppuccin-kde
    #catppuccin-sddm
    #catppuccin-cursors
    #kdePackages.sddm-kcm
  ];

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Xbox controller
  hardware.xpadneo.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
