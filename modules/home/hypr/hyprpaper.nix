{
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;

      preload = [
        "~/.config/nixos/sackbuoy/wallpapers/pretty.jpg"
        "~/.config/nixos/wallpapers/pretty.jpg"
      ];

      wallpaper = [
        ",~/.config/nixos/sackbuoy/wallpapers/pretty.jpg"
        "~/.config/nixos/wallpapers/pretty.jpg"
      ];
    };
  };
}
