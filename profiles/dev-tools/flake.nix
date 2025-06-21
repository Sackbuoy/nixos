{
  description = "A collection of tools for my development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
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

        # combined to avoid collisions between binaries that are in multiple
        # packages
        go-dev-tools = (pkgs.symlinkJoin {
          name = "go-dev-tools";
          paths = with pkgs; [ 
            go
            delve
            gopls 
            golangci-lint-langserver
            golangci-lint
            gci
            gotools 
            goreleaser
            gotestsum
          ];
          postBuild = ''
            # Remove gofix from gopls to avoid collision
            rm -f $out/bin/gofix
            # Symlink gofix from gotools
            ln -s ${pkgs.gotools}/bin/gofix $out/bin/gofix
          '';
        });

        desktop-apps = (pkgs.symlinkJoin {
          name = "desktop-apps";
          paths = with pkgs; [ 
            signal-desktop
            protonmail-desktop
            spotify-player
            discord
            zoom-us
            telegram-desktop
            slack
            teams-for-linux
            spotify
            brave
          ];
          postBuild = ''

          '';
        });

        kube-dev = (pkgs.symlinkJoin {
          name = "kube-dev";
          paths = with pkgs; [ 
            kubectl
            kubectx
            docker
            kubernetes-helm
            argocd
            rancher
            stern
            helm-ls
          ];
          postBuild = ''

          '';
        });

        web-dev = (pkgs.symlinkJoin {
          name = "web-dev";
          paths = with pkgs; [ 
            nodejs
            bun # WAY better than node
            typescript-language-server
            angular-language-server
            next-ls
          ];
          postBuild = ''

          '';
        });

        cli-tools = (pkgs.symlinkJoin {
          name = "cli-tools";
          paths = with pkgs; [ 
            (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
            awscli2
            fzf
            fd
            ripgrep
            httpie
            gnumake
            gh
            jq
            yq
            act
            pv
            gcc11
          ];
          postBuild = ''

          '';
        });

        dev-workflow = (pkgs.symlinkJoin {
          name = "dev-workflow";
          paths = with pkgs; [ 
            zsh-vi-mode
            tmux
            neovim

          ];
          postBuild = ''

          '';
        });

        python-dev = (pkgs.symlinkJoin {
          name = "python-dev";
          paths = with pkgs; [ 
            python313 # no pip bc it will never work, all python needs to use venv
            pylyzer
            pyright
            black

          ];
          postBuild = ''

          '';
        });

        ansible-dev = (pkgs.symlinkJoin {
          name = "ansible-dev";
          paths = with pkgs; [ 
            ansible
            ansible-navigator
            ansible-builder
            ansible-language-server
            ansible-lint
          ];
          postBuild = ''

          '';
        });

        nix-dev = (pkgs.symlinkJoin {
          name = "nix-dev";
          paths = with pkgs; [ 
            alejandra
            nixd
          ];
          postBuild = ''

          '';
        });
      in {
        packages.default = pkgs.buildEnv {
          name = "dev-tools";
          paths = with pkgs; [
            desktop-apps
            go-dev-tools
            kube-dev
            web-dev
            cli-tools
            dev-workflow
            python-dev
            ansible-dev
            nix-dev

            # other dev tools
            rustup
            elixir
            # terraform # unfree, use nix flake
            terraform-ls
            bash-language-server
            lua-language-server
            elixir-ls
          ];
        };
      }
    );
}
