{
  username,
  pkgs,
  ...
}: {
  home-manager.users.${username} = {config, ...}: {
    home.file.".config/hypr/wallpaper.png" = {
      #source = ../wallpapers/aurora_borealis.png;
      source = ./pokemon.jpg;
    };
  };
}