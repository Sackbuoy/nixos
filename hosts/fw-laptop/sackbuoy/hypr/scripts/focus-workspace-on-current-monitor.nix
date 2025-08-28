{pkgs, ...}:
pkgs.writeShellApplication {
  name = "fwcm";
  runtimeInputs = [pkgs.jq pkgs.coreutils pkgs.hyprland];
  text = builtins.readFile ./focus_workspace_on_current_monitor.sh;
}
