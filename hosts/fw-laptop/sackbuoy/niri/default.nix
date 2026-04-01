{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    # Replacements for hyprland-specific tools
    # swaybg # wallpaper (replaces hyprpaper)
    # swayidle # idle management (replaces hypridle)
    # swaylock # lock screen (replaces hyprlock)
    # wlsunset # color temperature (replaces hyprsunset)
    grim # screenshot tool (replaces hyprshot, used alongside niri built-in)
    wiremix # TUI audio mixer for PipeWire
    xwayland-satellite # XWayland for X11 apps (Steam, etc.)
  ];

  xdg.configFile."niri/config.kdl".text = ''
    // ── Input ────────────────────────────────────────────────────
    input {
        keyboard {
            xkb {
                layout "us"
            }
        }

        touchpad {
            natural-scroll
            scroll-factor 0.2
            click-method "clickfinger"
            // tap-to-click intentionally not set (disabled, matching hyprland)
        }

        mouse {
            accel-speed -0.3
        }

        focus-follows-mouse max-scroll-amount="0%"
    }

    // ── Outputs (monitor arrangement) ───────────────────────────
    // Left to right: Left external | Right external | Framework laptop
    // Check connector names with: niri msg outputs

    // Left external monitor (Dell P2419HC)
    output "Dell Inc. DELL P2419HC 6C9ZJ73" {
        mode "1920x1080@60.000"
        position x=-3840 y=0
    }

    // Right external monitor (Dell P2425H)
    output "Dell Inc. DELL P2425H BJX1B64" {
        mode "1920x1080@60.000"
        position x=-1920 y=0
    }

    // Framework built-in display
    output "BOE NE135A1M-NY1 Unknown" {
        mode "2880x1920@120.000"
        scale 2.0
        position x=0 y=0
    }


    // ── Layout ───────────────────────────────────────────────────
    layout {
        gaps 2

        border {
            width 1
            active-color "#33ccffee"
            inactive-color "#595959aa"
        }

        focus-ring {
            off
        }
    }

    // ── Window decorations ───────────────────────────────────────
    prefer-no-csd

    // Default corner radius for all windows (matching hyprland rounding 10)
    window-rule {
        geometry-corner-radius 10 10 10 10
        clip-to-geometry true
    }

    // ── Window rules ─────────────────────────────────────────────
    // Float toolbar popup apps (clipse, bluetui, nmtui, wiremix)
    window-rule {
        match app-id=r#"^toolbarApp$"#
        open-floating true
    }

    // ── Screenshots ──────────────────────────────────────────────
    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

    // ── XWayland (required for Steam and other X11 apps) ─────────
    spawn-at-startup "xwayland-satellite"

    // ── Startup ──────────────────────────────────────────────────
    spawn-at-startup "waybar"
    spawn-at-startup "clipse" "-listen"
    spawn-at-startup "systemctl" "--user" "start" "hyprpolkitagent"
    spawn-at-startup "hyprsunset"
    spawn-at-startup "hyprpaper"
    spawn-at-startup "systemctl" "start" "--user" "hypridle"

    // ── Keybinds ─────────────────────────────────────────────────
    binds {
        // ── Application launchers ────────────────────────────────
        Mod+Return { spawn "ghostty"; }
        Mod+Space  { spawn "fuzzel"; }
        Mod+E      { spawn "nautilus"; }

        // TUI popups (float via window rules above)
        Mod+V { spawn "alacritty" "--class" "toolbarApp" "-e" "clipse"; }
        Mod+B { spawn "alacritty" "--class" "toolbarApp" "-e" "bluetui"; }
        Mod+N { spawn "alacritty" "--class" "toolbarApp" "-e" "nmtui"; }
        Mod+A { spawn "alacritty" "--class" "toolbarApp" "-e" "wiremix" "--tab" "output"; }

        // ── Window management ────────────────────────────────────
        Mod+C { close-window; }
        Mod+F { maximize-column; }
        Mod+Shift+F { fullscreen-window; }

        // ── Focus (vim-style) ────────────────────────────────────
        Mod+H { focus-column-left; }
        Mod+L { focus-column-right; }
        Mod+K { focus-window-or-workspace-up; }
        Mod+J { focus-window-or-workspace-down; }

        // ── Move windows ─────────────────────────────────────────
        Mod+Shift+H { move-column-left; }
        Mod+Shift+L { move-column-right; }
        Mod+Shift+K { move-window-up-or-to-workspace-up; }
        Mod+Shift+J { move-window-down-or-to-workspace-down; }

        // ── Monitor focus ───────────────────────────────────────
        Ctrl+Shift+H { focus-monitor-left; }
        Ctrl+Shift+L { focus-monitor-right; }

        // ── Move window to monitor ──────────────────────────────
        Ctrl+Shift+Mod+H { move-column-to-monitor-left; }
        Ctrl+Shift+Mod+L { move-column-to-monitor-right; }

        // ── Column sizing ────────────────────────────────────────
        Mod+Minus       { set-column-width "-10%"; }
        Mod+Equal       { set-column-width "+10%"; }
        Mod+Shift+Minus { set-window-height "-10%"; }
        Mod+Shift+Equal { set-window-height "+10%"; }

        // ── Workspaces ───────────────────────────────────────────
        Alt+1 { focus-workspace 1; }
        Alt+2 { focus-workspace 2; }
        Alt+3 { focus-workspace 3; }
        Alt+4 { focus-workspace 4; }
        Alt+5 { focus-workspace 5; }
        Alt+6 { focus-workspace 6; }
        Alt+7 { focus-workspace 7; }
        Alt+8 { focus-workspace 8; }
        Alt+9 { focus-workspace 9; }

        Alt+Shift+1 { move-window-to-workspace 1; }
        Alt+Shift+2 { move-window-to-workspace 2; }
        Alt+Shift+3 { move-window-to-workspace 3; }
        Alt+Shift+4 { move-window-to-workspace 4; }
        Alt+Shift+5 { move-window-to-workspace 5; }
        Alt+Shift+6 { move-window-to-workspace 6; }
        Alt+Shift+7 { move-window-to-workspace 7; }
        Alt+Shift+8 { move-window-to-workspace 8; }
        Alt+Shift+9 { move-window-to-workspace 9; }

        // ── Screenshots ──────────────────────────────────────────
        // Interactive region screenshot (clipboard + saves to ~/Pictures/Screenshots/)
        Mod+P { screenshot; }

        // ── Screen recording ─────────────────────────────────────
        Mod+R { spawn "${config.home.homeDirectory}/.bin/screenrecord"; }

        // ── Lock screen ──────────────────────────────────────────
        Ctrl+Alt+L { spawn "swaylock" "-f"; }

        // ── Media keys ───────────────────────────────────────────
        XF86AudioMute         allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
        XF86AudioRaiseVolume  allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
        XF86AudioLowerVolume  allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
        XF86MonBrightnessUp   allow-when-locked=true { spawn "brightnessctl" "s" "5%+"; }
        XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "s" "5%-"; }
        XF86AudioPlay         allow-when-locked=true { spawn "playerctl" "play-pause"; }
        XF86AudioNext         allow-when-locked=true { spawn "playerctl" "next"; }
        XF86AudioPrev         allow-when-locked=true { spawn "playerctl" "previous"; }

        // ── Session ─────────────────────────────────────────────
        Mod+Shift+Q { quit; }

        // ── Helpful extras ───────────────────────────────────────
        Mod+Shift+Slash { show-hotkey-overlay; }
    }
  '';
}
