# Container runtime configuration module
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mySystem.containers;
in {
  options.mySystem.containers = {
    enable = mkEnableOption "container runtime";

    backend = mkOption {
      type = types.enum ["podman" "docker"];
      default = "docker";
      description = "Container backend to use";
    };

    dockerCompat = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Docker CLI compatibility (for Podman)";
    };
  };

  config = mkIf cfg.enable {
    virtualisation = {
      docker.enable = cfg.backend == "docker";

      multipass.enable = false;

      podman = mkIf (cfg.backend == "podman") {
        enable = true;
        dockerCompat = cfg.dockerCompat;
      };
    };
  };
}
