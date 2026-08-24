# Hardware configuration for gaming-desktop
# Generate this on the target machine with:
#   sudo nixos-generate-config --show-hardware-config
# and paste the output here.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # ── Populate from `nixos-generate-config` output ──────────────────────────
  boot.initrd.availableKernelModules = [ ... ];
  boot.initrd.kernelModules = [ ... ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXROOT";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/NIXBOOT";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];

  swapDevices = [
    {
      device = "/.swapfile";
      size = 32 * 1024; # 32GB
    }
  ];

  # Networking — update for your NIC(s)
  networking.useDHCP = lib.mkDefault true;

  # Intel CPU microcode (also set in configuration.nix, but generate-config puts it here)
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
