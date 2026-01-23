{ config, pkgs, ... }:
{
  environment.systemPackages =
    with pkgs;
    with jetbrains;
    [
      idea-ultimate
      # Minecraft
      glfw
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
      zulu25
      # gradle_9
      maven
    ];
  nixpkgs.config.permittedInsecurePackages = [
    "gradle-7.6.6"
  ];
}
