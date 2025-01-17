{
  description = "A collection of binaries for my neovim install";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.default = pkgs.buildEnv {
          name = "dev-tools";
          paths = with pkgs; [
            signal-desktop
            protonmail-desktop
            # spotify -> use flathub, can't log in on this one :(
            spotify-player
            discord

            # Work
            slack
            teams-for-linux
            (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
            awscli2
            nodejs
            kubectl
            kubectx
            go
            delve
            docker
            kubernetes-helm
            argocd

            fzf
            zsh-vi-mode
            alacritty
            tmux
            ripgrep

            # other dev tools
            nodejs
            bun # WAY better than node
            rustup
            python313 # no pip bc it will never work, all python needs to use venv
            elixir
            httpie
            gnumake
            gh
            jq
            yq
            stern

            neovim
            gopls
            golangci-lint-langserver
            gci
            gotools
            golangci-lint
            gcc11
            pylyzer
            black
            terraform
            terraform-ls
            typescript-language-server
            angular-language-server
            bash-language-server
            lua-language-server
            helm-ls
            ripgrep
          ];
        };
      }
    );
}

