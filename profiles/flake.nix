{
  description = "A collection of tools for my development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-23-11.url = "github:NixOS/nixpkgs/nixos-23.11";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-23-11,
  }: let
    systems = ["aarch64-darwin" "x86_64-linux"];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages = forAllSystems (system: let
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
        localSystem = system;
        overlays = [overlay];
        config = {
          hardeningDisable = ["fortify"];
          allowUnfreePredicate = pkg:
            builtins.elem (nixpkgs.lib.getName pkg) [
              "slack"
              "teams-for-linux"
              "discord"
              "spotify"
              "zoom"
              "ticktick"
              "terraform"
              "claude-code"
            ];
        };
      };

      pkgs-23-11 = import nixpkgs-23-11 {localSystem = system;};

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

      # Define package collections
      packageSets = {
        # Language-specific dev tools
        go-dev = with pkgs; [
          go
          delve
          gopls
          golangci-lint-langserver
          golangci-lint
          gci-pinned
          gotools
          goreleaser
          gotestsum
        ];

        python-dev = with pkgs; [
          python313
          ty
          pyright
          black
          ruff
          pylyzer
          uv
          basedpyright
        ];

        web-dev = with pkgs; [
          nodejs
          bun
          typescript-language-server
          angular-language-server
          next-ls
        ];

        # Infrastructure & cloud tools
        kube-dev = with pkgs; [
          kubectl
          kubectx
          docker
          kubernetes-helm
          argocd
          rancher
          stern
          helm-ls
        ];

        ansible-dev = with pkgs; [
          ansible
          ansible-navigator
          ansible-builder
          ansible-language-server
          ansible-lint
        ];

        terraform-dev = with pkgs; [
          # terraform
          terraform-ls
          opentofu
          tflint
        ];

        # CLI utilities
        cli-tools = with pkgs;
          [
            (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
            awscli2
            fzf
            fd
            ripgrep
            httpie
            gnumake
            gh
            glab
            jq
            yq
            act
            pv
            socat
            htop
            gnupg
          ]
          ++ pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [
            gcc15
          ];

        # Development workflow
        dev-workflow = with pkgs; [
          zsh-vi-mode
          tmux
          neovim
        ];

        # Nix tooling
        nix-dev = with pkgs; [
          alejandra
          nixd
        ];

        # Other languages & tools
        other-dev = with pkgs; [
          rustup
          elixir
          bash-language-server
          lua
          lua-language-server
          yaml-language-server
          elixir-ls
          claude-code
          buf
          localstack
          mise
          crossplane-cli
          protobuf-language-server
          clang-tools
          vector
          protobuf_33
          gemini-cli
        ];

        # Desktop applications (Linux only)
        desktop-apps = with pkgs;
          pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [
            signal-desktop
            protonmail-desktop
            electron-mail
            spotify-player
            discord
            zoom-us
            slack
            spotify
            brave
            prismlauncher
          ];
      };

      # Define profiles as combinations of package sets
      profiles = with packageSets; {
        work =
          go-dev
          ++ kube-dev
          ++ terraform-dev
          ++ cli-tools
          ++ dev-workflow
          ++ nix-dev
          ++ python-dev
          ++ web-dev
          ++ other-dev;

        personal =
          go-dev
          ++ python-dev
          ++ kube-dev
          ++ web-dev
          ++ cli-tools
          ++ dev-workflow
          ++ nix-dev
          ++ other-dev
          ++ desktop-apps;
      };
    in {
      default = pkgs.buildEnv {
        name = "personal";
        paths = profiles.personal;
      };

      work = pkgs.buildEnv {
        name = "work";
        paths = profiles.work;
      };

      personal = pkgs.buildEnv {
        name = "personal";
        paths = profiles.personal;
      };
    });
  };
}
