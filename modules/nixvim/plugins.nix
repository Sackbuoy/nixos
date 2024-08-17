{
  programs.nixvim.plugins = {
    telescope = {
      enable = true;
      extensions = {
        fzf-native = {
          enable = true;
        };
      };
    };

    neo-tree = {
      enable = true;
    };

    tmux-navigator = {
      enable = true;
    };
  };
}
