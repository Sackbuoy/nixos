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
        # command = "${pkgs.greetd.regreet}/bin/regreet -c Hyprland";
        # command = "${pkgs.greetd.gtkgreet}/bin/gtkgreet -c Hyprland";
        user = "greeter";
      };
    };
  };

  # environment.etc."greetd/environments".text = ''
  #   Hyprland
  # '';

  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     default_session = {
  #       command = "Hyprland";
  #       user = "sackbuoy";
  #     };
  #     initial_session = {
  #       command = "Hyprland --config /etc/greetd/hyprland.conf";
  #       user = "greeter";
  #     };
  #   };
  # };
  #
  # environment.etc."greetd/hyprland.conf".text = ''
  #   exec-once = regreet; hyprctl dispatch exit
  # '';

  # systemd.services.greetd.serviceConfig = {
  #   Type = "idle";
  #   StandardInput = "tty";
  #   StandardOutput = "tty";
  #   StandardError = "journal";
  #   # The display variables are crucial for gtkgreet to work
  #   Environment = [
  #     "WLR_RENDERER=pixman"
  #     "WLR_BACKENDS=headless"
  #     "XDG_SESSION_TYPE=wayland"
  #     "WAYLAND_DISPLAY=wayland-1"
  #   ];
  # };
}
