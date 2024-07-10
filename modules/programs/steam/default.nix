

#  programs.steam = {
#    enable = true;
#    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
#    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
#    gamescopeSession.enable = true;
#  };

{
  pkgs,
  ...
}: {
  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      gamescopeSession.enable = true;
    };
    gamemode.enable = true;
  };
  environment.systemPackages = with pkgs; [
    mangohud
  ];
}
