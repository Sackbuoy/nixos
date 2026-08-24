# Noctalia Shell configuration for gaming-desktop
# Same as fw-laptop but without the Battery widget (desktop has no battery).
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
      # Bar configuration
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
              formatHorizontal = "h:mm AP ddd, MMM dd";
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
            # No Battery widget — this is a desktop
            {
              id = "Volume";
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

      # Wallpaper
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

      # Night light
      nightLight = {
        enabled = false;
        autoSchedule = true;
        nightTemp = "4000";
        dayTemp = "6500";
      };

      # Idle management — more relaxed timeouts for a desktop
      idle = {
        enabled = true;
        screenOffTimeout = 900;  # 15 minutes
        lockTimeout = 960;       # 16 minutes
        suspendTimeout = 0;      # 0 = never suspend (desktop)
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
