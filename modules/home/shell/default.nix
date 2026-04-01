# Shell configuration bundle
# Imports all shell-related modules
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.myHome.shell;
in {
  imports = [
    ./aliases.nix
    ./starship.nix
    ./zsh.nix
  ];

  options.myHome.shell = {
    enable = mkEnableOption "shell configuration bundle";
  };

  config = mkIf cfg.enable {
    myHome.shell = {
      aliases.enable = mkDefault true;
      starship.enable = mkDefault true;
      zsh.enable = mkDefault true;
    };
  };
}
