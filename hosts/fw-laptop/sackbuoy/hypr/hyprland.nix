{pkgs, ...}: let
  assignWorkspacesScript = import ./scripts/assign-workspaces.nix {inherit pkgs;};
  focusMonitorScript = import ./scripts/focus-monitor.nix {inherit pkgs;};
  focusWsOnCurrentMonScript = import ./scripts/focus-workspace-on-current-monitor.nix {inherit pkgs;};
in {
  home.packages = with pkgs; [
    nautilus
    hyprpolkitagent
    # removed this since it caused build issues and im not using hyprland anyway
    # libsForQt5.qt5.qtwayland # needed for some apps to load right
    (wf-recorder.override {ffmpeg = ffmpeg_8;})
    slurp
    wl-clipboard
    hyprshot
    grim
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    # systemd.enable = false; # needed when starting with UWSM
    plugins = [
      pkgs.hyprlandPlugins.hy3
    ];
    settings = {
      "$mainMod" = "SUPER";
      "$terminal" = "ghostty";
      "$fileManager" = "nautilus";
      "$homeMonRight" = "Dell Inc. DELL P2425H BJX1B64";
      "$homeMonLeft" = "Dell Inc. DELL P2419HC 6C9ZJ73";
      "$frameworkDisplay" = "BOE NE135A1M-NY1";
      "$workMonLeft" = "LG Electronics LG HDR 4K 0x00060A6B";
      "$workMonRight" = "LG Electronics LG HDR 4K 0x000609C5";

      # i think this is super picky, like the ID might change if i plug into a
      # different port -> which is why im using descriptions
      # I use the built in display as 0x0,
      monitor = [
        "desc:$frameworkDisplay, 2880x1920@120, 0x0, 2" # built in display(framework)
        "desc:$homeMonRight, 1920x1080, -1920x0, 1" # Right
        "desc:$homeMonLeft, 1920x1080, -3840x0, 1" # Left

        "desc:$workMonRight, 1920x1080, -1920x0, 1"
        "desc:$workMonLeft, 1920x1080, -3840x0, 1"
        ", preferred, auto-left, 1" # automatically puts new monitors plugged in to the left
      ];

      workspace = [
        "1, persistent:true"
        "2, persistent:true"
        "3, persistent:true"
      ];

      "exec-once" = [
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "noctalia-shell"
        "systemctl --user start hyprpolkitagent"
        "${assignWorkspacesScript}/bin/assign-workspaces"
        "hyprctl dispatch workspace 3; sleep 1"
        "hyprctl dispatch workspace 2; sleep 1"
        "hyprctl dispatch workspace 1; sleep 1"
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

      debug = {
        "disable_logs" = "false";
      };

      gesture = [
        "3, horizontal, workspace"
      ];

      decoration = {
        "rounding" = 10;
      };

      windowrulev2 = [
        # rules for the popups from toolbar
        "float, class:(toolbarApp)"
        "size 622 652, class:(toolbarApp)"
        # noctalia floating windows
        "float, class:(noctalia.*)"
        "float, class:^(noctalia-overview.*)$"
      ];

      bind = [
        # workspace arranging
        ", monitoradded, exec, ${assignWorkspacesScript}/bin/assign-workspaces"
        ", monitorremoved, exec, ${assignWorkspacesScript}/bin/assign-workspaces"

        "$mainMod, RETURN, exec, $terminal"
        "$mainMod, C, killactive"
        "$mainMod, M, exit"
        "$mainMod, E, exec, $fileManager"

        # Noctalia launcher (replaces wofi)
        "$mainMod, SPACE, exec, noctalia-shell ipc call launcher toggle"

        # Noctalia control center
        "$mainMod, S, exec, noctalia-shell ipc call controlCenter toggle"

        # Noctalia settings
        "$mainMod, COMMA, exec, noctalia-shell ipc call settings toggle"

        # Noctalia clipboard (replaces clipse)
        "$mainMod, V, exec, noctalia-shell ipc call launcher clipboard"

        "$mainMod, J, togglesplit" # dwindle

        "CTRL SHIFT, l, exec, ${focusMonitorScript}/bin/focus-monitor right"
        "CTRL SHIFT, h, exec, ${focusMonitorScript}/bin/focus-monitor left"

        # Lock screen via noctalia (replaces hyprlock)
        "CTRL ALT, l, exec, noctalia-shell ipc call lockScreen lock"
        "$mainMod, A, exec, ${assignWorkspacesScript}/bin/assign-workspaces"

        "$mainMod, z, togglefloating"
        "$mainMod, f, fullscreen"
        "$mainMod SHIFT, f, fullscreen, 1" # windowed fullscreen

        # screenshots (grim/hyprshot)
        "$mainMod, P, exec, hyprshot -m region --clipboard-only"
        "$mainMod SHIFT, P, exec, hyprshot -m region -o /home/sackbuoy/Pictures/Screenshots"

        # screen recording
        "$mainMod, R, exec, /home/sackbuoy/.bin/screenrecord"

        # Move focus with mainMod + hjkl
        "$mainMod, h, movefocus, l"
        "$mainMod, l, movefocus, r"
        "$mainMod, k, movefocus, u"
        "$mainMod, j, movefocus, d"

        # move window with mainMod + shift + hjkl
        "$mainMod SHIFT, h, movewindow, l"
        "$mainMod SHIFT, l, movewindow, r"
        "$mainMod SHIFT, k, movewindow, u"
        "$mainMod SHIFT, j, movewindow, d"

        # Switch workspaces with ALT + [0-9]
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

        "ALT, l, exec, ${focusWsOnCurrentMonScript}/bin/fwcm right"
        "ALT, h, exec, ${focusWsOnCurrentMonScript}/bin/fwcm left"

        # Move active window to a workspace with ALT + SHIFT + [0-9]
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

        "$mainMod SHIFT, Q, exit,"
        "$mainMod SHIFT, SLASH, exec, hyprctl dispatch submap reset" # fallback
      ];

      bindl = [
        # Lid close -> noctalia lock (replaces hyprlock)
        ", switch:on:Lid Switch, exec, noctalia-shell ipc call lockScreen lock"
        ", switch:off:Lid Switch, exec, hyprctl dispatch dpms on"
        # Media keys -> noctalia IPC (replaces playerctl/wpctl direct calls)
        ", XF86AudioMute, exec, noctalia-shell ipc call audio toggleMute"
        ", XF86AudioPlay, exec, noctalia-shell ipc call media playPause"
        ", XF86AudioNext, exec, noctalia-shell ipc call media next"
        ", XF86AudioPrev, exec, noctalia-shell ipc call media previous"
      ];

      bindle = [
        # Volume/brightness -> noctalia IPC (replaces wpctl/brightnessctl)
        ", XF86AudioRaiseVolume, exec, noctalia-shell ipc call audio volumeUp"
        ", XF86AudioLowerVolume, exec, noctalia-shell ipc call audio volumeDown"
        ", XF86MonBrightnessUp, exec, noctalia-shell ipc call brightness up"
        ", XF86MonBrightnessDown, exec, noctalia-shell ipc call brightness down"
      ];

      # mouse binds
      bindm = [
        "$mainMod, mouse:272, moveWindow"
      ];

      input = {
        "kb_layout" = "us";

        "follow_mouse" = "1";

        "sensitivity" = "-0.3"; # -1.0 - 1.0, 0 means no modification.

        touchpad = {
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
