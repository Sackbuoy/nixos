# GPU/Graphics configuration module
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mySystem.graphics;
  isNvidia = cfg.driver == "nvidia";
  isAmd = cfg.driver == "amdgpu";
in {
  options.mySystem.graphics = {
    enable = mkEnableOption "GPU/graphics acceleration";

    driver = mkOption {
      type = types.enum ["amdgpu" "intel" "nouveau" "nvidia"];
      default = "amdgpu";
      description = "GPU driver to use";
    };

    enable32Bit = mkOption {
      type = types.bool;
      default = true;
      description = "Enable 32-bit DRI support (needed for Steam/Wine)";
    };

    nvidia = {
      open = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Use the open-source Nvidia kernel module.
          Requires a Turing GPU (RTX 2000 series) or newer.
          Set to true for RTX 2000+ for better Wayland compatibility.
        '';
      };

      package = mkOption {
        type = types.nullOr types.raw;
        default = null;
        defaultText = literalExpression "config.boot.kernelPackages.nvidiaPackages.stable";
        description = ''
          Nvidia driver package to use. Defaults to the stable package.
          Override with e.g. config.boot.kernelPackages.nvidiaPackages.beta
          or nvidiaPackages.production for older hardware.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = cfg.enable32Bit;

      extraPackages = with pkgs;
        if isAmd
        then [
          rocmPackages.clr
          rocmPackages.clr.icd
        ]
        else if isNvidia
        then [
          # VA-API support via NVDEC (hardware video decoding in browsers, mpv, etc.)
          nvidia-vaapi-driver
          vaapiVdpau
          libvdpau-va-gl
        ]
        else [];

      extraPackages32 = with pkgs.pkgsi686Linux;
        if isNvidia
        then [vaapiVdpau]
        else [];
    };

    services.xserver.videoDrivers = [cfg.driver];

    # Nvidia-specific configuration
    hardware.nvidia = mkIf isNvidia {
      # Required for Wayland compositors (Niri, Hyprland, etc.)
      modesetting.enable = true;

      # Open kernel module — works on Turing (RTX 2000) and newer.
      # Older cards (GTX 10xx and below) must keep this false.
      open = cfg.nvidia.open;

      # Install nvidia-settings GUI
      nvidiaSettings = true;

      # Driver package — defaults to stable; override via nvidia.package option
      package =
        if cfg.nvidia.package != null
        then cfg.nvidia.package
        else config.boot.kernelPackages.nvidiaPackages.stable;

      # Power management — helps with suspend/resume on desktops
      powerManagement.enable = false;
    };

    # Nvidia Wayland environment variables
    environment.sessionVariables = mkIf isNvidia {
      # Tell libva to use the nvidia backend for hardware video acceleration
      LIBVA_DRIVER_NAME = "nvidia";
      # Force GLX to use the nvidia vendor library
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      # Needed by some Electron/Chromium apps on Wayland
      NIXOS_OZONE_WL = "1";
    };
  };
}
