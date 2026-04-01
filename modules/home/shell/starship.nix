# Starship prompt configuration module
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.myHome.shell.starship;
in {
  options.myHome.shell.starship = {
    enable = mkEnableOption "starship prompt";
  };

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      settings = {
        add_newline = false;
        format = "$username$hostname$nix_shell$git_branch$git_commit$git_state$git_status$directory$jobs$cmd_duration$character";
        username = {
          style_user = "bright-white bold";
          style_root = "bright-red bold";
        };
      };
    };
  };
}
