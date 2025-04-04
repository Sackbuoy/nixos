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
    - for tmux2k plugin, i use my own custom scripts for gcloud and kube
      just add them to the scripts dir of the plugin and update tmux2k.sh to      accomodate them
3. create ~/.bin/ for custom binaries
4. create boot partition with label NIXBOOT
5. create root partition with label NIXROOT
6. anything installed via flatpak is managed outside this repo

# installing profiles:
`cd` to the directory containing the profile flake.nix
then run `nix profile install --impure  .`
then when packages are added/removed, run `nix profile upgrade sackbuoy --impure`

# notes
1. don't use direnv to create dev env, just add packages to home.nix
2. this config currently only works with x86_64-linux, i hope to add 
   arm64-linux eventually. maybe aarch64-darwin if i start to use asahi
3. you can make every module toggle-able with the mkEnable function

# TODO:
- find better bar setup than current waybar for hyprland
- switch to wezterm? nix pkg seems broken
- gcloud completions

## Desired Layout options:
1. Import only desired host in flake.nix
2. Make all modules toggleable
3. add nixosModules/default.nix to modules in flake, so all options can just be
   toggled
```
flake.nix
hosts/
  host1/
    configuration.nix
    hardware-configuration.nix
  host2/
    configuration.nix
    hardware-configuration.nix
nixosModules/
  default.nix
  purpose1/
    module1.nix
    module2.nix
  purpose2/
    module3.nix
    module4.nix
```
    
