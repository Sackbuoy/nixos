{pkgs, ...}: {
  # determinate installation manages the daemon itself so this isn't needed
  nix.enable = false;

  nix.settings = {
    experimental-features = "nix-command flakes";
    trusted-users = ["@admin" "cameronkientz"];
  };

  nixpkgs.hostPlatform = "aarch64-darwin"; # or "x86_64-darwin" for Intel

  environment.systemPackages = with pkgs; [
    vim
    git
    neovim
  ];

  system.primaryUser = "cameronkientz";

  users.users.cameronkientz = {
    name = "cameronkientz";
    home = "/Users/cameronkientz";
  };

  # macOS-specific settings (optional)
  system.defaults = {
    dock.autohide = true;
    finder.AppleShowAllExtensions = true;
  };

  # Used for backwards compatibility
  system.stateVersion = 4;

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      upgrade = false;
    };

    global = {
      autoUpdate = false;
    };

    casks = ["meetingbar" "flycut" "multipass"];
  };

  services.aerospace = {
    enable = true;
    settings = {
      # See https://nikitabobko.github.io/AeroSpace/guide for config options
      workspace-to-monitor-force-assignment = {
        "1" = "DELL P2419HC";
        "4" = "DELL P2419HC";
        "7" = "DELL P2419HC";
        "2" = "DELL P2425H";
        "5" = "DELL P2425H";
        "8" = "DELL P2425H";
        "3" = "Built-in Retina Display";
        "6" = "Built-in Retina Display";
        "9" = "Built-in Retina Display";
      };

      mode.main.binding = {
        # Focus monitor
        ctrl-shift-h = "focus-monitor left";
        ctrl-shift-l = "focus-monitor right";

        # focus window on current workspace
        cmd-h = "focus left";
        cmd-l = "focus right";

        # focus workspace on current monitor
        alt-h = "workspace prev --wrap-around";
        alt-l = "workspace next --wrap-around";

        # Switch to specific workspaces
        alt-1 = "workspace 1";
        alt-2 = "workspace 2";
        alt-3 = "workspace 3";
        alt-4 = "workspace 4";
        alt-5 = "workspace 5";
        alt-6 = "workspace 6";
        alt-7 = "workspace 7";
        alt-8 = "workspace 8";
        alt-9 = "workspace 9";

        # Move window to specific workspace
        alt-shift-1 = "move-node-to-workspace 1";
        alt-shift-2 = "move-node-to-workspace 2";
        alt-shift-3 = "move-node-to-workspace 3";
        alt-shift-4 = "move-node-to-workspace 4";
        alt-shift-5 = "move-node-to-workspace 5";
        alt-shift-6 = "move-node-to-workspace 6";
        alt-shift-7 = "move-node-to-workspace 7";
        alt-shift-8 = "move-node-to-workspace 8";
        alt-shift-9 = "move-node-to-workspace 9";
      };
    };
  };
}
