# Alacritty terminal configuration module
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.myHome.terminal.alacritty;
in {
  options.myHome.terminal.alacritty = {
    enable = mkEnableOption "alacritty terminal";

    font = {
      family = mkOption {
        type = types.str;
        default = "Maple Mono NF";
        description = "Font family to use";
      };

      size = mkOption {
        type = types.float;
        default = 11.0;
        description = "Font size";
      };
    };

    extraSettings = mkOption {
      type = types.attrs;
      default = {};
      description = "Extra alacritty settings";
    };
  };

  config = mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      settings = mkMerge [
        {
          font = {
            normal = {
              family = cfg.font.family;
              style = "Medium";
            };
            bold = {
              family = cfg.font.family;
              style = "Bold";
            };
            italic = {
              family = cfg.font.family;
              style = "Retina";
            };
            bold_italic = {
              family = cfg.font.family;
              style = "SemiBold";
            };
            size = cfg.font.size;
          };
        }
        cfg.extraSettings
      ];
    };
  };
}
