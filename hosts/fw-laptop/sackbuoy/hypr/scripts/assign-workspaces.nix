{pkgs, ...}:
pkgs.writeShellApplication {
  name = "assign-workspaces";
  runtimeInputs = [pkgs.jq pkgs.coreutils];
  text = builtins.readFile ./assign_workspaces.sh;
}
