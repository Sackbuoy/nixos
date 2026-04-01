# Ghostty terminal configuration module
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.myHome.terminal.ghostty;
in {
  options.myHome.terminal.ghostty = {
    enable = mkEnableOption "ghostty terminal";
  };

  config = mkIf cfg.enable {
    programs.ghostty.enable = true;
  };
}
