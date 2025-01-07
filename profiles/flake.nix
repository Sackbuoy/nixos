{
  description = "A collection of binaries for my neovim install";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        # Define your collection of binaries here
        flakePackages = [
          # Personal
          pkgs.signal-desktop
          pkgs.protonmail-desktop
          pkgs.spotify

          # Work
          pkgs.slack
          pkgs.teams-for-linux
          (pkgs.google-cloud-sdk.withExtraComponents [pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin])
          pkgs.awscli2
          pkgs.nodejs
          pkgs.kubectl
          pkgs.kubectx
          pkgs.go
          pkgs.delve
          pkgs.python313
          pkgs.docker

          # common-dev
          pkgs.fzf
          pkgs.zsh-vi-mode
          pkgs.alacritty
          pkgs.tmux
          pkgs.ripgrep

          pkgs.nodejs
          pkgs.rustup
          pkgs.python313
          pkgs.elixir
          pkgs.httpie
          pkgs.gnumake
          pkgs.gh
          pkgs.jq
        ];
      in
      {
        # This creates a packages.default that includes all binaries
        packages.default = pkgs.symlinkJoin {
          name = "myprofile";
          paths = flakePackages;
        };
      });
}

