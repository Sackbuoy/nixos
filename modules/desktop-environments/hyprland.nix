{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.wofi
    pkgs.dolphin
    pkgs.waybar
    pkgs.kitty
    pkgs.brightnessctl
  ];

  programs.hyprland = {
    enable = true;
  };
}
