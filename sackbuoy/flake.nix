{
  description = "A collection of tools for my development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    kraken-desktop.url = "github:Sackbuoy/kraken-desktop-flake";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    kraken-desktop,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        overlay = final: prev: {
          # examplepkg = prev.examplepkg.overrideAttrs (oldAttrs: {
          #   version = "1.0";
          #   src = pkgs.fetchFromGitHub {
          #     owner = "Owner";
          #     repo = "Repo";
          #     rev = "Tag"; # Use the exact tag/commit 
          #     sha256 = ""; # You'll need to replace this with the correct hash
          #   };
          # });
        };

        pkgs = import nixpkgs {
          inherit system;
          overlays = [ overlay ];
          config = {
            hardeningDisable = ["fortify"];
            allowUnfreePredicate = pkg:
              builtins.elem (nixpkgs.lib.getName pkg) [
                "slack"
                "teams-for-linux"
                "discord"
                "spotify"
                "zoom"
              ];
          };
        };

      in {
        packages.default = pkgs.buildEnv {
          name = "dev-tools";
          paths = with pkgs; [
            signal-desktop
            protonmail-desktop
            spotify-player
            discord
            zoom-us
            kraken-desktop.packages.x86_64-linux.default
            telegram-desktop

            # Work
            slack
            teams-for-linux
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
            rancher

            fzf
            fd
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
            pv

            neovim
            gopls
            golangci-lint-langserver
            gci
            gotools
            goreleaser
            gotestsum
            golangci-lint
            gcc11
            pylyzer
            pyright
            black
            # terraform # unfree, use nix flake
            terraform-ls
            typescript-language-server
            angular-language-server
            bash-language-server
            lua-language-server
            helm-ls
            ripgrep
            elixir-ls
            next-ls

            alejandra
            nixd

            ansible
            ansible-navigator
            ansible-builder
            ansible-language-server
            ansible-lint
          ];
        };
      }
    );
}
