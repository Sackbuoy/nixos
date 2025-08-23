{pkgs, ...}: let
  assignWorkspacesScript = import ./scripts/assign-workspaces.nix {inherit pkgs;};
in {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        unlock_cmd = "${assignWorkspacesScript}/bin/assign-workspaces && systemctl --user start hyprpanel";
        on_lock_cmd = "systemctl --user stop hyprpanel";
        on_unlock_cmd = "systemctl --user start hyprpanel";
      };

      listener = [
        {
          timeout = 150; # 2.5min.
          on-timeout = "brightnessctl -s set 10"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
          on-resume = "brightnessctl -r"; # monitor backlight restore.
        }

        # turn off keyboard backlight, comment out this section if you dont have a keyboard backlight.
        {
          timeout = 150; # 2.5min.
          on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0"; # " turn off keyboard backlight.
          on-resume = "brightnessctl -rd rgb:kbd_backlight"; # turn on keyboard backlight.
        }

        {
          timeout = 300; # 5min
          on-timeout = "pidof hyprlock || hyprlock"; # lock screen when timeout has passed
        }

        {
          timeout = 600; # 10min
          on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
          on-resume = "hyprctl dispatch dpms on"; # screen on when activity is detected after timeout has fired.
        }

        {
          timeout = 1200; # 20min
          on-timeout = "systemctl suspend"; # suspend pc
        }
      ];
    };
  };
}
