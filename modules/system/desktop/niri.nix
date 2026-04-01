# Niri window manager configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mySystem.desktop.niri;
in {
  options.mySystem.desktop.niri = {
    enable = mkEnableOption "Niri window manager";

    setAsDefault = mkOption {
      type = types.bool;
      default = false;
      description = "Set Niri as the default session";
    };
  };

  config = mkIf cfg.enable {
    # Ensure desktop common is enabled
    mySystem.desktop.enable = mkDefault true;

    # Niri compositor
    programs.niri = {
      enable = true;
      package = pkgs.niri;
    };

    # Register as a session
    services.displayManager.sessionPackages = [pkgs.niri];

    # Set as default session if requested
    services.displayManager.defaultSession = mkIf cfg.setAsDefault "niri";
  };
}
