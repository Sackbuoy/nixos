# Rust development tools
# NOTE: rustc/cargo/clippy are managed by rustup (in other.nix) - do NOT add them here.
# rust-analyzer and rustfmt come from nixpkgs but don't have hard ABI coupling the way
# Haskell does - rust-analyzer communicates with cargo via JSON, not compiled ABI.
# If you hit rust-analyzer/toolchain mismatch issues, switch to:
#   rustup component add rust-analyzer rust-src
# and remove rust-analyzer from here entirely.
{pkgs}:
with pkgs; [
  rustup
]
