# Other languages and miscellaneous development tools
{pkgs}:
with pkgs; [
  # Languages
  rustup
  beamPackages.elixir
  lua

  # Language servers (note: most LSPs live in nvim/flake.nix)
  # bash-language-server  # in nvim flake
  # lua-language-server   # in nvim flake
  yaml-language-server    # useful in CLI context (e.g. CI scripts), also in nvim flake if needed
  # elixir-ls
  # protobuf-language-server
  typos-lsp

  # AI/CLI tools
  claude-code
  opencode-claude-auth

  # Protobuf & API
  # buf  # in nvim flake
  crossplane-cli
  protobuf_33

  # Observability
  vector
  opentelemetry-collector

  # Database
  postgresql
  lazysql
  dynein

  # Other utilities
  clang-tools
  wget
  yazi
  insomnia

  # Fun/Learning
  typioca
  pacvim

  steel

  slides

  wireshark

  nmap
  metasploit
  hashcat

  wireguard-tools
  wireguard-go
  wireguard-ui

  otel-cli

  cliamp

  k9s
  opentelemetry-collector-contrib
  flux
]
