# Other languages and miscellaneous development tools
{pkgs}:
with pkgs; [
  # Languages
  rustup
  beamPackages.elixir
  lua

  # Language servers
  bash-language-server
  # lua-language-server
  yaml-language-server
  # elixir-ls
  # protobuf-language-server
  typos-lsp

  # AI/CLI tools
  claude-code
  opencode-claude-auth

  # Protobuf & API
  buf
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
