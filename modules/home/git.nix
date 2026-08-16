# Git configuration module
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.myHome.git;
in {
  options.myHome.git = {
    enable = mkEnableOption "git configuration";

    userName = mkOption {
      type = types.str;
      default = "Sackbuoy";
      description = "Git user name";
    };

    userEmail = mkOption {
      type = types.str;
      default = "cameronkientz@proton.me";
      description = "Git user email";
    };

    signing = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable commit signing";
      };

      key = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Signing key path (e.g., ~/.ssh/id_ed25519.pub)";
        example = "~/.ssh/id_ed25519.pub";
      };

      format = mkOption {
        type = types.enum ["ssh" "gpg"];
        default = "ssh";
        description = "Signing format (ssh or gpg)";
      };
    };

    enableDelta = mkOption {
      type = types.bool;
      default = true;
      description = "Enable delta for better diffs";
    };

    enableLfs = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Git LFS support";
    };

    enableCredentialStore = mkOption {
      type = types.bool;
      default = false;
      description = "Enable credential helper store (for macOS)";
    };

    conditionalIncludes = mkOption {
      type = types.listOf types.attrs;
      default = [];
      description = "Conditional git config includes based on directory";
      example = [
        {
          condition = "gitdir:~/work/";
          contents = {
            user.email = "work@company.com";
          };
        }
      ];
    };

    extraConfig = mkOption {
      type = types.attrs;
      default = {};
      description = "Extra git configuration";
    };
  };

  config = mkIf cfg.enable {
    programs.delta = mkIf cfg.enableDelta {
      enable = true;
      enableGitIntegration = true;
    };

    programs.git = {
      enable = true;

      lfs.enable = cfg.enableLfs;

      includes = cfg.conditionalIncludes;

      settings = mkMerge [
        # SSH URL rewriting
        {
          url = {
            "ssh://git@github.com" = {
              insteadOf = "https://github.com";
            };
          };

          aliases = {
            co = "checkout";
          };
          user = {
            name = cfg.userName;
            email = cfg.userEmail;
          };

          # Large file support
          http.postBuffer = 524288000; # 500MB

          # Push behavior
          push.autoSetupRemote = true;

          # Default branch
          init.defaultBranch = "main";

          # Merge/diff settings
          merge.conflictstyle = "zdiff3";
          diff.colorMoved = "default";
        }

        # Signing configuration
        (mkIf cfg.signing.enable {
          commit.gpgsign = true;
          gpg.format = cfg.signing.format;
          user.signingkey = cfg.signing.key;
        })

        # Credential helper
        (mkIf cfg.enableCredentialStore {
          credential.helper = "store";
        })

        # User-provided extra config
        cfg.extraConfig
      ];
    };
  };
}
