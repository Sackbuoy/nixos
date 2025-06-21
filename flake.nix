{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    ...
  }: let
      # system = "x86_64-linux";
      # 
      # # Define which users exist on which hosts
      # hostUsers = {
      #   desktop = [ "sackbuoy" "alice" ];
      #   laptop = [ "sackbuoy" ];
      #   server = [ "sackbuoy" "bob" ];
      # };
      #
      # # Helper function to generate home-manager users for a host
      # mkHomeUsers = hostName: 
      #   builtins.listToAttrs (map (user: {
      #     name = user;
      #     value = import ./users/${user};
      #   }) hostUsers.${hostName});
    in {
    nixosConfigurations = {
      fw-laptop = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          {nixpkgs.overlays = [inputs.hyprpanel.overlay];}
          ./hosts/fw-laptop/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hm-backup";
            home-manager.extraSpecialArgs = { inherit inputs; };

            home-manager.users.sackbuoy = import ./hosts/fw-laptop/sackbuoy;
          }
        ];
      };
    };
  };
}
