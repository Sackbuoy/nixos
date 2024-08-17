{ config, pkgs, ... }:
{
  imports = [
    ./opts.nix
    ./plugins.nix
    ./keymaps.nix
  ];

  programs.nixvim = {
    enable = true;

    globals.mapleader = " ";

    colorschemes.nightfox = {
      enable = true;
    };
  };
}
