{ config, pkgs, ... }:
{
  programs.nixvim.opts = {
    tabstop = 2;
    shiftwidth = 2;
    softtabstop = 0;
    expandtab = true;
    smarttab = true;

    number = true;
    relativenumber = true;
  };
}
