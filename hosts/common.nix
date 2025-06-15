{ inputs, pkgs, username, lib, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    # inputs.kostek001-pkgs.nixosModules.wallpaper-engine-kde-plugin
    # inputs.catppuccin.nixosModules.catppuccin
    # inputs.catppuccin.homeManagerModules.catppuccin

    ../modules/hardware/opengl.nix
    ../modules/programs/alacritty
    ../modules/programs/bash
    ../modules/programs/btop
    ../modules/programs/cava
    ../modules/programs/cloudflared
    ../modules/programs/direnv
    ../modules/programs/docker
    #../modules/programs/fastfetch
    ../modules/programs/firefox
    # ../modules/programs/firefox/firefox-system.nix
    ../modules/programs/flatpak
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
    ../modules/programs/waydroid
    ../modules/programs/zsh
  ];

  catppuccin = {
    enable = true;
    accent = "teal";
    flavor = "mocha";
  };
  home-manager.backupFileExtension = "old";
  # Common home-manager options that are shared between all systems.
  home-manager.users.${username} = { pkgs, inputs, ... }: {
    #     imports = [ inputs.catppuccin.homeManagerModules.catppuccin ];
    # Packages that don't require configuration. If you're looking to configure a program see the /modules dir
    home.packages = with pkgs; [
      # Applications
      #kate
      xfce.thunar

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
      htop
      jq
      lf
      #lolcat
      nixfmt
      nix-prefetch-scripts
      neofetch
      # nvtop
      #nvidia-docker
      ripgrep
      piper-tts
      portaudio
      prismlauncher
      vlc
      tldr
      unzip
    ];
  };

  # Filesystems support
  boot.supportedFilesystems = [ "ntfs" "exfat" "ext4" "fat32" "btrfs" ];
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Bootloader.
  boot = {
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
        theme = lib.mkForce (pkgs.stdenv.mkDerivation {
          pname = "distro-grub-themes";
          version = "3.1";
          src = pkgs.fetchFromGitHub {
            owner = "AdisonCavani";
            repo = "distro-grub-themes";
            rev = "v3.1";
            hash = "sha256-ZcoGbbOMDDwjLhsvs77C7G7vINQnprdfI37a9ccrmPs=";
          };
          installPhase = "cp -r customize/nixos $out";
        });
      };
    };
  };

  security = {
    polkit.enable = true;
    #sudo.wheelNeedsPassword = false;
    sudo = {
      enable = true;
      extraRules = [{
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
      }];
      extraConfig = with pkgs; ''
        Defaults:picloud secure_path="${
          lib.makeBinPath [ systemd ]
        }:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin"
      '';
    };
  };

  xdg.portal = {
    enable = true;
    configPackages =
      [ pkgs.xdg-desktop-portal-gtk ]; # pkgs.xdg-desktop-portal-hyprland];
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
      # xdg-desktop-portal-hyprland
    ];
  };

  # Enable dconf for home-manager
  programs.dconf.enable = true;

  # Plasma 6
  #services.desktopManager.plasma6.enable = true;

  # Setup auth agent and keyring
  services.gnome.gnome-keyring.enable = true;
  systemd = {
    user.services.polkit-kde-authentication-agent-1 = {
      description = "polkit-kde-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart =
          "${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
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
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
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

  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    # ...
  ]; # ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  nixpkgs = {
    config.allowUnfree = true; # sometimes this doesn't work
    # config.allowUnfreePredicate = _: true;
    config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "cuda-merged"
        "nvtop"
        "nvtopPackages.full"
      ];
    overlays = [ inputs.nur.overlays.default ];
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
    libsForQt5.polkit-kde-agent

    # Development
    devbox # faster nix-shells
    shellify # faster nix-shells
    github-desktop
    /* (pkgs.catppuccin-sddm.override {
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
    glxinfo
    vulkan-tools

    # VMs
    qemu_full
    qemu_kvm
    libvirt
    virt-manager

    # Wine
    (wineWowPackages.stable.override { waylandSupport = true; })

    # Wallpaper Engine
    inputs.kostek001-pkgs.packages.${pkgs.system}.wallpaper-engine-kde-plugin
    kdePackages.qtwebchannel

    # Icons
    morewaita-icon-theme

    # Cloudflare
    cloudflare-warp # cloudflared - moved to module
  ];

  # virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd = {
    enable = true;
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

  virtualisation.spiceUSBRedirection.enable = true;
  programs.virt-manager.enable = true;

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

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall = {
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
        start = 3000;
        end = 4000;
      }
      {
        start = 5000;
        end = 6000;
      }
      # HTTP
      {
        start = 8000;
        end = 9000;
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
        start = 3000;
        end = 4000;
      }
      {
        start = 5000;
        end = 6000;
      }
    ];
  };

  nix = {
    # Nix Package Manager Settings
    settings = {
      auto-optimise-store = true;
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
        "https://nix-gaming.cachix.org"
        "https://cuda-maintainers.cachix.org"
        "https://neorocks.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        "neorocks.cachix.org-1:WqMESxmVTOJX7qoBC54TwrMMoVI1xAM+7yFin8NRfwk="
      ];
      experimental-features = [ "nix-command" "flakes" ];
      use-xdg-base-directories = true;
      warn-dirty = false;
      keep-outputs = true;
      keep-derivations = true;
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
