# Locale and timezone configuration module
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mySystem.locale;
in {
  options.mySystem.locale = {
    timezone = mkOption {
      type = types.str;
      default = "America/Chicago";
      description = "System timezone";
    };

    language = mkOption {
      type = types.str;
      default = "en_US.UTF-8";
      description = "System language/locale";
    };
  };

  config = {
    time.timeZone = cfg.timezone;

    i18n.defaultLocale = cfg.language;

    i18n.extraLocaleSettings = {
      LC_ADDRESS = cfg.language;
      LC_IDENTIFICATION = cfg.language;
      LC_MEASUREMENT = cfg.language;
      LC_MONETARY = cfg.language;
      LC_NAME = cfg.language;
      LC_NUMERIC = cfg.language;
      LC_PAPER = cfg.language;
      LC_TELEPHONE = cfg.language;
      LC_TIME = cfg.language;
    };
  };
}
