# Desktop applications (Linux only)
{pkgs}:
let
  discord-wrapped = pkgs.symlinkJoin {
    name = "discord-wrapped";
    paths = [ pkgs.discord ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/discord \
        --add-flags "--force-device-scale-factor=1"
      wrapProgram $out/bin/Discord \
        --add-flags "--force-device-scale-factor=1"
    '';
  };
in
pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux (
  with pkgs; [
    signal-desktop
    protonmail-desktop
    electron-mail
    spotify-player
    discord-wrapped
    zoom-us
    slack
    spotify
    brave
    prismlauncher
  ]
)
