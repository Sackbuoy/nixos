{ pkgs, ... }:
{
  imports = [
    ./modules/hypr/hyprland.nix
    ./modules/tmux/tmux.nix
    ./modules/git/git.nix
    ./modules/dunst/dunst.nix
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
  ];

  home.file = {
    ".aliases".text = ''
      alias gits="git status"
      alias gitb="git branch"
      alias gitl="git log"
      alias k="kubectl"

      alias aws-test="okta-awscli --profile test --force --okta-profile test && export AWS_DEFAULT_PROFILE=test && kubectx cyderes-eks-test"
      alias aws-dev="okta-awscli --profile dev --force --okta-profile dev && export AWS_DEFAULT_PROFILE=dev && kubectx cyderes-eks-dev"
      alias aws-prod="okta-awscli --profile prod --force --okta-profile prod && export AWS_DEFAULT_PROFILE=prod && kubectx cyderes-eks"

      alias gke-test="gcloud config configurations activate cyderes-test && kubectx gke-cyderes-test && export GOOGLE_APPLICATION_CREDENTIALS=/home/sackbuoy/.google_creds/cyderes-test.json"
      alias gke-dev="gcloud config configurations activate cyderes-dev && kubectx gke-cyderes-dev && export GOOGLE_APPLICATION_CREDENTIALS=/home/sackbuoy/.google_creds/cyderes-dev.json"
      alias gke-prod="gcloud config configurations activate cyderes-prod && kubectx gke-cyderes-prod && export GOOGLE_APPLICATION_CREDENTIALS=/home/sackbuoy/.google_creds/cyderes-prod.json"
      alias gke-us-priv-prod="gcloud config configurations activate cyderes-prod && kubectx gke-us-priv-prod && export GOOGLE_APPLICATION_CREDENTIALS=/home/sackbuoy/.google_creds/cyderes-prod.json"
      alias gke-alphapub-prod="gcloud config configurations activate cyderes-prod && kubectx gke-alphapub-prod && export GOOGLE_APPLICATION_CREDENTIALS=/home/sackbuoy/.google_creds/cyderes-prod.json"
      alias gke-eu-priv-prod="gcloud config configurations activate cyderes-prod && kubectx gke-eu-priv-prod && export GOOGLE_APPLICATION_CREDENTIALS=/home/sackbuoy/.google_creds/cyderes-prod.json"
      alias gke-eu-pub-prod="gcloud config configurations activate cyderes-prod && kubectx gke-eu-pub-prod && export GOOGLE_APPLICATION_CREDENTIALS=/home/sackbuoy/.google_creds/cyderes-prod.json"

      alias cam-home="gcloud config configurations activate cam-dev && kubectx cam-home && GOOGLE_APPLICATION_CREDENTIALS=/home/sackbuoy/.google_creds/cam-dev.json"
    '';
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
    NIXPKGS_ALLOW_UNFREE= "0";
  };

  # Let Home Manager install and manage itself.
  # programs.home-manager.enable = true;

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # to retain aliases in nix-shell
  programs.bash = {
      enable = true;
      initExtra = ''
        # set in home.file.".aliases"
        if [ -f ~/.aliases ]; then
          . ~/.aliases
        fi
      '';
  };

  programs.zsh = {
    enable = true;
    historySubstringSearch.enable = true;
    enableCompletion = true;
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

      # set in home.file.".aliases"
      if [ -f ~/.aliases ]; then
        . ~/.aliases
      fi
    '';

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
