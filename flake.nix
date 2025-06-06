{
  description = "A simple flake for an atomic system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    catppuccin.url = "github:catppuccin/nix";
    nur.url = "github:nix-community/NUR";
    nixvim.url = "github:Sly-Harvey/nixvim";
    # hyprland.url = "github:hyprwm/Hyprland";
    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
      rev = "25aec3ac8ce65ed224f025f8f6dfef73780577a4";
      # ref = "v0.40.0";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    /*
    Hyprspace = {
      type = "git";
      url = "https://github.com/KZDKM/Hyprspace";
      submodules = true;
      inputs.hyprland.follows = "hyprland";
      # rev = "cbdac93d2a2b2cb70933a8f6a51ae7511de35615";
    };
    */
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
    # Wallpaper Engine
    kostek001-pkgs = {
      url = "github:kostek001/pkgs";
      # Only if using nixpkgs-unstable
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # sops
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, nixpkgs, catppuccin, sops-nix, ...} @ inputs: let

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
          sops-nix.nixosModules.sops
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
