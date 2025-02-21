{
  services.dunst = {
    enable = false;
    settings = {
      global = {
        width = 300;
        height = 300;
        offset = "10x10";
        origin = "top-right";
        transparency = 10;
        frame_color = "#6AB187";
        frame_width = 3;
        font = "Droid Sans 9";
        follow = "mouse";

        padding = 12;
        horizontal_padding = 12;

        corner_radius = 20;
      };

      urgency_normal = {
        background = "#2A3132";
        foreground = "#eceff1";
        timeout = 10;
      };
    };
  };
}
