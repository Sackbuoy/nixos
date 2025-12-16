{pkgs, ...}: {
  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "matrix";
      # hide_borders = true;
      # clear_password = true;
      # bigclock = "en";
    };
  };
  # services.displayManager.cosmic-greeter.enable = true;
  # services.desktopManager.cosmic.enable = true;
}
