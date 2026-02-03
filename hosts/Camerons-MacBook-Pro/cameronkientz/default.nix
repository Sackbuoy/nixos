{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./tmux
    ./git
    ./mise
  ];

  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    maple-mono.NF
    git-lfs
  ];

  home.sessionVariables = {
    VISUAL = "nvim";
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;

  home.file = {
    "${config.home.homeDirectory}/.aliases" = {
      text = ''
        alias gits="git status"
        alias gitb="git branch"
        alias gitl="git log"
        alias k="kubectl"
        alias cam-home="gcloud config configurations activate cam-dev && kubectx cam-home && GOOGLE_APPLICATION_CREDENTIALS=${config.home.homeDirectory}/.google_creds/cam-dev.json"
      '';
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

  programs.zsh = {
    enable = true;
    historySubstringSearch.enable = true;
    # enableCompletion = false; # doing this myself so i can ensure compinit is after fpath edits
    initContent = ''
      if [ "$TMUX" = "" ]; then tmux; fi
      bindkey -v
      bindkey '^R' history-incremental-search-backward
      export PATH=${config.home.homeDirectory}/.bin:$PATH
      export NOTES_CONFIG=${config.home.homeDirectory}/.note-rs/config.yaml

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

      # for uv tools
      export PATH="${config.home.homeDirectory}/.local/bin:$PATH"

      setopt autopushd

      # place all custom completion functions here
      fpath=(~/.bin/completions $fpath)

      # this needs to be _after_ all fpath edits
      autoload -U compinit && compinit

      # set in home.file.".aliases"
      if [ -f ~/.aliases ]; then
        . ~/.aliases
      fi

      GOPRIVATE=gitlab.com/realm-security,buf.build/gen/go
    '';

    plugins = [
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
    ];
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

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
