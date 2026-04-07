# Host definitions for NixOS and Darwin systems
# Uses flake-parts withSystem to access per-system inputs
{
  inputs,
  withSystem,
  config,
  ...
}: let
  # Map of hosts to their users
  hostUsers = {
    fw-laptop = ["sackbuoy"];
    Camerons-MacBook-Pro = ["cameronkientz"];
  };

  # Generate home-manager user configs for a host
  mkHomeUsers = hostName:
    builtins.listToAttrs (map (user: {
        name = user;
        value = {
          imports = [
            ../hosts/${hostName}/${user}
            # Include all home-manager modules for myHome.* options
            config.flake.homeManagerModules.default
          ];
        };
      })
      hostUsers.${hostName});

  # Common home-manager configuration
  homeManagerConfig = hostName: {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.backupFileExtension = "hm-backup";
    home-manager.extraSpecialArgs = {inherit inputs;};
    home-manager.users = mkHomeUsers hostName;
  };

  # Create a NixOS host configuration
  mkNixosHost = hostName: system:
    withSystem system ({inputs', ...}:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs inputs';};
        modules = [
          ../hosts/${hostName}/configuration.nix
          # Include all NixOS modules for mySystem.* options
          config.flake.nixosModules.default
          inputs.nix-index-database.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
          (homeManagerConfig hostName)
        ];
      });

  # Create a Darwin host configuration
  mkDarwinHost = hostName: system:
    withSystem system ({inputs', ...}:
      inputs.nix-darwin.lib.darwinSystem {
        specialArgs = {inherit inputs inputs';};
        modules = [
          ../hosts/${hostName}/configuration.nix
          inputs.nix-index-database.darwinModules.default
          inputs.home-manager.darwinModules.home-manager
          (homeManagerConfig hostName)
        ];
      });
in {
  flake.nixosConfigurations = {
    fw-laptop = mkNixosHost "fw-laptop" "x86_64-linux";
  };

  flake.darwinConfigurations = {
    Camerons-MacBook-Pro = mkDarwinHost "Camerons-MacBook-Pro" "aarch64-darwin";
  };
}
