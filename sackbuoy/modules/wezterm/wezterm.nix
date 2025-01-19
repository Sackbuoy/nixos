{
  programs.wezterm = {
    enable = false; # doesn't render right on hyprland, use flatpak

    extraConfig = (builtins.readFile ./wezterm.lua);
  };
}
