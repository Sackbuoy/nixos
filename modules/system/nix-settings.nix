# Nix daemon and flake settings module
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mySystem.nix;
in {
  options.mySystem.nix = {
    enableFlakes = mkOption {
      type = types.bool;
      default = true;
      description = "Enable flakes and nix-command experimental features";
    };

    gc = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable automatic garbage collection";
      };

      frequency = mkOption {
        type = types.str;
        default = "daily";
        description = "How often to run garbage collection";
      };

      olderThan = mkOption {
        type = types.str;
        default = "7d";
        description = "Delete generations older than this";
      };
    };

    trustedUsers = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Users to add to trusted-users";
      example = ["root" "myuser"];
    };

    allowUnfree = mkOption {
      type = types.bool;
      default = true;
      description = "Allow unfree packages";
    };
  };

  config = {
    nix = mkMerge [
      (mkIf cfg.enableFlakes {
        extraOptions = ''
          experimental-features = nix-command flakes
        '';
      })

      (mkIf cfg.gc.enable {
        gc = {
          automatic = true;
          dates = cfg.gc.frequency;
          options = "--delete-older-than ${cfg.gc.olderThan}";
        };
      })

      (mkIf (cfg.trustedUsers != []) {
        settings.trusted-users = cfg.trustedUsers;
      })
    ];

    nixpkgs.config.allowUnfree = cfg.allowUnfree;
  };
}
