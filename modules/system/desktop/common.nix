# Common Wayland desktop configuration
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mySystem.desktop;
in {
  options.mySystem.desktop = {
    enable = mkEnableOption "Wayland desktop environment";

    defaultBrowser = mkOption {
      type = types.str;
      default = "zen.desktop";
      description = "Default browser desktop file";
    };
  };

  config = mkIf cfg.enable {
    # Security requirements for Wayland compositors
    security.polkit.enable = true;

    # X server (still needed for XWayland)
    services.xserver.enable = true;

    # Touchpad support
    services.libinput.enable = true;

    # Power management
    services.upower.enable = true;

    # XDG portal configuration
    xdg = {
      mime.defaultApplications = {
        "text/html" = cfg.defaultBrowser;
        "x-scheme-handler/http" = cfg.defaultBrowser;
        "x-scheme-handler/https" = cfg.defaultBrowser;
        "x-scheme-handler/about" = cfg.defaultBrowser;
        "x-scheme-handler/unknown" = cfg.defaultBrowser;
      };

      portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gnome
          xdg-desktop-portal-gtk
        ];
        config.common = {
          default = "gnome";
          "org.freedesktop.impl.portal.FileChooser" = "gtk";
        };
      };
    };
  };
}
