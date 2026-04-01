# Keyboard remapping configuration module (keyd)
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mySystem.keyd;
in {
  options.mySystem.keyd = {
    enable = mkEnableOption "keyd keyboard remapping";

    capsLockBehavior = mkOption {
      type = types.enum ["escape" "meta" "escape-meta" "ctrl" "none"];
      default = "escape-meta";
      description = ''
        How CapsLock should behave:
        - escape: CapsLock acts as Escape
        - meta: CapsLock acts as Meta/Super
        - escape-meta: Tap for Escape, hold for Meta
        - ctrl: CapsLock acts as Control
        - none: Leave CapsLock unchanged
      '';
    };

    swapEscapeCapsLock = mkOption {
      type = types.bool;
      default = true;
      description = "Make Escape act as CapsLock (when capsLockBehavior is not 'none')";
    };

    extraSettings = mkOption {
      type = types.attrs;
      default = {};
      description = "Extra keyd settings";
    };
  };

  config = mkIf cfg.enable {
    services.keyd = {
      enable = true;
      keyboards = {
        default = {
          ids = ["*"];
          settings = mkMerge [
            {
              main = mkMerge [
                (mkIf (cfg.capsLockBehavior == "escape") {
                  capslock = "esc";
                })
                (mkIf (cfg.capsLockBehavior == "meta") {
                  capslock = "meta";
                })
                (mkIf (cfg.capsLockBehavior == "escape-meta") {
                  capslock = "overload(meta, esc)";
                })
                (mkIf (cfg.capsLockBehavior == "ctrl") {
                  capslock = "ctrl";
                })
                (mkIf (cfg.swapEscapeCapsLock && cfg.capsLockBehavior != "none") {
                  esc = "overload(esc, capslock)";
                })
              ];
            }
            cfg.extraSettings
          ];
        };
      };
    };
  };
}
