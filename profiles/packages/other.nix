# Other languages and miscellaneous development tools
{pkgs}:
with pkgs; [
  # Languages
  rustup
  elixir
  lua

  # Language servers
  bash-language-server
  lua-language-server
  yaml-language-server
  elixir-ls
  protobuf-language-server
  typos-lsp

  # AI/CLI tools
  claude-code
  opencode-claude-auth
  opencode
  gemini-cli

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
  mermaid-cli
  wget
  yazi
  insomnia
  helix

  # Fun/Learning
  typioca
  pacvim
]
