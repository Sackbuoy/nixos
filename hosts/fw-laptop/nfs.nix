{pkgs, ...}: let
  disk1 = "/var/lib/plexmediaserver/disk1";
  disk2 = "/var/lib/plexmediaserver/disk2";
  disk3 = "/var/lib/plexmediaserver/disk3";
  nfsOpts = ["defaults" "soft" "timeo=5" "retrans=2" "nofail" "x-systemd.automount" "noauto" "x-systemd.mount-timeout=5s"];
in {
  fileSystems = {
    "${disk1}" = {
      device = "10.0.0.10:${disk1}";
      fsType = "nfs";
      options = nfsOpts;
    };
    "${disk2}" = {
      device = "10.0.0.10:${disk2}";
      fsType = "nfs";
      options = nfsOpts;
    };
    "${disk3}" = {
      device = "10.0.0.10:${disk3}";
      fsType = "nfs";
      options = nfsOpts;
    };
  };
}
