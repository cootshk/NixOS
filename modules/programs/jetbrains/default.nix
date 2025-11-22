{ config, pkgs, ... }:
{
  environment.systemPackages =
    with pkgs;
    with jetbrains;
    [
      idea-ultimate
      clion
      pycharm-professional
      webstorm
      goland
      datagrip
      rider
      phpstorm
      pkgs.jetbrains-runner
      # Java
      corretto21
      # gradle_9
      maven
    ];
  nixpkgs.config.permittedInsecurePackages = [
    "gradle-7.6.6"
  ];
}
