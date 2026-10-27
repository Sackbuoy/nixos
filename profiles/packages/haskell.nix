# Haskell development tools
# haskell-language-server lives in nvim/flake.nix
{pkgs}:
with pkgs; [
  cabal-install
  stack
  haskell-language-server
]
