{ config, pkgs, ... }: {
  # Allow Flatpak
  services.flatpak.enable = true;
}
