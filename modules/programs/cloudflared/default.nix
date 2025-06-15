{ username, pkgs, config, ... }: {
  imports = [
    # tunnels/henry.nix # fill these out on your own.
  ];
  environment.systemPackages = with pkgs; [ cloudflared ];
  services.cloudflared = { enable = true; };
}
