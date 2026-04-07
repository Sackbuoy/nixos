# System modules bundle
# Import this to get access to all mySystem.* options
{
  imports = [
    ./nix-settings.nix
    ./locale.nix
    ./audio.nix
    ./containers.nix
    ./power.nix
    ./keyd.nix
    ./desktop
    ./ly.nix
    ./gaming-graphics.nix
  ];
}
