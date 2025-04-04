{
  description = "A collection of binaries for my neovim install";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    zen-browser,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            hardeningDisable = ["fortify"];
            allowUnfreePredicate = pkg:
              builtins.elem (nixpkgs.lib.getName pkg) [
                "slack"
                "teams-for-linux"
                "discord"
                "spotify"
              ];
          };
        };
        zen = zen-browser.packages."${system}".twilight-official;
      in {
        packages.default = pkgs.buildEnv {
          name = "dev-tools";
          paths = with pkgs; [
            signal-desktop
            protonmail-desktop
            spotify-player
            # discord # unfree, use flatpak
            zen

            # Work
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
            texliveFull
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

            cilium-cli

            flutter
          ];
        };
      }
    );
}
