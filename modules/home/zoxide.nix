# Zoxide configuration module
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.myHome.zoxide;
in {
  options.myHome.zoxide = {
    enable = mkEnableOption "zoxide directory jumper";
  };

  config = mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
