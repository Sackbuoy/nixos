# Nix development tools
# alejandra and nixd live in nvim/flake.nix (they're editor tools)
# Add non-editor nix tools here if needed (e.g. nix-tree, nix-diff, statix)
{pkgs}:
with pkgs; [
  nix-tree
  statix
]
