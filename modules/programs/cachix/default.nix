{ config, pkgs, ... }@inputs: {
  environment.systemPackages = with pkgs; [ cachix ];
}
