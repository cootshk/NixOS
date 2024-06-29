{
  description = "A simple flake for an atomic system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    catppuccin.url = "github:catppuccin/nix";
    nur.url = "github:nix-community/NUR";
    nixvim.url = "github:Sly-Harvey/nixvim";
    hyprland.url = "github:hyprwm/Hyprland";
    Hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, nixpkgs, catppuccin, ...} @ inputs: let

    username = "hkaz0"; # REPLACE THIS WITH YOUR USERNAME!!! (if manually installing, this is Required.)
    system = "x86_64-linux"; # REPLACE THIS WITH YOUR ARCHITECTURE (Rarely need to)
    locale = "en_US.UTF-8"; # REPLACE THIS WITH YOUR LOCALE
    timezone = "America/Chicago"; # REPLACE THIS WITH YOUR TIMEZONE

    modules = [
      inputs.home-manager.nixosModules.home-manager
      # catppuccin.nixosModules.catppuccin
    ];

    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      nixos = lib.nixosSystem {
        inherit system;
        specialArgs = {inherit username locale timezone inputs;} // inputs;
        modules = [
          ./hosts/Default/configuration.nix
          #catppuccin.homeManagerModules.catppuccin
          catppuccin.nixosModules.catppuccin
        ];
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
