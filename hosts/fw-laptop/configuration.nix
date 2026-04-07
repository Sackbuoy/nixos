# Framework Laptop NixOS Configuration
{
  pkgs,
  lib,
  inputs,
  ...
}: let
  disk1 = "/var/lib/plexmediaserver/disk1";
  disk2 = "/var/lib/plexmediaserver/disk2";
in {
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
  ];

  # ============================================================================
  # System Module Configuration (mySystem.*)
  # ============================================================================

  mySystem = {
    # Graphics/GPU
    graphics = {
      enable = true;
      driver = "amdgpu";
      enable32Bit = true;
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
      backend = "podman";
      dockerCompat = true;
    };

    # Power management for laptop
    power = {
      enable = true;
      batteryGovernor = "powersave";
      batteryTurbo = "never";
      chargerGovernor = "performance";
      chargerTurbo = "auto";
    };

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
      hyprland.enable = true;
      niri = {
        enable = true;
        setAsDefault = true;
      };
    };
  };

  # ============================================================================
  # Bootloader
  # ============================================================================

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ============================================================================
  # Display Manager
  # ============================================================================

  # Ly display manager (from existing module)
  # Imported via modules/system/ly.nix

  # ============================================================================
  # Users
  # ============================================================================

  users.defaultUserShell = pkgs.zsh;

  users.users.sackbuoy = {
    isNormalUser = true;
    description = "cameron";
    shell = pkgs.zsh;
    extraGroups = ["networkmanager" "wheel" "docker"];
  };

  # ============================================================================
  # Programs
  # ============================================================================

  programs.zsh.enable = true;
  programs.fish.enable = true;
  programs.firefox.enable = true;
  programs.gamemode.enable = true;
  programs.nix-index-database.comma.enable = true;
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  # ============================================================================
  # Services
  # ============================================================================

  services.tailscale.enable = true;
  services.openssh.enable = true;
  services.printing.enable = false;
  services.flatpak.enable = false;
  services.fwupd.enable = true;
  services.rpcbind.enable = true;

  # Open WebUI for local LLM
  services.open-webui = {
    enable = true;
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
  # Systemd Services
  # ============================================================================

  # Fix network after suspend
  systemd.services.fix-network-after-suspend = {
    description = "Fix network after suspend";
    wantedBy = ["suspend.target"];
    after = ["suspend.target"];
    script = ''
      ${pkgs.systemd}/bin/systemctl restart NetworkManager
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  # ============================================================================
  # Environment
  # ============================================================================

  # Secret storage for Chromium-based browsers
  environment.sessionVariables.KWALLET_PAM_LOGIN = "1";

  # Steam Proton compatibility tools
  environment.sessionVariables.STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/sackbuoy/.steam/root/compatibilitytools.d";

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
    hyprpanel
    libnotify
    glib
    libcap
    lsof
    alejandra
    kdePackages.kwallet
    kdePackages.kwalletmanager
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    mangohud
    protonup
    xwayland-satellite
  ];

  # ============================================================================
  # State Version
  # ============================================================================

  system.stateVersion = "24.11";

  # ============================================================================
  # NFS Mounts (commented out)
  # ============================================================================

  # fileSystems = {
  #   "${disk1}" = {
  #     device = "homelab:${disk1}";
  #     fsType = "nfs";
  #     options = ["x-systemd.requires=tailscaled.service" "x-systemd.automount" "noauto" "noatime" "rw" "bg" "_netdev" "nofail"];
  #   };
  #   "${disk2}" = {
  #     device = "homelab:${disk2}";
  #     fsType = "nfs";
  #     options = ["x-systemd.requires=tailscaled.service" "x-systemd.automount" "noauto" "noatime" "rw" "bg" "_netdev" "nofail"];
  #   };
  # };
}
