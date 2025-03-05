{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.wofi
    pkgs.nautilus
    pkgs.waybar
    pkgs.kitty
    pkgs.brightnessctl
    pkgs.hyprshot
    pkgs.hyprpolkitagent
    pkgs.libsForQt5.qt5.qtwayland # needed for some apps to load right
    pkgs.playerctl
    pkgs.wf-recorder
    pkgs.slurp
  ];

  # hyprland "must haves"
  security.polkit.enable = true;

  programs.hyprland = {
    enable = true;
    # withUWSM  = true; # "recommended" but breaks hypr utilities
  };
}
