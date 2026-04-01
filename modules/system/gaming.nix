# Gaming configuration for NixOS with AMD hardware
# Includes: Steam, Lutris, MangoHud, Gamescope, and controller support
{
  pkgs,
  lib,
  config,
  ...
}: let
  # Wrapper: gamescope runs natively, child command runs in steam-run
  gamescope-steam = pkgs.writeShellScriptBin "gamescope-steam" ''
    # Find where FIRST -- separates gamescope args from the command
    GAMESCOPE_ARGS=()
    COMMAND_ARGS=()
    found_separator=false
    
    for arg in "$@"; do
      if [ "$arg" = "--" ] && [ "$found_separator" = false ]; then
        found_separator=true
      elif [ "$found_separator" = false ]; then
        GAMESCOPE_ARGS+=("$arg")
      else
        COMMAND_ARGS+=("$arg")
      fi
    done
    
    # Create a temporary script that preserves all environment variables
    # This is needed because steam-run may not pass all vars through
    TMPSCRIPT=$(mktemp /tmp/gamescope-steam.XXXXXX)
    chmod +x "$TMPSCRIPT"
    
    # Write current environment to the script
    {
      echo '#!/usr/bin/env bash'
      # Export all STEAM/Proton related variables
      env | grep -E '^(STEAM_|SteamApp|SteamGame|PROTON_|DXVK_|WINE|VK_|RADV_|MESA_|XDG_)' | while read -r line; do
        echo "export '$line'"
      done
      # Execute the actual command
      echo 'exec "$@"'
    } > "$TMPSCRIPT"
    
    # Cleanup on exit
    trap "rm -f '$TMPSCRIPT'" EXIT
    
    # Use the system gamescope wrapper (has capabilities)
    exec /run/wrappers/bin/gamescope "''${GAMESCOPE_ARGS[@]}" -- \
      ${pkgs.steam-run}/bin/steam-run "$TMPSCRIPT" "''${COMMAND_ARGS[@]}"
  '';
in {
  # AMD GPU Configuration
  # Using hardware.graphics (the newer option replacing hardware.opengl)
  hardware.graphics = {
    enable = true;
    # 32-bit support for Steam and older games
    enable32Bit = true;
    # Extra packages for video acceleration
    # Note: RADV (Mesa Vulkan) is enabled by default and is the best option for AMD
    extraPackages = with pkgs; [
      # Video acceleration for AMD
      libvdpau-va-gl
      vaapiVdpau
      # ROCm OpenCL (optional, for compute workloads)
      rocmPackages.clr
      rocmPackages.clr.icd
    ];
    extraPackages32 = with pkgs.driversi686Linux; [
      libvdpau-va-gl
    ];
  };

  # Environment variables for AMD
  environment.variables = {
    # Enable RADV shader cache optimizations
    RADV_PERFTEST = "gpl";
  };

  # Steam
  programs.steam = {
    enable = true;
    # Open ports for Steam Remote Play and Source games
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    # Enable Steam hardware (controller support, etc.)
    # Gamescope compositor for better game compatibility
    gamescopeSession.enable = true;
    # Extra packages available to Steam games
    extraPackages = with pkgs; [
      gamescope
      mangohud
    ];
  };

  # Gamescope - SteamOS session compositor
  programs.gamescope = {
    enable = true;
    capSysNice = true; # Allow nice priority for better performance
    args = [
      "--grab" # Confine mouse to game window (release with Super+Tab or Alt+Tab)
    ];
  };

  # Gamemode - already enabled in your config, but ensuring it's here for completeness
  programs.gamemode = {
    enable = true;
    enableRenice = true; # Allow renice for better game priority
    settings = {
      general = {
        renice = 10;
        softrealtime = "auto";
        inhibit_screensaver = 1;
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
        amd_performance_level = "high";
      };
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
      };
    };
  };

  # Controller/Gamepad Support
  hardware.steam-hardware.enable = true; # Steam controller and other Steam hardware

  # Xbox controller support (including wireless via xpadneo)
  hardware.xpadneo.enable = true;

  # Extra udev rules for controllers
  services.udev.extraRules = ''
    # Xbox One/Series wireless adapter
    SUBSYSTEM=="usb", ATTR{idVendor}=="045e", ATTR{idProduct}=="02e6", MODE="0666"
    SUBSYSTEM=="usb", ATTR{idVendor}=="045e", ATTR{idProduct}=="02fe", MODE="0666"
    SUBSYSTEM=="usb", ATTR{idVendor}=="045e", ATTR{idProduct}=="0719", MODE="0666"

    # DualShock 4 / DualSense (PS4/PS5 controllers)
    # PS4 controller (USB)
    SUBSYSTEM=="usb", ATTR{idVendor}=="054c", ATTR{idProduct}=="05c4", MODE="0666"
    # PS4 controller v2 (USB)
    SUBSYSTEM=="usb", ATTR{idVendor}=="054c", ATTR{idProduct}=="09cc", MODE="0666"
    # PS5 DualSense (USB)
    SUBSYSTEM=="usb", ATTR{idVendor}=="054c", ATTR{idProduct}=="0ce6", MODE="0666"
    # PS5 DualSense Edge (USB)
    SUBSYSTEM=="usb", ATTR{idVendor}=="054c", ATTR{idProduct}=="0df2", MODE="0666"
  '';

  # Gaming packages
  environment.systemPackages = with pkgs; [
    # Gamescope wrapper for Steam games (FHS compatible)
    gamescope-steam
    # Performance overlay
    mangohud
    # Lutris - multi-platform game launcher
    lutris
    # Wine and dependencies for non-Steam games
    wineWowPackages.staging
    winetricks
    # Vulkan tools for debugging
    vulkan-tools
    vulkan-loader
    # GPU monitoring
    nvtopPackages.amd
    # Proton-GE custom (better compatibility for some games)
    protonup-qt
    # Additional gaming utilities
    gamemode
    # Controller configuration tool
    antimicrox
  ];

  # Add user to input group for controller access
  users.users.sackbuoy.extraGroups = ["input" "gamemode"];

  # Boot parameters for better gaming performance
  boot.kernel.sysctl = {
    # Increase max open files (some games need this)
    "fs.file-max" = 2097152;
    # Better memory management for gaming
    "vm.max_map_count" = 2147483642; # Required for some games/Proton
    # Reduce swap tendency (keep games in RAM)
    "vm.swappiness" = 10;
  };
}
