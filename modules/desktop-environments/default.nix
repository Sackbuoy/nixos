{ pkgs, ...}:
{
  imports = 
  [
    ./gnome.nix
    ./hyprland.nix
    ./kde.nix
  ];
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland --theme 'border=magenta;text=cyan;prompt=green;time=red;action=blue;button=yellow;container=black;input=red'";
        user = "greeter";
      };
    };
  };
}
