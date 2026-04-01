# Audio/PipeWire configuration module
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mySystem.audio;
in {
  options.mySystem.audio = {
    enable = mkEnableOption "PipeWire audio system";

    bluetooth = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Bluetooth audio enhancements";
      };
    };

    jack = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable JACK audio support";
      };
    };

    lowLatency = mkOption {
      type = types.bool;
      default = false;
      description = "Enable low latency settings (for gaming/music production)";
    };
  };

  config = mkIf cfg.enable {
    # Disable PulseAudio in favor of PipeWire
    services.pulseaudio.enable = false;

    # Required for PipeWire
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = cfg.jack.enable;

      # Bluetooth enhancements
      wireplumber.extraConfig = mkIf cfg.bluetooth.enable {
        bluetoothEnhancements = {
          "monitor.bluez.properties" = {
            "bluez5.enable-sbc-xq" = true;
            "bluez5.enable-msbc" = true;
            "bluez5.enable-hw-volume" = true;
            "bluez5.roles" = [
              "hsp_hs"
              "hsp_ag"
              "hfp_hf"
              "hfp_ag"
            ];
          };
        };
      };
    };

    # Bluetooth GUI
    services.blueman.enable = cfg.bluetooth.enable;
  };
}
