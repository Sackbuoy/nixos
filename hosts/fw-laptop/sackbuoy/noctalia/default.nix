# Noctalia Shell configuration for Niri
# A sleek and minimal desktop shell for Wayland
{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia-shell = {
    enable = true;

    settings = {
      # Bar configuration - top position like current waybar
      bar = {
        position = "top";
        density = "default";
        showCapsule = true;
        capsuleOpacity = 1;
        backgroundOpacity = 0.93;
        marginVertical = 4;
        marginHorizontal = 4;
        frameRadius = 12;
        outerCorners = true;

        widgets = {
          left = [
            {
              id = "Launcher";
            }
            {
              id = "Clock";
            }
            {
              id = "ActiveWindow";
            }
            {
              id = "MediaMini";
            }
          ];
          center = [
            {
              id = "Workspace";
              hideUnoccupied = false;
              labelMode = "none";
            }
          ];
          right = [
            {
              id = "Tray";
            }
            {
              id = "NotificationHistory";
            }
            {
              id = "Battery";
              alwaysShowPercentage = true;
              warningThreshold = 30;
            }
            {
              id = "Volume";
            }
            {
              id = "Brightness";
            }
            {
              id = "Network";
            }
            {
              id = "Bluetooth";
            }
            {
              id = "ControlCenter";
            }
          ];
        };
      };

      # Disable dock as requested
      dock = {
        enabled = false;
      };

      # General settings
      general = {
        radiusRatio = 1;
        animationSpeed = 1;
        enableShadows = true;
        enableBlurBehind = true;
        lockOnSuspend = true;
        showSessionButtonsOnLockScreen = true;
      };

      # UI settings
      ui = {
        tooltipsEnabled = true;
        panelBackgroundOpacity = 0.93;
        panelsAttachedToBar = true;
      };

      # Wallpaper - let Noctalia manage it
      wallpaper = {
        enabled = true;
        overviewEnabled = true;
        fillMode = "crop";
      };

      # App launcher settings
      appLauncher = {
        position = "center";
        sortByMostUsed = true;
        viewMode = "list";
        showCategories = true;
        enableSettingsSearch = true;
        enableWindowsSearch = true;
        enableSessionSearch = true;
        enableClipboardHistory = true;
      };

      # Control center shortcuts
      controlCenter = {
        position = "close_to_bar_button";
        shortcuts = {
          left = [
            {id = "Network";}
            {id = "Bluetooth";}
            {id = "WallpaperSelector";}
            {id = "NoctaliaPerformance";}
          ];
          right = [
            {id = "Notifications";}
            {id = "PowerProfile";}
            {id = "KeepAwake";}
            {id = "NightLight";}
          ];
        };
      };

      # Night light (replaces hyprsunset)
      nightLight = {
        enabled = false; # User can enable via UI
        autoSchedule = true;
        nightTemp = "4000";
        dayTemp = "6500";
      };

      # Idle management (replaces hypridle)
      idle = {
        enabled = true;
        screenOffTimeout = 600; # 10 minutes
        lockTimeout = 660; # 11 minutes
        suspendTimeout = 1800; # 30 minutes
        fadeDuration = 5;
      };

      # Notifications
      notifications = {
        enabled = true;
        location = "top_right";
        normalUrgencyDuration = 8;
        criticalUrgencyDuration = 15;
      };

      # OSD for volume/brightness
      osd = {
        enabled = true;
        location = "top_right";
        autoHideMs = 2000;
      };

      # Audio settings
      audio = {
        volumeStep = 5;
        volumeOverdrive = false;
      };

      # Brightness settings
      brightness = {
        brightnessStep = 5;
        enforceMinimum = true;
      };
    };
  };
}
