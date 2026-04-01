# Power management configuration module
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mySystem.power;
in {
  options.mySystem.power = {
    enable = mkEnableOption "power management (auto-cpufreq)";

    batteryGovernor = mkOption {
      type = types.enum ["powersave" "schedutil" "conservative" "ondemand" "performance"];
      default = "powersave";
      description = "CPU governor when on battery";
    };

    batteryTurbo = mkOption {
      type = types.enum ["never" "auto" "always"];
      default = "never";
      description = "Turbo boost when on battery";
    };

    chargerGovernor = mkOption {
      type = types.enum ["powersave" "schedutil" "conservative" "ondemand" "performance"];
      default = "performance";
      description = "CPU governor when charging";
    };

    chargerTurbo = mkOption {
      type = types.enum ["never" "auto" "always"];
      default = "auto";
      description = "Turbo boost when charging";
    };
  };

  config = mkIf cfg.enable {
    # Disable conflicting service
    services.power-profiles-daemon.enable = false;

    services.auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = cfg.batteryGovernor;
          turbo = cfg.batteryTurbo;
        };
        charger = {
          governor = cfg.chargerGovernor;
          turbo = cfg.chargerTurbo;
        };
      };
    };
  };
}
