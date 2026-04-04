{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    # Screenshot tool (used by Noctalia and niri built-in)
    grim
    # Clipboard history support for Noctalia
    cliphist
    wl-clipboard
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

    // Default corner radius for all windows
    window-rule {
        geometry-corner-radius 20 20 20 20
        clip-to-geometry true
    }

    // Allow notification actions and window activation from Noctalia
    debug {
        honor-xdg-activation-with-invalid-serial
    }

    // Noctalia wallpaper layer rules - blurred overview wallpaper
    layer-rule {
        match namespace="^noctalia-overview*"
        place-within-backdrop true
    }

    // ── Window rules ─────────────────────────────────────────────
    // Float toolbar popup apps (for any TUI tools if needed)
    window-rule {
        match app-id=r#"^toolbarApp$"#
        open-floating true
    }

    // Noctalia panels and popups
    window-rule {
        match app-id=r#"^noctalia.*$"#
        open-floating true
    }

    // ── Screenshots ──────────────────────────────────────────────
    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

    // ── Startup ──────────────────────────────────────────────────
    // Noctalia shell (replaces waybar, handles wallpaper, idle, night light, etc.)
    spawn-at-startup "noctalia-shell"
    // Polkit agent for authentication dialogs
    spawn-at-startup "systemctl" "--user" "start" "hyprpolkitagent"

    // ── Keybinds ─────────────────────────────────────────────────
    binds {
        // ── Application launchers ────────────────────────────────
        Mod+Return { spawn "ghostty"; }
        Mod+E      { spawn "nautilus"; }

        // ── Noctalia shell controls ──────────────────────────────
        // App launcher (replaces fuzzel)
        Mod+Space { spawn "noctalia-shell" "ipc" "call" "launcher" "toggle"; }
        // Control center (network, bluetooth, audio, etc.)
        Mod+S { spawn "noctalia-shell" "ipc" "call" "controlCenter" "toggle"; }
        // Settings panel
        Mod+Comma { spawn "noctalia-shell" "ipc" "call" "settings" "toggle"; }
        // Clipboard history
        Mod+V { spawn "noctalia-shell" "ipc" "call" "launcher" "openClipboard"; }

        // ── Window management ────────────────────────────────────
        Mod+C { close-window; }
        Mod+F { maximize-column; }

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

        // ── Lock screen (via Noctalia) ───────────────────────────
        Ctrl+Alt+L { spawn "noctalia-shell" "ipc" "call" "lockScreen" "lock"; }

        // ── Media keys (via Noctalia for OSD) ────────────────────
        XF86AudioMute         allow-when-locked=true { spawn "noctalia-shell" "ipc" "call" "volume" "muteOutput"; }
        XF86AudioRaiseVolume  allow-when-locked=true { spawn "noctalia-shell" "ipc" "call" "volume" "increase"; }
        XF86AudioLowerVolume  allow-when-locked=true { spawn "noctalia-shell" "ipc" "call" "volume" "decrease"; }
        XF86MonBrightnessUp   allow-when-locked=true { spawn "noctalia-shell" "ipc" "call" "brightness" "increase"; }
        XF86MonBrightnessDown allow-when-locked=true { spawn "noctalia-shell" "ipc" "call" "brightness" "decrease"; }
        XF86AudioPlay         allow-when-locked=true { spawn "noctalia-shell" "ipc" "call" "media" "playPause"; }
        XF86AudioNext         allow-when-locked=true { spawn "noctalia-shell" "ipc" "call" "media" "next"; }
        XF86AudioPrev         allow-when-locked=true { spawn "noctalia-shell" "ipc" "call" "media" "previous"; }

        // ── Session ─────────────────────────────────────────────
        Mod+Shift+Q { quit; }

        // ── Helpful extras ───────────────────────────────────────
        Mod+Shift+Slash { show-hotkey-overlay; }
    }
  '';
}
