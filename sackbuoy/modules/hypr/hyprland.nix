{ pkgs, ... }: 
{
  imports = [
    ../waybar/waybar.nix
    ../wofi/wofi.nix
    ./hyprpaper.nix
    ./hypridle.nix
    ./hyprlock.nix
  ];

  home.packages = with pkgs; [
    pkgs.hyprlock
    pkgs.hypridle
    pkgs.hyprpaper
    pkgs.hyprsunset
    pkgs.hyprpicker
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    # systemd.enable = false; # needed when starting with UWSM
    plugins = [ 
      pkgs.hyprlandPlugins.hy3
    ];
    settings = {
      "$mainMod" = "SUPER";
      "$terminal" = "alacritty";
      "$fileManager" = "nautilus";
      "$menu" = "wofi --show drun";
      "$dellMonitor"= "Dell Inc. DELL P2419HC DMC0L03";
      "$lgMonitor"="LG Electronics 27EA63 0x01010101";
      "$frameworkDisplay"="BOE NE135A1M-NY1";
      "$workMonLeft"="LG Electronics LG HDR 4K 0x0006F9D7";
      "$workMonRight"="LG Electronics LG HDR 4K 0x000609CB";


      # i think this is super picky, like the ID might change if i plug into a
      # different port -> which is why im using descriptions
      # I use the built in display as 0x0, 
      monitor = [
        "desc:$frameworkDisplay, 2880x1920@60, 0x0, 2" # built in display(framework)
        "desc:$dellMonitor, 1920x1080, -1920x0, 1" # Dell
        "desc:$lgMonitor, 1920x1080, -3840x0, 1" # LG monitor

        "desc:$workMonRight, 1920x1080, -1920x0, 1"
        "desc:$workMonLeft, 1920x1080, -3840x0, 1"
        ", preferred, auto, 1" # automatically puts new monitors plugged in to the right
      ];

      workspace = [
        "1,monitor:desc:$lgMonitor"
        "2,monitor:desc:$dellMonitor"

        "1,monitor:desc:$workMonRight"
        "2,monitor:desc:$workMonLeft"

        "3,monitor:desc:$frameworkDisplay"

      ];

      "exec-once" = [
        "hyprpaper"
        "hyprpanel"
        "clipse -listen"
        # "dunst" # hyprpanel does notifications now
        "hypridle"
        "hyprsunset --temperature 5000"
        "systemctl --user start hyprpolkitagent"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      ];

      general = { 
	      "gaps_in" = 2;
      	"gaps_out" = 2;

	      "border_size" = 1;

	      # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
	      "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
	      "col.inactive_border" = "rgba(595959aa)";

	      # Set to true enable resizing windows by clicking and dragging on borders and gaps
	      "resize_on_border" = "false";

	      # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
	      "allow_tearing" = "false";

	      "layout" = "dwindle";
      };

      gestures = {
        "workspace_swipe" = "true";
      };

      decoration = {
        "rounding" = 10;
      };

      windowrulev2 = [
        # rules for the popups from toolbar
        "float, class:(toolbarApp)"
        "size 622 652, class:(toolbarApp)"

        # special bc pavucontrol is a GUI
        "float, title:^(Volume Control)$"
        "size 622 652, title:^(Volume Control)$"
      ];

      bind = [
	      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
	      "$mainMod, RETURN, exec, $terminal"
	      "$mainMod, C, killactive" 
	      "$mainMod, M, exit" 
	      "$mainMod, E, exec, $fileManager"
	      "$mainMod, SPACE, exec, $menu"
	      "$mainMod, J, togglesplit" # dwindle 

        "$mainMod, F, togglefloating"

        # screenshots
	      "$mainMod, P, exec, hyprshot -m region --clipboard-only"
	      "$mainMod SHIFT, P, exec, hyprshot -m region -o /home/sackbuoy/Pictures/Screenshots"

        # need to add the --class in the toolbar launcher config 
        # to make these adhere to the windowrules
        # clipboard manager
        "$mainMod, V, exec, alacritty --class toolbarApp -e clipse"

        "$mainMod, B, exec, alacritty --class toolbarApp -e bluetui"
        "$mainMod, N, exec, alacritty --class toolbarApp -e nmtui"
        "$mainMod, A, exec, pavucontrol"

	      # Move focus with mainMod + arrow keys
	      "$mainMod, h, movefocus, l"
	      "$mainMod, l, movefocus, r"
	      "$mainMod, k, movefocus, u"
	      "$mainMod, j, movefocus, d"

        # move window with mainMod + shift + hjkl
	      "$mainMod SHIFT, h, movewindow, l"
	      "$mainMod SHIFT, l, movewindow, r"
	      "$mainMod SHIFT, k, movewindow, u"
	      "$mainMod SHIFT, j, movewindow, d"


	      # Switch workspaces with mainMod + [0-9]
	      "ALT, 1, workspace, 1"
	      "ALT, 2, workspace, 2"
	      "ALT, 3, workspace, 3"
	      "ALT, 4, workspace, 4"
	      "ALT, 5, workspace, 5"
	      "ALT, 6, workspace, 6"
	      "ALT, 7, workspace, 7"
	      "ALT, 8, workspace, 8"
	      "ALT, 9, workspace, 9"
	      "ALT, 0, workspace, 10"

        "ALT, h, workspace, -1"
        "ALT, l, workspace, +1"

	      # Move active window to a workspace with mainMod + SHIFT + [0-9]
	      "ALT SHIFT, 1, movetoworkspace, 1"
	      "ALT SHIFT, 2, movetoworkspace, 2"
	      "ALT SHIFT, 3, movetoworkspace, 3"
	      "ALT SHIFT, 4, movetoworkspace, 4"
	      "ALT SHIFT, 5, movetoworkspace, 5"
	      "ALT SHIFT, 6, movetoworkspace, 6"
	      "ALT SHIFT, 7, movetoworkspace, 7"
	      "ALT SHIFT, 8, movetoworkspace, 8"
	      "ALT SHIFT, 9, movetoworkspace, 9"
	      "ALT SHIFT, 0, movetoworkspace, 10"

	      "ALT SHIFT, l, movetoworkspace, +1"
	      "ALT SHIFT, h, movetoworkspace, -1"
      ];

      bindl = [
        ", switch:closed:Lid Switch, exec, systemctl suspend"
        ", switch:open:Lid Switch, exec, hyprctl dispatch dpms on"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioPlay, exec, playerctl play-pause # the stupid key is called play , but it toggles "
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      bindle = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86MonBrightnessUp, exec, brightnessctl s 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl s 5%-"
      ];

      # mouse binds
      bindm = [
        "$mainMod, mouse:272, moveWindow"
      ];

      input = {
	      "kb_layout" = "us";

	      "follow_mouse" = "1";

	      "sensitivity" = "-0.3"; # -1.0 - 1.0, 0 means no modification.

	      touchpad  = {
          "scroll_factor" = "0.2";
	        "natural_scroll" = "true";
          "disable_while_typing" = "true";
          "tap-to-click" = "false";
          "clickfinger_behavior" = "true";
	      };
      };
    };
  };
}
