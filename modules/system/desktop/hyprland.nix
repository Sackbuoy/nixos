# Hyprland window manager configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mySystem.desktop.hyprland;
in {
  options.mySystem.desktop.hyprland = {
    enable = mkEnableOption "Hyprland window manager";
  };

  config = mkIf cfg.enable {
    # Ensure desktop common is enabled
    mySystem.desktop.enable = mkDefault true;

    # PAM for hyprlock
    security.pam.services.hyprlock = {};

    # Hyprland compositor
    programs.hyprland = {
      enable = true;
      # withUWSM = true; # "recommended" but can break hypr utilities
    };

    # Add Hyprland portal
    xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-hyprland];
  };
}
