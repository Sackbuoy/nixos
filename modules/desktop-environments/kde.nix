{pkgs, ...}: {
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  environment.systemPackages = [
    pkgs.wl-clipboard
  ];

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.kdePackages.ksshaskpass.out}/bin/ksshaskpass";

  # Configure keymap in X11
  services.xserver.xkb = {
    variant = "";
    layout = "us";
  };
}
