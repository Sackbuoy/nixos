{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pkgs.bluetui # for bluetui
    pkgs.brightnessctl # brightness
    pkgs.clipse # clipboard history
    pkgs.pavucontrol # for pavucontrol
    pkgs.networkmanager # for nmtui
  ];

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
          # "wireplumber"
          "temperature"
          "cpu"
          "memory"
          "pulseaudio"
          "bluetooth"
          # "backlight"
          "network"
          "battery"
        ];

        "bluetooth" = {
          "format" = " {status}";
          "format-disabled" = "";
          "format-connected" = " {num_connections} connected";
	        "tooltip-format" = "{controller_alias}\t{controller_address}";
	        "tooltip-format-connected" = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
	        "tooltip-format-enumerate-connected" = "{device_alias}\t{device_address}";
          "on-click" = "alacritty --class toolbarApp -e bluetui";
        };

        "hyprland/workspaces" = {
          "format" = "{icon}";
          "separate-outputs" = true;
          "icon-size" = 32;
          "spacing" = 16;
          "on-scroll-up" = "hyprctl dispatch workspace r+1";
          "on-scroll-down" = "hyprctl dispatch workspace r-1";
        };

        "clock" = {
            "timezone" = "America/Chicago";
            "max-length" = 50;
            "format" = "{:%I:%M %p}";
            "format-alt" = "{:%A, %B %d, %Y (%I:%M %p)}";
        };

        "cpu" = {
          "interval" = 10;
          "format" = "| {} ";
          "max-length" = 10;
        };

        "memory" = {
          "interval" = 30;
          "format" = "| {}% ";
          "max-length" = 10;
        };

        "network" = {
          "format-wifi" = "{essid}  ";
          "format-ethernet" = "Wired";
          "format-disconnected" = "";
          "on-click" = "alacritty --class toolbarApp -e nmtui";
        };

        # would love to use wireplumber instead: https://github.com/dyegoaurelio/simple-wireplumber-gui
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

        # would love to use this: https://github.com/dyegoaurelio/simple-wireplumber-gui
        # "wireplumber" = {
        #   "format" = "{volume}% {icon}";
        #   "format-muted" = "";
        #   "on-click" = "helvum";
        #   "format-icons" = ["" "" ""];
        #   "on-scroll-down" = "wpctl ARG";
        #   "on-scroll-up" = "wpctl ARG";
        # };

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
              "🔅"
              "🔆"
            ];
            "on-scroll-down" = "brightnessctl s 5+";
            "on-scroll-up" = "brightnessctl s 5-";
        };

        "battery" = {
            "states" = {
              "warning" = 30;
              "critical" = 15;
            };
            "format" = "{capacity}% {icon}";
            "format-charging" = "{capacity}% 󰂄";
            "format-plugged" = "{capacity}% ";
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
            "on-click" = "hyprlock";
        };
      };
    };

    style = (builtins.readFile ./styles.css);
  };
}
