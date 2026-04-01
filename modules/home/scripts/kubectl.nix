# Kubectl helper scripts module
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.myHome.scripts.kubectl;
in {
  options.myHome.scripts.kubectl = {
    enable = mkEnableOption "kubectl helper scripts";
  };

  config = mkIf cfg.enable {
    home.file."${config.home.homeDirectory}/.bin/kns" = {
      text = ''
        #!/usr/bin/env bash
        # Kubernetes namespace selector using fzf
        if [ -n "$1" ]; then
          if kubectl get namespace "$1" &>/dev/null; then
            kubectl config set-context --current --namespace="$1"
          else
            selected=$(kubectl get namespaces -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | fzf --query="$1")
            [ -n "$selected" ] && kubectl config set-context --current --namespace="$selected"
          fi
        else
          selected=$(kubectl get namespaces -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | fzf)
          [ -n "$selected" ] && kubectl config set-context --current --namespace="$selected"
        fi
      '';
      executable = true;
    };
  };
}
