# GPU/Graphics configuration module
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mySystem.graphics;
in {
  options.mySystem.graphics = {
    enable = mkEnableOption "GPU/graphics acceleration";

    driver = mkOption {
      type = types.enum ["amdgpu" "intel" "nouveau"];
      default = "amdgpu";
      description = "GPU driver to use";
    };

    enable32Bit = mkOption {
      type = types.bool;
      default = true;
      description = "Enable 32-bit DRI support (needed for Steam/Wine)";
    };
  };

  config = mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = cfg.enable32Bit;
    };
    services.xserver.videoDrivers = [cfg.driver];
  };
}
