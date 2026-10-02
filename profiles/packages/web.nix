# Web/Node.js development tools
# typescript-language-server and angular-language-server live in nvim/flake.nix
{pkgs}:
with pkgs; [
  nodejs_22  # pinned to 22 to match what typescript-language-server requires
  bun
]
