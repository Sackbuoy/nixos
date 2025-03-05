{pkgs, ...}: {
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  environment.systemPackages = [
    pkgs.wl-clipboard
  ];

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # to enable X11 version of gnome -> just makes the option
  # available on boot
  services.xserver.autorun = false;
  services.xserver.displayManager.startx.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    variant = "";
    layout = "us";
  };
}
