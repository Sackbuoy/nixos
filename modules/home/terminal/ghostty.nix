# Ghostty terminal configuration module
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.myHome.terminal.ghostty;
in {
  options.myHome.terminal.ghostty = {
    enable = mkEnableOption "ghostty terminal";

    package = mkOption {
      type = types.package;
      # nixpkgs' `ghostty` is Linux-only; `ghostty-bin` is the prebuilt macOS app
      default =
        if pkgs.stdenv.isDarwin
        then pkgs.ghostty-bin
        else pkgs.ghostty;
      description = "Ghostty package to install";
    };

    extraSettings = mkOption {
      type = types.attrs;
      default = {};
      description = "Extra ghostty settings";
    };
  };

  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      package = cfg.package;
      settings = mkMerge [
        {
          theme = "tokyo-night";
          font-size = 13;
          font-family = "AnkaCoder";
          font-feature = "+liga";
          cursor-style = "block";
          cursor-style-blink = false;
          shell-integration-features = "no-cursor,title";
          mouse-hide-while-typing = true;
          bell-features = "no-audio";
          window-padding-y = 0;
          window-padding-x = 0;
          window-padding-balance = true;
          window-padding-color = "extend";

          keybind = [
            "cmd+c=copy_to_clipboard"
            "cmd+v=paste_from_clipboard"
            # tmux window nav (matches user-keys in modules/home/tmux/default.nix)
            "ctrl+super+h=text:\\x1b[104;13u"
            "ctrl+super+l=text:\\x1b[108;13u"
          ];

          app-notifications = "no-clipboard-copy";
          quit-after-last-window-closed = true;

          background-opacity = 1.0;

          # Contrast overrides on top of TokyoNight Storm
          # Stock bg is #24283b, pulled darker toward pure night
          background = "#1a1e2e";
          # Stock fg is #c0caf5, nudged toward a crisper white-blue
          foreground = "#d5deff";
        }
        cfg.extraSettings
      ];
    };
  };
}
