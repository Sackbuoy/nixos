{ config, pkgs, ... }:
{
  programs.nixvim = {
    enable = true;

    globals.mapleader = " ";

    opts = {
      tabstop = 2;
      shiftwidth = 2;
      softtabstop = 0;
      expandtab = true;
      smarttab = true;
    };

    colorschemes.nightfox = {
      enable = true;
    };
  };
}
