# Home Manager configuration for cameronkientz on macOS
{
  pkgs,
  config,
  ...
}: {
  home.stateVersion = "24.05";

  # Enable all shared modules
  myHome = {
    # Shell configuration
    shell = {
      enable = true;
      zsh = {
        enableTmuxAutostart = true;
        enableKrew = true;
        enableKubectlCompletion = false; # kubectl not always available on macOS
        enableMise = true;
        extraPath = [
          "${config.home.homeDirectory}/.local/bin" # uv tools
          "${config.home.homeDirectory}/.cargo/bin" # tree-sitter etc
        ];
        extraInitContent = ''
          export NOTES_CONFIG=${config.home.homeDirectory}/.note-rs/config.yaml

          # Go private modules
          GOPRIVATE=gitlab.com/realm-security,buf.build/gen/go

          # UV development
          UV_ENV_FILE=.env

          # Claude API key
          source ~/.creds/claude
        '';
      };
    };

    # Git with conditional includes for work/personal
    git = {
      enable = true;
      userName = "Sackbuoy";
      userEmail = "cameronkientz@proton.me";
      enableLfs = true;
      enableCredentialStore = true;
      conditionalIncludes = [
        {
          condition = "gitdir:~/Dev/workin/realm/";
          contents = {
            user = {
              name = "Cameron Kientz";
              email = "cameron@realm.security";
            };
          };
        }
        {
          condition = "gitdir:~/Dev/goofin/";
          contents = {
            commit.gpgsign = true;
            gpg.format = "ssh";
            user = {
              email = "cameronkientz@proton.me";
              signingkey = "~/.ssh/id_ed25519";
            };
          };
        }
      ];
    };

    # Terminals
    terminal.alacritty.enable = true;

    # Tmux with macOS-specific settings
    tmux = {
      enable = true;
      enableImagePassthrough = true;
      enableVimNavigator = true;
      enableSmartSplits = true;
      rightPlugins = "battery network time";
      leftPlugins = "git kube";
      extraConfig = ''
        # macOS: use Nix-managed zsh
        set -g default-command "${pkgs.zsh}/bin/zsh"

        # tmux2k display options
        set -g @tmux2k-show-powerline true
        set -g @tmux2k-show-flags true
        set -g @tmux2k-military-time true
      '';
    };

    # Directory navigation
    zoxide.enable = true;

    # Kubectl helper scripts
    scripts.kubectl.enable = true;
  };

  # Additional packages
  home.packages = with pkgs; [
    maple-mono.NF
    git-lfs
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
