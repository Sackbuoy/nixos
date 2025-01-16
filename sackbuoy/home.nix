{ pkgs, ... }:
{
  imports = [
    ./modules/hypr/hyprland.nix
    ./modules/tmux/tmux.nix
    ./modules/git/git.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "sackbuoy";
  home.homeDirectory = "/home/sackbuoy";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  nixpkgs.config.allowUnfree = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  # Moved these to a profile flake
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    pkgs.stderred
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/sackbuoy/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    VISUAL = "nvim";
    EDITOR = "nvim";
    NIXOS_OZONE_WL = "1";
    NIXPKGS_ALLOW_UNFREE= "1";
  };

  # Let Home Manager install and manage itself.
  # programs.home-manager.enable = true;

  programs.wezterm.enable = true;

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    historySubstringSearch.enable = true;
    initExtra = ''
      if [ "$TMUX" = "" ]; then tmux; fi
      bindkey -v
      bindkey '^R' history-incremental-search-backward
      export PATH=/home/sackbuoy/.bin:$PATH

      (
        set -x; cd "''$(mktemp -d)" &&
        OS="''$(uname | tr '[:upper:]' '[:lower:]')" &&
        ARCH="''$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64''$/arm64/')" &&
        KREW="krew-''${OS}_''${ARCH}" &&
        curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/''${KREW}.tar.gz" &&
        tar zxvf "''${KREW}.tar.gz" &&
        ./"''${KREW}" install krew
      ) &>/dev/null

      export PATH="''${KREW_ROOT:-''$HOME/.krew}/bin:''$PATH"

      source <(kubectl completion ''$(echo ''$SHELL | xargs basename))

      # TODO: this doesn't work, need to figure out completion
      # export CLOUD_SDK_HOME="${pkgs.google-cloud-sdk}"
      # source "$CLOUD_SDK_HOME/google-cloud-sdk/completion.zsh.inc"

      setopt autopushd
    '';

    shellAliases = {
      gits = "git status";
      gitb = "git branch";
      gitl = "git log";
      k = "kubectl";

      aws-test = "okta-awscli --profile test --force --okta-profile test && \
        export AWS_DEFAULT_PROFILE=test && \ 
        kubectx cyderes-eks-test";
      aws-dev = "okta-awscli --profile dev --force --okta-profile dev && \
        export AWS_DEFAULT_PROFILE=dev && \
        kubectx cyderes-eks-dev";
      aws-prod = "okta-awscli --profile prod --force --okta-profile prod && \ 
        export AWS_DEFAULT_PROFILE=prod && \
        kubectx cyderes-eks";

      gke-test = "gcloud config configurations activate cyderes-test && \
        kubectxgke-cyderes-test && \
        export GOOGLE_APPLICATION_CREDENTIALS=/home/sackbuoy/.google_creds/cyderes-test.json";
      gke-dev = "gcloud config configurations activate cyderes-dev && \
        kubectx gke-cyderes-dev && \
        export GOOGLE_APPLICATION_CREDENTIALS=/home/sackbuoy/.google_creds/cyderes-dev.json";
      gke-prod = "gcloud config configurations activate cyderes-prod && \
        kubectx gke-cyderes-prod && \ 
        export GOOGLE_APPLICATION_CREDENTIALS=/home/sackbuoy/.google_creds/cyderes-prod.json";
      gke-us-priv-prod = "gcloud config configurations activate cyderes-prod &&
        kubectx gke-us-priv-prod && \
        export GOOGLE_APPLICATION_CREDENTIALS=/home/sackbuoy/.google_creds/cyderes-prod.json";
      gke-alphapub-prod = "gcloud config configurations activate cyderes-prod && \
        kubectx gke-alphapub-prod && \
        export GOOGLE_APPLICATION_CREDENTIALS=/home/sackbuoy/.google_creds/cyderes-prod.json";
      gke-eu-priv-prod = "gcloud config configurations activate cyderes-prod && \
        kubectx gke-eu-priv-prod && \
        export GOOGLE_APPLICATION_CREDENTIALS=/home/sackbuoy/.google_creds/cyderes-prod.json";
      gke-eu-pub-prod = "gcloud config configurations activate cyderes-prod && \
        kubectx gke-eu-pub-prod && \
        export GOOGLE_APPLICATION_CREDENTIALS=/home/sackbuoy/.google_creds/cyderes-prod.json";

      cam-home = "gcloud config configurations activate cam-dev && \
        kubectx cam-home && \ 
        GOOGLE_APPLICATION_CREDENTIALS=/home/sackbuoy/.google_creds/cam-dev.json";
    };

    plugins = [
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
    ];
  };

  # direnv doesn't seem very good at setting up dev environments
  programs.direnv = {
    enable = false;
    enableZshIntegration = true; # see note on other shells below
    nix-direnv.enable = false;
  };

  programs.firefox.enable = true;

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$username$hostname$nix_shell$git_branch$git_commit$git_state$git_status$directory$jobs$cmd_duration$character";
      username = {
        style_user = "bright-white bold";
        style_root = "bright-red bold";
      };
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal = {
          family =  "FiraCode Nerd Font Mono";
          style = "Medium";
	      };
        bold = {
          family = "FiraCode Nerd Font Mono";
          style = "Bold";
	      };
        italic = {
          family = "FiraCode Nerd Font Mono";
          style = "Retina";
	      };
        bold_italic = {
          family = "FiraCode Nerd Font Mono";
          style = "SemiBold";
        };
      
        # Point size
        size = 11.0;
      };
    };
  };
}
