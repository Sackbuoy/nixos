{
  programs.hyprpanel = {
    enable = true;
    settings = {
      scalingPriority = "hyprland";
      bar = {
        layouts = {
          "0" = {
            left = ["dashboard" "workspaces"];
            middle = ["clock"];
            right = ["volume" "network" "bluetooth" "battery"];
          };
        };
        launcher.autoDetectIcon = true;
        workspaces.show_numbered = true;
      };
    };
  };
}
