# Package sets aggregator
# Import all package categories and expose them as an attribute set
# {pkgs, pkgs-23-11}: {
{pkgs}: {
  # go = import ./go.nix {inherit pkgs pkgs-23-11;};
  go = import ./go.nix {inherit pkgs;};
  python = import ./python.nix {inherit pkgs;};
  web = import ./web.nix {inherit pkgs;};
  kubernetes = import ./kubernetes.nix {inherit pkgs;};
  ansible = import ./ansible.nix {inherit pkgs;};
  terraform = import ./terraform.nix {inherit pkgs;};
  cli = import ./cli.nix {inherit pkgs;};
  workflow = import ./workflow.nix {inherit pkgs;};
  nix = import ./nix.nix {inherit pkgs;};
  other = import ./other.nix {inherit pkgs;};
  desktop = import ./desktop.nix {inherit pkgs;};
}
