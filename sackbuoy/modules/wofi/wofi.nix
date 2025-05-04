{ pkgs, ... }:
let
# Define a custom script package
  lock = pkgs.writeShellScriptBin "lock" ''
    #!/usr/bin/env bash
    ${pkgs.hyprlock}/bin/hyprlock
  '';
in {
  home.packages = [
    lock
  ];
  programs.wofi = {
    enable = true;
    style = builtins.readFile ./styles.css;
  };
}
