{
  description = "A collection of binaries for my neovim install";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system; 
          config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
            "slack"
            "teams-for-linux"
            "discord"
            "spotify"
          ];
        };
      in
      {
        packages.default = pkgs.buildEnv {
          name = "dev-tools";
          paths = with pkgs; [
            signal-desktop
            protonmail-desktop
            spotify-player
            # discord # unfree, use flatpak

            # Work
            # slack # unfree, use flatpak
            # teams-for-linux # unfree, use flatpak
            slack
            teams-for-linux
            discord
            spotify
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
            ghostty
            brave
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
            act
            texliveFull

            neovim
            gopls
            golangci-lint-langserver
            gci
            gotools
            goreleaser
            golangci-lint
            gcc11
            pylyzer
            black
            # terraform # unfree, use nix flake
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

