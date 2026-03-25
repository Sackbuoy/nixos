{config, ...}: {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 36;
        spacing = 0;
        modules-left = ["custom/launcher" "custom/workspace"];
        modules-center = ["clock"];
        modules-right = ["pulseaudio" "network" "bluetooth" "battery" "tray"];

        "custom/launcher" = {
          format = "";
          on-click = "wofi --show drun";
          tooltip = false;
        };

        "custom/workspace" = {
          exec = "niri msg -j workspaces | jq -r '.[] | select(.is_focused) | .idx'";
          interval = 1;
          format = "{}";
          tooltip = false;
        };

        clock = {
          format = "  {:%a %b %d   %h:%M}";
          tooltip-format = "<tt>{calendar}</tt>";
        };

        pulseaudio = {
          format = "{icon}  {volume}%";
          format-muted = "  muted";
          format-icons = {
            default = ["" "" ""];
          };
          on-click = "pavucontrol";
          tooltip = false;
        };

        network = {
          format-wifi = "  {essid}";
          format-ethernet = "󰈀  Wired";
          format-disconnected = "  disconnected";
          on-click = "ghostty --class=toolbarApp --window-width=80 --window-height=25 -e nmtui";
          tooltip-format = "{ipaddr}/{cidr}";
        };

        bluetooth = {
          format = "";
          format-connected = " {device_alias}";
          format-disabled = "!";
          on-click = "ghostty --class=toolbarApp --window-width=80 --window-height=25 -e bluetui";
          tooltip-format = "{status}";
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon}  {capacity}%";
          format-charging = "  {capacity}%";
          format-plugged = "  {capacity}%";
          format-icons = ["" "" "" "" ""];
          tooltip-format = "{timeTo}";
        };

        tray = {
          icon-size = 16;
          spacing = 8;
        };
      };
    };

    style = builtins.readFile ./style.css;
  };
}
