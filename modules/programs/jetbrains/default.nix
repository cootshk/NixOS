{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs.jetbrains; [
    idea-ultimate
    clion
    pycharm-professional
    webstorm
    goland
    datagrip
    rider
    phpstorm
    pkgs.jetbrains-runner
  ];
}
