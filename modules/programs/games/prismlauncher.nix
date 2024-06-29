{
  pkgs,
  ...
}: {
  environment.systemPackages = [
    pkgs.prismlauncher
    pkgs.mangohud
    ];
}
