# Haskell development tools
# haskell-language-server lives in nvim/flake.nix
{pkgs}:
with pkgs; [
  ghc
  cabal-install
  stack
]
