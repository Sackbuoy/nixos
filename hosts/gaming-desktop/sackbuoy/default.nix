# Home Manager configuration for sackbuoy on gaming-desktop
# TODO: Customize for your gaming desktop setup
{
  config,
  pkgs,
  ...
}: {
  home.username = "sackbuoy";
  home.homeDirectory = "/home/sackbuoy";
  home.stateVersion = "24.05";

  # Enable shared modules
  myHome = {
    # Shell configuration
    shell = {
      enable = true;
      zsh = {
        enableTmuxAutostart = true;
        enableKrew = true;
        enableKubectlCompletion = true;
      };
    };

    # Git with signing
    git = {
      enable = true;
      userName = "Sackbuoy";
      userEmail = "cameronkientz@proton.me";
      signing = {
        enable = true;
        key = "~/.ssh/id_ed25519.pub";
        format = "ssh";
      };
    };

    # Terminals
    terminal.alacritty.enable = true;

    # Tmux
    tmux = {
      enable = true;
      enableVimNavigator = true;
      rightPlugins = "kube";
      leftPlugins = "git";
    };

    # Directory navigation
    zoxide.enable = true;

    # Kubectl helpers
    scripts.kubectl.enable = true;
  };

  # Additional packages
  home.packages = with pkgs; [
    bat
    eza
  ];

  # Session variables
  home.sessionVariables = {
    VISUAL = "nvim";
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
}
