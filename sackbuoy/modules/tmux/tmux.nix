{
  programs.tmux = {
    enable = true;
    #extraConfig = ''
    #  set-window-option -g mode-keys vi
    #  bind-key -T copy-mode-vi v send -X begin-selection
    #  bind-key -T copy-mode-vi V send -X select-line
    #  bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel 'xclip -in -selection clipboard'

    #  bind h select-pane -L
    #  bind j select-pane -D
    #  bind k select-pane -U
    #  bind l select-pane -R
    #'';
    extraConfig = (builtins.readFile ./tmux.conf);
  };
}
