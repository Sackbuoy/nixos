# Foot terminal configuration module
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.myHome.terminal.foot;
in {
  options.myHome.terminal.foot = {
    enable = mkEnableOption "foot terminal";
  };

  config = mkIf cfg.enable {
    programs.foot.enable = true;
  };
}
