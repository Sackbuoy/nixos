{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./hypr
    ./niri
    ./tmux
    ./git
    ./wofi
    ./waybar
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "sackbuoy";

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
    bat
    eza
  ];

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  home.file = {
    "${config.home.homeDirectory}/.aliases" = {
      text = ''
        alias gits="git status"
        alias gitb="git branch"
        alias gitl="git log"
        alias k="kubectl"

        alias cam-home="gcloud config configurations activate cam-dev && kubectx cam-home && GOOGLE_APPLICATION_CREDENTIALS=${config.home.homeDirectory}/.google_creds/cam-dev.json"

        alias np="nix develop path:$PWD"
        alias ls=eza
        alias cat=bat
      '';
    };
    "${config.home.homeDirectory}/.bin/screenrecord" = {
      text = ''
        #!/usr/bin/env bash
        output=$(pgrep wf-recorder)
        if [[ -z "$output" ]]; then
          # start recording
          wf-recorder -g \"$(slurp)\" -f ${config.home.homeDirectory}/Videos/ScreenRecordings/$(date +%Y-%m-%d_%H-%m-%s).mp4
        else
          # recording already in progress
          pkill wf-recorder
          notify-send "Recording Saved"
        fi
      '';
      executable = true;
    };
    "${config.home.homeDirectory}/.bin/kns" = {
      text = ''
        #!/usr/bin/env bash
        if [ -n "$1" ]; then
          if kubectl get namespace "$1" &>/dev/null; then
            kubectl config set-context --current --namespace="$1"
          else
            selected=$(kubectl get namespaces -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | fzf --query="$1")
            [ -n "$selected" ] && kubectl config set-context --current --namespace="$selected"
          fi
        else
          selected=$(kubectl get namespaces -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | fzf)
          [ -n "$selected" ] && kubectl config set-context --current --namespace="$selected"
        fi
      '';
      executable = true;
    };
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
    NIXPKGS_ALLOW_UNFREE = "0";
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
      export MYSHELL=bash
      source <(kubectl completion $MYSHELL)
      # set in home.file.".aliases"
      if [ -f ~/.aliases ]; then
        . ~/.aliases
      fi
    '';
  };

  programs.zsh = {
    enable = true;
    historySubstringSearch.enable = true;
    enableCompletion = false; # doing this myself so i can ensure compinit is after fpath edits
    initContent = ''
      if [ "$TMUX" = "" ]; then tmux; fi
      bindkey -v
      bindkey '^R' history-incremental-search-backward
      export PATH=${config.home.homeDirectory}/.bin:$PATH

      ((
        set -x; cd "''$(mktemp -d)" &&
        OS="''$(uname | tr '[:upper:]' '[:lower:]')" &&
        ARCH="''$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64''$/arm64/')" &&
        KREW="krew-''${OS}_''${ARCH}" &&
        curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/''${KREW}.tar.gz" &&
        tar zxvf "''${KREW}.tar.gz" &&
        ./"''${KREW}" install krew
      ) & disown) &>/dev/null

      export PATH="''${KREW_ROOT:-''$HOME/.krew}/bin:''$PATH"

      # this is annoying
      export MYSHELL=zsh
      alias nix-shell='nix-shell --command zsh'

      source <(kubectl completion $MYSHELL)

      # TODO: this doesn't work, need to figure out completion
      # export CLOUD_SDK_HOME="${pkgs.google-cloud-sdk}"
      # source "$CLOUD_SDK_HOME/google-cloud-sdk/completion.zsh.inc"

      setopt autopushd

      # place all custom completion functions here
      fpath=(~/.bin/completions $fpath)

      # this needs to be _after_ all fpath edits
      autoload -U compinit && compinit

      # set in home.file.".aliases"
      if [ -f ~/.aliases ]; then
        . ~/.aliases
      fi

      export NIX_PATH=nixpkgs=https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz:$NIX_PATH
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

  programs.ghostty.enable = true;

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal = {
          family = "Maple Mono NF";
          style = "Medium";
        };
        bold = {
          family = "Maple Mono NF";
          style = "Bold";
        };
        italic = {
          family = "Maple Mono NF";
          style = "Retina";
        };
        bold_italic = {
          family = "Maple Mono NF";
          style = "SemiBold";
        };

        # Point size
        size = 11.0;
      };
    };
  };
}
