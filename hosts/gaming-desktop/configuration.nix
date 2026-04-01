# Gaming Desktop NixOS Configuration
# TODO: Configure this host for your gaming desktop
{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  # ============================================================================
  # System Module Configuration (mySystem.*)
  # ============================================================================

  mySystem = {
    # Nix settings
    nix = {
      enableFlakes = true;
      gc = {
        enable = true;
        olderThan = "7d";
      };
      trustedUsers = ["root" "sackbuoy"];
      allowUnfree = true;
    };

    # Locale
    locale = {
      timezone = "America/Chicago";
      language = "en_US.UTF-8";
    };

    # Audio - gaming setup
    audio = {
      enable = true;
      bluetooth.enable = true;
      jack.enable = false;
    };

    # Container runtime
    containers = {
      enable = true;
      backend = "podman";
    };

    # Desktop
    desktop = {
      enable = true;
      hyprland.enable = true;
    };

    # Keyboard remapping
    keyd = {
      enable = true;
      capsLockBehavior = "escape-meta";
    };
  };

  # ============================================================================
  # Bootloader
  # ============================================================================

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ============================================================================
  # Networking
  # ============================================================================

  networking.hostName = "gaming-desktop";
  networking.networkmanager.enable = true;

  # ============================================================================
  # Users
  # ============================================================================

  users.users.sackbuoy = {
    isNormalUser = true;
    description = "sackbuoy";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.zsh;
  };

  # ============================================================================
  # Programs
  # ============================================================================

  programs.zsh.enable = true;
  programs.gamemode.enable = true;
  # programs.steam.enable = true; # Uncomment for gaming!

  # ============================================================================
  # System Packages
  # ============================================================================

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    tmux
  ];

  # ============================================================================
  # State Version
  # ============================================================================

  system.stateVersion = "24.05";
}
