# Go development tools
{pkgs, pkgs-23-11}: let
  # Pinned GCI version for compatibility
  gci-pinned = pkgs.buildGoModule.override {go = pkgs-23-11.go_1_21;} rec {
    pname = "gci";
    version = "0.13.6";

    src = pkgs.fetchFromGitHub {
      owner = "daixiang0";
      repo = pname;
      rev = "v${version}";
      hash = "sha256-BlR7lQnp9WMjSN5IJOK2HIKXIAkn5Pemf8qbMm83+/w=";
    };

    vendorHash = "sha256-/8fggERlHySyimrGOHkDERbCPZJWqojycaifNPF6MjE=";
  };
in
  with pkgs; [
    go
    delve
    gopls
    golangci-lint-langserver
    golangci-lint
    gci-pinned
    gotools
    goreleaser
    gotestsum
  ]
