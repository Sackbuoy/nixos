# Python development tools
{pkgs}:
with pkgs; [
  python313
  ty
  # pyright  # use basedpyright in nvim/flake.nix instead
  black
  ruff
  # pylyzer
  uv
  # basedpyright
  python3Packages.ipdb
]
