# Kubernetes and container tools
{pkgs}:
with pkgs; [
  kubectl
  kubectx
  docker
  kubernetes-helm
  argocd
  rancher
  stern
  cilium-cli
  # helm-ls
]
