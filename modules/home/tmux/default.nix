# Tmux configuration module
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.myHome.tmux;
in {
  options.myHome.tmux = {
    enable = mkEnableOption "tmux configuration";

    enableImagePassthrough = mkOption {
      type = types.bool;
      default = false;
      description = "Enable image passthrough (for terminals like Kitty/iTerm2)";
    };

    enableVimNavigator = mkOption {
      type = types.bool;
      default = true;
      description = "Enable vim-tmux-navigator plugin";
    };

    enableSmartSplits = mkOption {
      type = types.bool;
      default = false;
      description = "Enable smart-splits.nvim (alternative to vim-tmux-navigator)";
    };

    rightPlugins = mkOption {
      type = types.str;
      default = "kube";
      description = "tmux2k right side plugins";
      example = "battery network time";
    };

    leftPlugins = mkOption {
      type = types.str;
      default = "gcloud git";
      description = "tmux2k left side plugins";
      example = "git";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Extra tmux configuration";
    };
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;

      extraConfig = ''
        ${optionalString cfg.enableImagePassthrough ''
          # Enable image passthrough for terminal image rendering
          set -g allow-passthrough on
        ''}

        ${builtins.readFile ./base.conf}

        # tmux2k panel configuration
        set -g @tmux2k-right-plugins '${cfg.rightPlugins}'
        set -g @tmux2k-left-plugins '${cfg.leftPlugins}'

        ${optionalString (cfg.rightPlugins == "kube") ''
          set -g @tmux2k-kube-symbol '󱃾'
        ''}
        ${optionalString (builtins.match ".*gcloud.*" cfg.leftPlugins != null) ''
          set -g @tmux2k-gcloud-symbol '󰅟'
        ''}

        # Vim integration
        ${optionalString cfg.enableVimNavigator ''
          set -g @plugin 'christoomey/vim-tmux-navigator'
          bind -n C-j run "(tmux display-message -p '#{pane_current_command}' | grep -iqE '(^|\/)vim$' && tmux send-keys C-j) || tmux select-pane -D"
          bind -n C-k run "(tmux display-message -p '#{pane_current_command}' | grep -iqE '(^|\/)vim$' && tmux send-keys C-k) || tmux select-pane -U"
          bind -n C-l run "(tmux display-message -p '#{pane_current_command}' | grep -iqE '(^|\/)vim$' && tmux send-keys C-l) || tmux select-pane -R"
          bind -n 'C-\' run "(tmux display-message -p '#{pane_current_command}' | grep -iqE '(^|\/)vim$' && tmux send-keys 'C-\\') || tmux select-pane -l"
          bind C-l send-keys 'C-l'
        ''}

        ${optionalString cfg.enableSmartSplits ''
          set -g @plugin 'mrjones2014/smart-splits.nvim'
        ''}

        # Easy config reload
        bind-key R source-file ~/.config/tmux/tmux.conf \; display-message "tmux.conf reloaded."

        ${cfg.extraConfig}

        # TPM must be last
        run -b '~/.config/tmux/plugins/tpm/tpm'
      '';
    };
  };
}
