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
      default = true;
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
      default = "battery network time";
      description = "tmux2k right side plugins";
      example = "battery network time";
    };

    leftPlugins = mkOption {
      type = types.str;
      default = "git kube";
      description = "tmux2k left side plugins";
      example = "git kube";
    };

    windowNavPrevSeq = mkOption {
      type = types.str;
      default = "\\e[104;13u";
      description = "Escape sequence for previous-window (default: Ctrl+Super/Cmd+h, CSI-u)";
    };

    windowNavNextSeq = mkOption {
      type = types.str;
      default = "\\e[108;13u";
      description = "Escape sequence for next-window (default: Ctrl+Super/Cmd+l, CSI-u)";
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
          set -g visual-activity off
          set-option -g focus-events on
        ''}

        ${builtins.readFile ./base.conf}

        # tmux2k panel configuration
        set -g @tmux2k-right-plugins '${cfg.rightPlugins}'
        set -g @tmux2k-left-plugins '${cfg.leftPlugins}'

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

        # Window navigation: Ctrl+Super/Cmd+h/l (CSI-u, no prefix)
        set -s user-keys[0] "${cfg.windowNavPrevSeq}"
        set -s user-keys[1] "${cfg.windowNavNextSeq}"
        bind -n User0 previous-window
        bind -n User1 next-window

        # Easy config reload
        bind-key R source-file ~/.config/tmux/tmux.conf \; display-message "tmux.conf reloaded."

        ${cfg.extraConfig}

        # TPM must be last
        run -b '~/.config/tmux/plugins/tpm/tpm'
      '';
    };
  };
}
