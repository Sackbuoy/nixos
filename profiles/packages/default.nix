# Package sets aggregator
# Import all package categories and expose them as an attribute set
#
# BOUNDARY RULE:
#   This flake (profiles/) owns: language runtimes, dev/cloud CLI tools, desktop apps
#   nvim/flake.nix owns:        neovim, LSP servers, formatters, linters, editor tools
#
# EXCEPTION: languages with compiler ABI coupling (Haskell, Rust) must have their
#   LSP server here alongside their compiler — NOT in nvim/flake.nix.
#   Both must come from the same pkgs instance or you get ABI mismatches.
#
# When adding a new tool, ask: "Do I need this outside of neovim?"
#   YES → put it here    NO → put it in nvim/flake.nix
# Does the LSP need to match compiler ABI? → put BOTH here
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
  zig = import ./zig.nix {inherit pkgs;};
  haskell = import ./haskell.nix {inherit pkgs;};
  rust = import ./rust.nix {inherit pkgs;};
  other = import ./other.nix {inherit pkgs;};
  desktop = import ./desktop.nix {inherit pkgs;};
}
