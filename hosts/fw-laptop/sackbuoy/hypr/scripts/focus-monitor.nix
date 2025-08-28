{pkgs, ...}:
pkgs.writeShellApplication {
  name = "focus-monitor";
  runtimeInputs = [pkgs.jq pkgs.coreutils pkgs.hyprland];
  text = builtins.readFile ./focus_monitor.sh;
}
