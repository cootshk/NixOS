{
  username,
  pkgs,
  ...
}:
{
  catppuccin = {
    accent = "teal";
    flavor = "mocha";
    enable = true;
    cache = true;
    cursors = {
      enable = true;
      flavor = "mocha";
      accent = "dark";
    };
    grub = {
      enable = true;
    };
    gtk.icon.enable = true;
    sddm.enable = true;
    tty.enable = true;
  };

  environment.systemPackages = with pkgs; [
    libsForQt5.qt5ct
    kdePackages.qt6ct
    libsForQt5.qtstyleplugin-kvantum
  ];
  environment.sessionVariables = {
    QT_STYLE_OVERRIDE = "Catppuccin-Mocha";
  };

  home-manager.users.${username} =
    { config, pkgs, ... }:
    {
      # imports = [ inputs.catppuccin.homeManagerModules.catppuccin ];
      home.file.".config/hypr/wallpaper-right.png" = {
        source = ../wallpapers/escape_velocity.jpg;
        # source = ../wallpapers/aurora_borealis.png;
        #source = ../wallpapers/moon.png;
      };
      home.file.".config/hypr/wallpaper-left.gif" = {
        source = ../wallpapers/celeste.gif;
        # source = ../wallpapers/aurora_borealis.png;
        #source = ../wallpapers/moon.png;
      };

      dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };

      home.pointerCursor = {
        gtk.enable = true;
        x11.enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 24;
      };
      catppuccin.kvantum = {
        accent = "teal";
        enable = true;
        flavor = "mocha";
      };
      catppuccin.vesktop.enable = false; # CSS is done from inside Vesktop
      qt = {
        enable = true;
        platformTheme.name = "kvantum";
        style.name = "kvantum";

        # style.catppuccin = {
        #   accent = "teal";
        #   enable = true;
        #   flavor = "mocha";
        # };

      };

      gtk = {
        enable = true;
        #       catppuccin.enable = true;
        theme = {
          name = "Catppuccin-Mocha-Compact-Teal-Dark";
          package = pkgs.catppuccin-gtk.override {
            accents = [ "teal" ];
            size = "compact";
            #tweaks = [ "rimless" "black" ];
            variant = "mocha";
          };
        };

        iconTheme = {
          package = pkgs.adwaita-icon-theme;
          name = "Adwaita";
          #name = "Yaru-magenta-dark";
          #package = pkgs.yaru-theme;
        };

        gtk3.extraConfig = {
          Settings = ''
            gtk-application-prefer-dark-theme=1
          '';
        };

        gtk4.extraConfig = {
          Settings = ''
            gtk-application-prefer-dark-theme=1
          '';
        };

        #font = {
        #  name = "Sans";
        #  size = 11;
        #};
      };

      xdg.configFile = {
        "gtk-4.0/assets".source =
          "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
        "gtk-4.0/gtk.css".source =
          "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
        "gtk-4.0/gtk-dark.css".source =
          "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
      };
    };
}
