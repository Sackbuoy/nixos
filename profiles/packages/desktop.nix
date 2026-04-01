# Desktop applications (Linux only)
{pkgs}:
pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux (
  with pkgs; [
    signal-desktop
    protonmail-desktop
    electron-mail
    spotify-player
    discord
    zoom-us
    slack
    spotify
    brave
    prismlauncher
  ]
)
