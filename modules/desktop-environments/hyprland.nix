{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.wofi
    pkgs.nautilus
    pkgs.waybar
    pkgs.kitty
    pkgs.brightnessctl
    pkgs.hyprshot
    pkgs.hyprpolkitagent
    pkgs.libsForQt5.qt5.qtwayland
  ];

  # hyprland "must haves"
  security.polkit.enable = true;

  programs.hyprland = {
    enable = true;
    # withUWSM  = true; # "recommended" but breaks hypr utilities
  };
}
