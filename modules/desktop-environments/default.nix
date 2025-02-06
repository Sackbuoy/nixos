{ pkgs, ...}:
{
  imports = 
  [
    ./gnome.nix
    ./hyprland.nix
    ./kde.nix
  ];

  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "matrix";
      # hide_borders = true;
      # clear_password = true;
      # bigclock = "en";
    };
  };
}
