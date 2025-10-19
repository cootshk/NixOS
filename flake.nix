{
  description = "A simple flake for an atomic system";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    catppuccin.url = "github:catppuccin/nix";
    nur.url = "github:nix-community/NUR";
    nixvim.url = "github:Sly-Harvey/nixvim";
    # hyprland.url = "github:hyprwm/Hyprland";
    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
      # rev = "25aec3ac8ce65ed224f025f8f6dfef73780577a4";
      # ref = "v0.40.0";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    Hyprspace = {
      type = "git";
      url = "https://github.com/KZDKM/Hyprspace";
      submodules = true;
      inputs.hyprland.follows = "hyprland";
      # rev = "cbdac93d2a2b2cb70933a8f6a51ae7511de35615";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # spicetify-nix = {
    #   url = "github:the-argus/spicetify-nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # sops
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xlibre-overlay = {
      url = "git+https://codeberg.org/takagemacoed/xlibre-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-blame-someone-else = {
      url = "github:cootshk/git-blame-someone-else";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    winboat.url = "github:tibixdev/winboat";
  };

  outputs =
    {
      self,
      nixpkgs,
      catppuccin,
      sops-nix,
      ...
    }@inputs:
    let

      username = "hkaz0"; # REPLACE THIS WITH YOUR USERNAME!!! (if manually installing, this is Required.)
      system = "x86_64-linux"; # REPLACE THIS WITH YOUR ARCHITECTURE (Rarely need to)
      locale = "en_US.UTF-8"; # REPLACE THIS WITH YOUR LOCALE
      timezone = "America/Chicago"; # REPLACE THIS WITH YOUR TIMEZONE

      modules = [
        inputs.home-manager.nixosModules.home-manager
        # catppuccin.nixosModules.catppuccin
      ];

      lib = nixpkgs.lib;
      enable_Xlibre = true; # CHANGE
      xlibre =
        if enable_Xlibre then
          [
            inputs.xlibre-overlay.nixosModules.overlay-xlibre-xserver
            # inputs.xlibre-overlay.nixosModules.overlay-all-xlibre-drivers
            inputs.xlibre-overlay.nixosModules.nvidia-ignore-ABI

          ]
        else
          [ ];
    in
    {
      nixosConfigurations = {
        nixos = lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit
              username
              locale
              timezone
              inputs
              ;
          }
          // inputs;
          modules = [
            (
              { pkgs, ... }:
              {
                nixpkgs = {
                  config = {
                    allowUnfree = true;
                    allowUnfreePredicate = pkg: true;
                  };
                  overlays =
                    let
                      overlayed = [
                        # All overlays listed here have their `default` package added to nixpkgs as the overlay name
                        # For example: `git-blame-someone-else` overlay adds inputs.git-blame-someone-else.packages.${system}.default as `git-blame-someone-else` in the overlayed nixpkgs
                        "git-blame-someone-else"
                        "winboat"
                      ];
                    in
                    [
                      (
                        final: prev:
                        with lib.attrsets;
                        genAttrs overlayed (
                          overlay:
                          let
                            set = inputs.${overlay}.packages.${system};
                          in
                          if hasAttr "defaultPackage" inputs.${overlay} then
                            inputs.${overlay}.defaultPackage.${system}
                          else if hasAttr "default" set then
                            set.default
                          else
                            set.${overlay}
                        )
                      )
                    ];
                };
              }
            )
            ./hosts/Default/configuration.nix
            #catppuccin.homeManagerModules.catppuccin
            catppuccin.nixosModules.catppuccin
            sops-nix.nixosModules.sops
          ]
          # Xlibre
          ++ xlibre;
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      # or 'home-manager --flake .' for current user in current hostname
      #homeConfigurations = {
      #  ${username} = home-manager.lib.homeManagerConfiguration {
      #    pkgs = nixpkgs.legacyPackages.${system};
      #    modules = [
      #      ./home/home.nix
      #      {
      #        home = {
      #          username = username;
      #          homeDirectory = "/home/${username}";
      #          stateVersion = "23.11";
      #        };
      #      }
      #    ];
      #  };
      #};
    };
}
