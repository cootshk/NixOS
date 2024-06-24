{pkgs, ...} : {
  virtualisation.waydroid.enable = true;

  environment.systemPackages = [
    wl-clipboard
  ];
}