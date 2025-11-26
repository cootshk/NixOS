{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    unityhub
    mono5
    mono
    dotnet-sdk_10
    dotnet-sdk_9
    dotnet-sdk # v8
  ];
}
