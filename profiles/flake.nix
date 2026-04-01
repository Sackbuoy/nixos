{
  description = "A collection of tools for my development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-23-11.url = "github:NixOS/nixpkgs/nixos-23.11";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-23-11,
  }: let
    systems = ["aarch64-darwin" "x86_64-linux"];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages = forAllSystems (system: let
      overlay = final: prev: {
        # examplepkg = prev.examplepkg.overrideAttrs (oldAttrs: {
        #   version = "1.0";
        #   src = pkgs.fetchFromGitHub {
        #     owner = "Owner";
        #     repo = "Repo";
        #     rev = "Tag"; # Use the exact tag/commit
        #     sha256 = ""; # You'll need to replace this with the correct hash
        #   };
        # });
      };

      pkgs = import nixpkgs {
        localSystem = system;
        overlays = [overlay];
        config = {
          hardeningDisable = ["fortify"];
          allowUnfreePredicate = pkg:
            builtins.elem (nixpkgs.lib.getName pkg) [
              "slack"
              "teams-for-linux"
              "discord"
              "spotify"
              "zoom"
              "ticktick"
              "terraform"
              "claude-code"
            ];
        };
      };

      pkgs-23-11 = import nixpkgs-23-11 {localSystem = system;};

      # Import package sets from ./packages/
      packages = import ./packages {inherit pkgs pkgs-23-11;};

      # Import profile definitions from ./profiles/
      profiles = import ./profiles {inherit packages;};
    in {
      default = pkgs.buildEnv {
        name = "personal";
        paths = profiles.personal;
      };

      work = pkgs.buildEnv {
        name = "work";
        paths = profiles.work;
      };

      personal = pkgs.buildEnv {
        name = "personal";
        paths = profiles.personal;
      };
    });
  };
}
