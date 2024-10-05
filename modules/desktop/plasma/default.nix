{pkgs, inputs, ...}: {
  services.desktopManager.plasma6.enable = true;
  environment.systemPackages = with pkgs; [
    qt6.qtwebsockets
    qt6.qtmultimedia
  ];
}