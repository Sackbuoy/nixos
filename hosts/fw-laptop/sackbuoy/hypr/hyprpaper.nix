{
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;

      preload = [
        "~/.config/nixos/wallpapers/pretty.jpg"
      ];

      wallpaper = [
        ",~/.config/nixos/wallpapers/pretty.jpg"
      ];
    };
  };
}
