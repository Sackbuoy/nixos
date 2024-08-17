{ config, pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 15;
        # // Choose the order of the modules
        "modules-left" = [
          "hyprland/workspaces"
        ];
        "modules-center" = [
          "clock"
        ];
        "modules-right" = [
          "pulseaudio"
          # "custom/mem"
          # "backlight"
          "network"
          "battery"
          "tray"
        ];

        "hyprland/workspaces" = {
          "icon-size" = 32;
          "spacing" = 16;
          "on-scroll-up" = "hyprctl dispatch workspace r+1";
          "on-scroll-down" = "hyprctl dispatch workspace r-1";
        };

        "clock" = {
            "timezone" = "America/Chicago";
            "max-length" = 50;
            "format" = "{:%I:%M %p}";
        };

        "network" = {
          "format-wifi" = "{essid}  ";
        };

        "pulseaudio" = {
            # // "scroll-step" = 1; // %, can be a float
            "reverse-scrolling" = 1;
            "format" = "{volume}% {icon}";
            # "format-bluetooth" = "{volume}% {icon} {format_source}";
            # "format-bluetooth-muted" = "󰂲 {icon} {format_source}";
            # "format-muted" = "󰝟 {format_source}";
            # "format-source" = "{volume}% "; 
            # "format-source-muted" = "";
            "format-icons" = {
          # "headphone" = "";
          # "hands-free" = "";
          # "headset" = "";
          # "phone" = "";
          # "portable" = "";
          # "car" = "";
          "default" = [
            "󰸈"
            ""
            ""
            ""
          ];
            };
            "on-click" = "pavucontrol";
            "min-length" = 6;
        };

        "custom/mem" = {
            "format" = "{} 󰍛";
            "interval" = 3;
            "exec" = "free -h | awk '/Mem =/{printf $3}'";
            "tooltip" = false;
        };

        "temperature" = {
            # // "thermal-zone" = 2;
            # // "hwmon-path" = "/sys/class/hwmon/hwmon2/temp1_input";
            "critical-threshold" = 80;
            # // "format-critical" = "{temperatureC}°C {icon}";
            "format" = "{temperatureC}°C {icon}";
            "format-icons" = [
              ""
              ""
              ""
              ""
              ""
            ];
            "tooltip" = false;
        };

        "backlight" = {
            "device" = "intel_backlight";
            "format" = "{percent}% {icon}";
            "format-icons" = [
              ""
              ""
              ""
              ""
              ""
              ""
              ""
            ];
            "min-length" = 7;
        };

        "battery" = {
            "states" = {
              "warning" = 30;
              "critical" = 15;
            };
            "format" = "{capacity}% {icon}";
            "format-charging" = "{capacity}% 󰂄";
            "format-plugged" = "{capacity}% ";
            "format-alt" = "{time} {icon}";
            "format-icons" = [
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󰁹"
            ];
            # "on-update" = "$HOME/.config/waybar/scripts/check_battery.sh",
        };

        "tray" = {
            "icon-size" = 16;
            "spacing" = 0;
        };
      };
    };

    style = (builtins.readFile ./styles.css);
  };
}
