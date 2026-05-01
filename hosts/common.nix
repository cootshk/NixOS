{
  inputs,
  pkgs,
  username,
  lib,
  config,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    # inputs.kostek001-pkgs.nixosModules.wallpaper-engine-kde-plugin
    # inputs.catppuccin.nixosModules.catppuccin
    # inputs.catppuccin.homeManagerModules.catppuccin

    ../modules/hardware/opengl.nix
    ../modules/programs/alacritty
    ../modules/programs/bash
    ../modules/programs/btop
    ../modules/programs/cachix
    ../modules/programs/cava
    ../modules/programs/cloudflared
    ../modules/programs/direnv
    ../modules/programs/docker
    #../modules/programs/fastfetch
    ../modules/programs/flatpak
    ../modules/programs/jetbrains
    ../modules/programs/kitty
    ../modules/programs/lazygit
    ../modules/programs/lf
    ../modules/programs/mpv
    ../modules/programs/nixvim
    ../modules/programs/starship
    ../modules/services/tlp # Set cpu power settings
    ../modules/programs/tmux
    ../modules/programs/vscodium
    ../modules/programs/steam
    # ../modules/programs/spicetify
    ../modules/programs/unity
    ../modules/programs/waydroid
    ../modules/programs/zsh
  ];

  catppuccin = {
    enable = true;
    accent = "teal";
    flavor = "mocha";
  };
  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "old";
  # Common home-manager options that are shared between all systems.
  home-manager.users.${username} =
    { pkgs, inputs, ... }:
    {
      #     imports = [ inputs.catppuccin.homeManagerModules.catppuccin ];
      # Packages that don't require configuration. If you're looking to configure a program see the /modules dir
      home.packages = with pkgs; [
        # Applications
        archipelago
        cider-2
        #kate
        owmods-cli
        owmods-gui
        prismlauncher
        vesktop
        vlc
        thunar

        # Terminal
        appimage-run
        # dolphin-emu
        eza
        fzf
        fastfetch
        fd
        ffmpeg-full
        fish
        git
        gh
        gum
        htop
        jq
        kubernetes-helm
        lf
        #lolcat
        nixfmt
        nix-prefetch-scripts
        # nvtop
        #nvidia-docker
        # ollama-cuda
        ripgrep
        piper-tts
        portaudio
        tldr
        unzip
      ];
    };

  # Filesystems support
  boot.supportedFilesystems = [
    "ntfs"
    "exfat"
    "ext4"
    "fat32"
    "btrfs"
  ];
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Bootloader.
  boot = {
    extraModprobeConfig = ''
      options usbcore use_both_schemes=y
      options hid_apple fnmode=2
    '';
    tmp.cleanOnBoot = true;
    kernelParams = [ "intel_iommu=on" ];
    loader = {
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
      timeout = null; # Display bootloader indefinitely until user selects OS
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        gfxmodeEfi = "1920x1080";
        configurationLimit = 5;
        theme = lib.mkForce (
          pkgs.stdenv.mkDerivation {
            pname = "distro-grub-themes";
            version = "3.1";
            src = pkgs.fetchFromGitHub {
              owner = "AdisonCavani";
              repo = "distro-grub-themes";
              rev = "v3.1";
              hash = "sha256-ZcoGbbOMDDwjLhsvs77C7G7vINQnprdfI37a9ccrmPs=";
            };
            installPhase = "cp -r customize/nixos $out";
          }
        );
      };
    };
  };

  security = {
    polkit.enable = true;
    #sudo.wheelNeedsPassword = false;
    sudo = {
      enable = true;
      extraRules = [
        {
          commands = [
            {
              command = "${pkgs.systemd}/bin/systemctl suspend";
              options = [ "NOPASSWD" ];
            }
            {
              command = "${pkgs.systemd}/bin/reboot";
              options = [ "NOPASSWD" ];
            }
            {
              command = "${pkgs.systemd}/bin/poweroff";
              options = [ "NOPASSWD" ];
            }
          ];
          groups = [ "wheel" ];
        }
      ];
      extraConfig = with pkgs; ''
        Defaults:picloud secure_path="${lib.makeBinPath [ systemd ]}:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin"
      '';
    };
  };

  xdg.portal = {
    enable = true;
    config = {
      common.default = [ "gtk;*" ];
      kde = {
        default = [
          "kde"
          "gtk"
        ];
        "org.freedesktop.portal.FileChooser" = [ "kde" ];
        "org.freedesktop.portal.OpenURI" = [ "kde" ];
      };
    };
    configPackages = with pkgs; [
      xdg-desktop-portal
      kdePackages.xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
    ];
    extraPortals = with pkgs; [
      xdg-desktop-portal
      kdePackages.xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
    ];
    #   # make xdg-open use a portal
    xdgOpenUsePortal = false;
  };

  # Enable dconf for home-manager
  programs.dconf.enable = true;

  # Plasma 6
  #services.desktopManager.plasma6.enable = true;

  # Setup auth agent and keyring
  services.gnome.gnome-keyring.enable = true;
  systemd = {
    # user.services.polkit-kde-authentication-agent-1 = {
    #   description = "polkit-kde-authentication-agent-1";
    #   wantedBy = [ "graphical-session.target" ];
    #   wants = [ "graphical-session.target" ];
    #   after = [ "graphical-session.target" ];
    #   serviceConfig = {
    #     Type = "simple";
    #     ExecStart = "${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
    #     Restart = "on-failure";
    #     RestartSec = 1;
    #     TimeoutStopSec = 10;
    #   };
    # };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  # sound.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
    # media-session has been replaced by wireplumber
    wireplumber.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Default user when using: sudo nixos-rebuild build-vm
  #users.users.nixosvmtest.isNormalUser = true;
  #users.users.nixosvmtest.initialPassword = "vm";
  #users.users.nixosvmtest.group = "nixosvmtest";
  #users.groups.nixosvmtest = {};

  # Default shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  fonts = {
    fontDir.enable = true;
    enableDefaultPackages = true;
    packages =
      with pkgs;
      [
        wineWow64Packages.fonts
        # ...
      ]
      # Nerd Fonts
      ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  };

  nixpkgs = {
    overlays = [ inputs.nur.overlays.default ];
  };

  environment.sessionVariables = {
    __NV_DISABLE_EXPLICIT_SYNC = "1";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # System
    # scripts.tm
    # x-sessionizer
    # scripts.collect-garbage
    adwaita-qt
    bibata-cursors
    libsForQt5.qt5.qtgraphicaleffects # For sddm to function properly
    polkit
    kdePackages.qtbase
    kdotool
    # libsForQt5.polkit-kde-agent

    # Development
    devbox # faster nix-shells
    shellify # faster nix-shells
    github-desktop
    git-blame-someone-else
    freerdp
    # TODO: remove this once winboat is fixed in nixpkgs
    # winboat
    # (winboat.override { nodejs_24 = nodejs_24; })
    /*
      (pkgs.catppuccin-sddm.override {
        flavor = "mocha";
        font = "Noto Sans";
        fontSize = "9";
        background = "${../../modules/themes/wallpapers/wallhaven-8586my.png}";
        loginBackground = true;
      })
    */
    # Kde Settings
    pciutils
    wayland-utils
    clinfo
    mesa-demos
    vulkan-tools

    # VMs
    # qemu_full
    # qemu_kvm
    # libvirt
    # virt-manager

    # Wine
    wineWow64Packages.stable
    wineWow64Packages.fonts

    # Wallpaper Engine
    kdePackages.qtwebchannel

    # Icons
    morewaita-icon-theme

    # Cloudflare
    # cloudflare-warp # cloudflared - moved to module

    # Portals (todo: move to module)
    xdg-desktop-portal
    kdePackages.xdg-desktop-portal-kde
    xdg-desktop-portal-gtk

    # nvtopPackages.full

    # smartd
    smartmontools
  ];

  # Cloudflare
  services.cloudflare-warp.enable = true;

  # virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd = {
    enable = false;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [
          (pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd
        ];
      };
    };
  };

  # Turning on VMs massively slows down boot
  virtualisation.spiceUSBRedirection.enable = false;
  programs.virt-manager.enable = false;

  # Enable sddm login manager
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    # theme = "astronaut";
    # settings.Theme.CursorTheme = "Bibata-Modern-Classic";
    # package = lib.mkForce pkgs.kdePackages.sddm;
    #  theme = "catppuccin-mocha";
    # catppuccin.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # smartd for disks
  services.smartd = {
    enable = true;
    autodetect = true;
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [
        # Minecraft
        19132
        25565
        25575
        # Satisfactory
        7777
        15000
        15777
        # HTTP(S)
        80
        443
      ];
      allowedTCPPortRanges = [
        {
          from = 3000;
          to = 4000;
        }
        {
          from = 5000;
          to = 6000;
        }
        # HTTP
        {
          from = 8000;
          to = 9000;
        }
      ];
      allowedUDPPorts = [
        1234
        # Minecraft
        19132
        # Satisfactory
        7777
      ];
      allowedUDPPortRanges = [
        {
          from = 3000;
          to = 4000;
        }
        {
          from = 5000;
          to = 6000;
        }
      ];
    };
    hostName = "nixos"; # Define your hostname.
    enableIPv6 = true; # IPv6 Support
    nameservers = [
      "1.1.1.1"
      "192.168.100.1"
      "1.0.0.1"
    ];
    networkmanager.enable = true;
    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    useDHCP = lib.mkDefault true;
    # interfaces.enp5s0.useDHCP = lib.mkDefault true;
  };
  nix = {
    # Nix Package Manager Settings
    settings = {
      auto-optimise-store = true;
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
        "https://nix-gaming.cachix.org"
        "https://cuda-maintainers.cachix.org"
        "https://neorocks.cachix.org"
        "https://cootshk.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        "neorocks.cachix.org-1:WqMESxmVTOJX7qoBC54TwrMMoVI1xAM+7yFin8NRfwk="
        "cootshk.cachix.org-1:yt4kcEbYvyd1Xs/H2Uw7VNOl1EjAiTdef/ZjyQY09CU="
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      use-xdg-base-directories = true;
      warn-dirty = false;
      keep-outputs = true;
      keep-derivations = true;
      trusted-users = [
        "root"
        "${username}"
      ];
    };
    gc = {
      # Garbage Collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 3d";
    };
    optimise.automatic = true;
    package = pkgs.nixVersions.stable;
  };
}
