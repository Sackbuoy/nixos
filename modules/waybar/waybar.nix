{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    pkgs.pavucontrol
  ];

  programs.waybar = {
    enable = true;
  };
}
