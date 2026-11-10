# Herdr configuration module
# Manages ~/.config/herdr/config.toml with tmux-matching keybinds
{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.myHome.herdr;
in {
  options.myHome.herdr = {
    enable = mkEnableOption "herdr configuration";
  };

  config = mkIf cfg.enable {
    xdg.configFile."herdr/config.toml".text = ''
      # Herdr configuration
      # Keybinds mirror the tmux config as closely as possible.

      [keys]
      # Prefix key — same as tmux (ctrl+b)
      prefix = "ctrl+b"

      # Pane splitting — tmux: prefix+v (vertical) / prefix+s (horizontal)
      split_vertical   = "prefix+v"
      split_horizontal = "prefix+s"

      # Remap settings away from prefix+s to avoid conflict with split_horizontal
      settings = "prefix+shift+s"

      # Pane focus — tmux: prefix+h/j/k/l
      focus_pane_left  = "prefix+h"
      focus_pane_down  = "prefix+j"
      focus_pane_up    = "prefix+k"
      focus_pane_right = "prefix+l"

      # Tab (window) management — tmux: prefix+c (new), prefix+t / space (next), prefix+T (prev)
      new_tab       = "prefix+c"
      next_tab      = ["prefix+n", "prefix+t", "prefix+space", "ctrl+super+l"]
      previous_tab  = ["prefix+p", "prefix+shift+t", "ctrl+super+h"]

      # Detach — tmux default is prefix+d (herdr default is prefix+q)
      detach = "prefix+d"

      # Copy mode — same as tmux: prefix+[
      copy_mode = "prefix+["

      # Zoom — same as tmux: prefix+z
      zoom = "prefix+z"
    '';
  };
}
