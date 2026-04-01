# Shared shell aliases module
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.myHome.shell.aliases;
in {
  options.myHome.shell.aliases = {
    enable = mkEnableOption "shared shell aliases";

    extraAliases = mkOption {
      type = types.attrsOf types.str;
      default = {};
      description = "Additional aliases to add";
      example = {
        ll = "ls -la";
      };
    };
  };

  config = mkIf cfg.enable {
    home.file."${config.home.homeDirectory}/.aliases" = {
      text = ''
        # Git aliases
        alias gits="git status"
        alias gitb="git branch"
        alias gitl="git log"

        # Kubernetes
        alias k="kubectl"

        # GCloud config shortcuts
        alias cam-home="gcloud config configurations activate cam-dev && kubectx cam-home && GOOGLE_APPLICATION_CREDENTIALS=${config.home.homeDirectory}/.google_creds/cam-dev.json"

        # Nix helpers
        alias np="nix develop path:$PWD"

        # Better defaults
        alias ls=eza
        alias cat=bat

        ${concatStringsSep "\n" (mapAttrsToList (name: value: "alias ${name}=\"${value}\"") cfg.extraAliases)}
      '';
    };
  };
}
