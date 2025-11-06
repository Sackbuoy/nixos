{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      sensible
      power-theme
      # tmux2k not packaged, run manually
    ];

    extraConfig =
      ''
        set -g default-command "${pkgs.zsh}/bin/zsh"
      ''
      + builtins.readFile ./tmux.conf;
  };
}
