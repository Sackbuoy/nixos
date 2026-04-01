# Export NixOS modules via flake.nixosModules
{...}: {
  flake.nixosModules = {
    # Individual modules
    nix-settings = import ../modules/system/nix-settings.nix;
    locale = import ../modules/system/locale.nix;
    audio = import ../modules/system/audio.nix;
    containers = import ../modules/system/containers.nix;
    power = import ../modules/system/power.nix;
    keyd = import ../modules/system/keyd.nix;
    ly = import ../modules/system/ly.nix;

    # Desktop modules
    desktop-common = import ../modules/system/desktop/common.nix;
    desktop-hyprland = import ../modules/system/desktop/hyprland.nix;
    desktop-niri = import ../modules/system/desktop/niri.nix;
    desktop = import ../modules/system/desktop;

    # Bundle: all system modules
    default = import ../modules/system;
  };
}
