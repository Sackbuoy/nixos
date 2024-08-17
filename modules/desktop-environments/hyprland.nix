{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    pkgs.wofi
    pkgs.dolphin
    pkgs.waybar
    pkgs.kitty
  ];

  programs.hyprland = {
    enable = true;
  };
}
