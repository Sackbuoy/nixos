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
