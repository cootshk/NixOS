{ config, pkgs, ... }:
{
  environment.systemPackages =
    with pkgs;
    with jetbrains;
    [
      idea
      # Minecraft
      glfw
      clion
      pycharm
      webstorm
      goland
      datagrip
      rider
      phpstorm
      pkgs.jetbrains-runner
      # Java
      zulu17
      corretto21
      zulu25
      gradle
      gradle_9
      # gradle_9
      maven
    ];
  nixpkgs.config.permittedInsecurePackages = [
    "gradle-7.6.6"
  ];
}
