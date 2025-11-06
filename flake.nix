{
  description = "NixOS and macOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    nix-darwin,
    home-manager,
    ...
  }: let
    hostUsers = {
      gaming-desktop = ["sackbuoy"];
      fw-laptop = ["sackbuoy"];
      Camerons-MacBook-Pro = ["cameronkientz"]; # Add your Mac
    };

    # Helper function to generate home-manager users for a host
    mkHomeUsers = hostName:
      builtins.listToAttrs (map (user: {
          name = user;
          value = import ./hosts/${hostName}/${user};
        })
        hostUsers.${hostName});

    mkHost = hostName:
      nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/${hostName}/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hm-backup";
            home-manager.extraSpecialArgs = {inherit inputs;};

            home-manager.users = mkHomeUsers hostName;
          }
        ];
      };
    
    mkDarwinHost = hostName:
      nix-darwin.lib.darwinSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/${hostName}/configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hm-backup";
            home-manager.extraSpecialArgs = {inherit inputs;};

            home-manager.users = mkHomeUsers hostName;
          }
        ];
      };
  in {
    nixosConfigurations = {
      gaming-desktop = mkHost "gaming-desktop";
      fw-laptop = mkHost "fw-laptop";
    };
    
    darwinConfigurations = {
      Camerons-MacBook-Pro = mkDarwinHost "Camerons-MacBook-Pro";
    };
  };
}
