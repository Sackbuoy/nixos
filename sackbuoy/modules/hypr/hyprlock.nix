{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
        no_fade_in = false;
      };

      background = [
        {
          path = "~/.config/nixos/sackbuoy/wallpapers/pretty.jpg";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      label = {
        monitor = "";
        text = "$TIME12";
        color = "rgb(c3c3c3)";
        font_size = 96;
        font_family = "SF Pro Display";
        position = "32, 80";
        halign = "center";
        valign = "center";
      };

      input-field = [
        {
          size = "280, 70";
          position = "0, -80";
          monitor = "";
          rounding = "15";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 5;
          placeholder_text = "'<span foreground=\"##cad3f5\">Password...</span>'";
          shadow_passes = 2;
        }
      ];
    };
  };
}
