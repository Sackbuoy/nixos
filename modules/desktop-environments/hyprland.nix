{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.wofi
    pkgs.dolphin
    pkgs.waybar
    pkgs.kitty
  ];

  programs.hyprland = {
    enable = true;
  };
}
