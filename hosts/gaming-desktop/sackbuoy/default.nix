# Home Manager configuration for sackbuoy on gaming-desktop
{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./niri
    ./noctalia
  ];

  # User info
  home.username = "sackbuoy";
  home.stateVersion = "24.11";

  # Enable all shared modules
  myHome = {
    # Shell configuration
    shell = {
      enable = true;
      zsh = {
        enableTmuxAutostart = true;
        enableKrew = true;
        enableKubectlCompletion = true;
        extraInitContent = ''
          export NIX_PATH=nixpkgs=https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz:$NIX_PATH
        '';
      };
    };

    # Git with commit signing
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
    terminal.ghostty.enable = true;

    # Tmux with vim integration
    tmux = {
      enable = true;
      enableVimNavigator = true;
      rightPlugins = "kube";
      leftPlugins = "gcloud git";
    };

    # Directory navigation
    zoxide.enable = true;

    # Kubectl helper scripts
    scripts.kubectl.enable = true;
  };

  # Additional packages
  home.packages = with pkgs; [
    bat
    eza
  ];

  # Cursor theme
  home.pointerCursor = {
    enable = true;
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # Host-specific files
  home.file = {
    # Screen recording script
    "${config.home.homeDirectory}/.bin/screenrecord" = {
      text = ''
        #!/usr/bin/env bash
        output=$(pgrep wf-recorder)
        if [[ -z "$output" ]]; then
          wf-recorder -g "$(slurp)" -f ${config.home.homeDirectory}/Videos/ScreenRecordings/$(date +%Y-%m-%d_%H-%m-%s).mp4
        else
          pkill wf-recorder
          notify-send "Recording Saved"
        fi
      '';
      executable = true;
    };
  };

  # Session variables
  home.sessionVariables = {
    VISUAL = "nvim";
    EDITOR = "nvim";
    NIXOS_OZONE_WL = "1";
    NIXPKGS_ALLOW_UNFREE = "0";
  };

  # Firefox
  programs.firefox.enable = true;
  programs.firefox.configPath = "${config.xdg.configHome}/mozilla/firefox";

  # Direnv (currently disabled)
  programs.direnv = {
    enable = false;
    enableZshIntegration = true;
    nix-direnv.enable = false;
  };
}
