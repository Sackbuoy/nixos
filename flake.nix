{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    ...
  }: let
    hostUsers = {
      gaming-desktop = ["sackbuoy"];
      fw-laptop = ["sackbuoy"];
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
  in {
    nixosConfigurations = builtins.listToAttrs (map (hostName: {
      name = hostName;
      value = mkHost hostName;
    }) (builtins.attrNames hostUsers));
  };
}
