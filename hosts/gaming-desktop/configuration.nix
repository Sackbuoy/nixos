# Gaming Desktop NixOS Configuration
# GPU: Nvidia (proprietary drivers)
# CPU: Intel
{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
  ];

  # ============================================================================
  # System Module Configuration (mySystem.*)
  # ============================================================================

  mySystem = {
    # Graphics/GPU — Nvidia proprietary drivers
    # Set nvidia.open = true if you have an RTX 2000 (Turing) or newer GPU
    # for better Wayland support via the open kernel module.
    graphics = {
      enable = true;
      driver = "nvidia";
      enable32Bit = true; # Required for Steam/Wine
      nvidia.open = false; # flip to true for RTX 2000+
    };

    # Nix settings
    nix = {
      enableFlakes = true;
      gc = {
        enable = true;
        olderThan = "7d";
        frequency = "daily";
      };
      trustedUsers = ["root" "sackbuoy"];
      allowUnfree = true;
    };

    # Locale
    locale = {
      timezone = "America/Chicago";
      language = "en_US.UTF-8";
    };

    # Audio with Bluetooth
    audio = {
      enable = true;
      bluetooth.enable = true;
      jack.enable = true;
    };

    # Container runtime
    containers = {
      enable = true;
      backend = "docker";
      dockerCompat = true;
    };

    # No power management needed for a desktop
    power.enable = false;

    # Keyboard remapping
    keyd = {
      enable = true;
      capsLockBehavior = "escape-meta";
      swapEscapeCapsLock = true;
    };

    # Desktop environment
    desktop = {
      enable = true;
      defaultBrowser = "zen.desktop";
      hyprland.enable = false;
      niri = {
        enable = true;
        setAsDefault = true;
      };
    };
  };

  # ============================================================================
  # CPU — Intel microcode updates
  # ============================================================================

  hardware.cpu.intel.updateMicrocode = true;

  # ============================================================================
  # Bootloader
  # ============================================================================

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ============================================================================
  # Users
  # ============================================================================

  users.defaultUserShell = pkgs.zsh;

  users.users.sackbuoy = {
    isNormalUser = true;
    description = "cameron";
    shell = pkgs.zsh;
    extraGroups = ["networkmanager" "wheel" "docker" "dialout" "input"];
  };

  # ============================================================================
  # Programs
  # ============================================================================

  programs.zsh.enable = true;
  programs.fish.enable = true;

  # GameMode: lets games request performance optimisations at runtime
  programs.gamemode.enable = true;

  programs.nix-index-database.comma.enable = true;

  # Steam + Gamescope session
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    # Allow Steam to open ports in the firewall for Remote Play / In-Home Streaming
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = false;
  };

  # ============================================================================
  # Services
  # ============================================================================

  services.tailscale.enable = true;
  services.openssh.enable = true;
  services.printing.enable = false;
  services.flatpak.enable = false;

  # Open WebUI for local LLM
  services.open-webui = {
    enable = false;
    package = pkgs.open-webui;
    environment = {
      ANONYMIZED_TELEMETRY = "False";
      DO_NOT_TRACK = "True";
      SCARF_NO_ANALYTICS = "True";
      OLLAMA_API_BASE_URL = "http://10.0.0.55:11434/api";
      OLLAMA_BASE_URL = "http://10.0.0.55:11434";
    };
  };

  # ============================================================================
  # Environment
  # ============================================================================

  # Secret storage for Chromium-based browsers
  environment.sessionVariables.KWALLET_PAM_LOGIN = "1";

  # Steam Proton compatibility tools
  environment.sessionVariables.STEAM_EXTRA_COMPAT_TOOLS_PATHS =
    "/home/sackbuoy/.steam/root/compatibilitytools.d";

  # Nvidia + Wayland: GBM backend (uncomment if you hit black screens with some apps)
  # environment.sessionVariables.GBM_BACKEND = "nvidia-drm";

  # ============================================================================
  # Fonts
  # ============================================================================

  fonts.packages = [
    pkgs.maple-mono.NF
    pkgs.nerd-fonts.symbols-only
  ];

  # ============================================================================
  # System Packages
  # ============================================================================

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    tmux
    ripgrep
    libgcc
    tailscale
    wayle
    libnotify
    glib
    libcap
    lsof
    alejandra
    kdePackages.kwallet
    kdePackages.kwalletmanager
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default

    # Gaming tools
    mangohud       # Performance overlay for games
    protonup-ng    # Manage Proton-GE versions
    lutris         # Game launcher / manager
    heroic         # Epic / GOG launcher
    bottles        # Wine prefix manager
    xwayland-satellite
  ];

  # ============================================================================
  # State Version
  # ============================================================================

  system.stateVersion = "24.11";
}
