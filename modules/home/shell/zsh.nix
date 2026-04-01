# Zsh configuration module
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.myHome.shell.zsh;
in {
  options.myHome.shell.zsh = {
    enable = mkEnableOption "zsh configuration";

    enableTmuxAutostart = mkOption {
      type = types.bool;
      default = true;
      description = "Start tmux automatically on shell launch";
    };

    enableKrew = mkOption {
      type = types.bool;
      default = true;
      description = "Install and configure krew (kubectl plugin manager)";
    };

    enableKubectlCompletion = mkOption {
      type = types.bool;
      default = true;
      description = "Enable kubectl shell completion";
    };

    enableMise = mkOption {
      type = types.bool;
      default = false;
      description = "Enable mise runtime manager (typically for macOS)";
    };

    extraInitContent = mkOption {
      type = types.lines;
      default = "";
      description = "Extra content to add to zsh initContent";
    };

    extraPath = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Extra paths to add to PATH";
      example = [
        "$HOME/.cargo/bin"
        "$HOME/.local/bin"
      ];
    };
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      historySubstringSearch.enable = true;
      enableCompletion = false; # Manual control for compinit ordering

      initContent = ''
        ${optionalString cfg.enableTmuxAutostart ''
          if [ "$TMUX" = "" ]; then tmux; fi
        ''}

        # Vi mode keybindings
        bindkey -v
        bindkey '^R' history-incremental-search-backward

        # Add ~/.bin to PATH
        export PATH=${config.home.homeDirectory}/.bin:$PATH

        ${optionalString cfg.enableKrew ''
          # Install krew if not present (runs in background)
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
        ''}

        ${concatMapStringsSep "\n" (p: "export PATH=\"${p}:$PATH\"") cfg.extraPath}

        # Shell type for compatibility
        export MYSHELL=zsh
        alias nix-shell='nix-shell --command zsh'

        ${optionalString cfg.enableKubectlCompletion ''
          source <(kubectl completion $MYSHELL)
        ''}

        # Directory navigation
        setopt autopushd

        # Custom completions directory
        fpath=(~/.bin/completions $fpath)

        # Initialize completions (must be after fpath modifications)
        autoload -U compinit && compinit

        # Source aliases file
        if [ -f ~/.aliases ]; then
          . ~/.aliases
        fi

        ${optionalString cfg.enableMise ''
          # Mise runtime manager
          eval "$($HOME/.local/bin/mise activate zsh)"
          export PATH="$HOME/.local/share/mise/shims:$PATH"
        ''}

        ${cfg.extraInitContent}
      '';

      plugins = [
        {
          name = "vi-mode";
          src = pkgs.zsh-vi-mode;
          file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
        }
      ];
    };

    # Bash fallback for nix-shell compatibility
    programs.bash = {
      enable = true;
      initExtra = ''
        export MYSHELL=bash
        ${optionalString cfg.enableKubectlCompletion ''
          source <(kubectl completion $MYSHELL)
        ''}
        if [ -f ~/.aliases ]; then
          . ~/.aliases
        fi
      '';
    };
  };
}
