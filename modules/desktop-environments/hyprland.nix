{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.wofi
    pkgs.nautilus
    pkgs.waybar
    pkgs.kitty
    pkgs.brightnessctl
    pkgs.hyprshot
  ];

  programs.hyprland = {
    enable = true;
    # withUWSM  = true; # "recommended" but breaks hypr utilities
  };
}
