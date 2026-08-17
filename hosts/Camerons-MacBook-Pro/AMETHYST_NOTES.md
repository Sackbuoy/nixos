# Amethyst vs Niri — Migration Notes

## Direct Mappings

| Niri | Amethyst | Key |
|---|---|---|
| `Mod+H/L` focus column left/right | `focus-ccw`/`focus-cw` | `cmd+shift+h/l` |
| `Mod+Shift+H/L` move column left/right | `swap-ccw`/`swap-cw` | `cmd+shift+ctrl+h/l` |
| `Mod+Minus/Equal` resize ±10% | `shrink-main`/`expand-main` | `cmd+shift+-/=` |
| `Mod+F` maximize column | `select-fullscreen-layout` | `cmd+shift+f` |
| `Ctrl+Shift+H/L` focus monitor | `focus-screen-ccw`/`focus-screen-cw` | `cmd+shift+ctrl+left/right` |
| `Ctrl+Shift+Mod+H/L` move to monitor | `swap-screen-ccw`/`swap-screen-cw` | `cmd+shift+ctrl+j/k` |
| Gaps `2px` | `window-margin-size: 2` | — |
| `focus-follows-mouse` | `focus-follows-mouse: true` | — |

## Where Amethyst Diverges (macOS Limitations)

- **`Alt+1-9` workspace focus** — no direct equivalent. Amethyst only has `throw-space-left`/`throw-space-right`. Use macOS Mission Control shortcuts (`ctrl+1-9`) in System Settings instead.
- **`Mod+K/J` vertical window/workspace navigation** — Amethyst uses a flat clockwise/counter-clockwise window list; there's no separate vertical axis. Window cycling goes through all windows on the screen in order.
- **Corner radius + border colors** — no equivalent in Amethyst. macOS handles window decoration.
- **App launcher (`Mod+Space`), close window (`Mod+C`), terminal (`Mod+Return`)** — Amethyst only manages layout keybinds. Set these in macOS Keyboard Shortcuts, Raycast, or Karabiner-Elements.
