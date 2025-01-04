# My nixos config

# How to build
## build and switch immediately
```
sudo nixos-rebuild switch --flake <path to flake.nix dir>
```

## build and add to boot menu
```
sudo nixos-rebuild boot --flake <path to flake.nix dir>
```

# connect to wifi cli
```
nmcli d wifi connect <WiFiSSID> password <WiFiPassword> iface <WifiInterface>
```

# config outside this repo:
1. create ssh key for git(check git.nix for exact filename) and add to github as ssh key and signing key
2. install tmux plugin manager, and install plugins(prefix + I)
3. create ~/.bin/ for custom binaries

# notes
1. don't use direnv to create dev env, just add packages to home.nix

# TODO:
- build my neovim config as a nix flake and use that instead of nixvim
- add https://github.com/outfoxxed/hy3 to hyprland
- find better bar setup than current waybar
- fix vpn connection? cant connect to home
