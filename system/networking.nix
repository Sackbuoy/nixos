{ pkgs, ... }:
{
  networking = {
    hostName = "nixos"; # Define your hostname.

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking -> either networking OR wireless
    networkmanager.enable = true;
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Open ports in the firewall.
    # Or disable the firewall altogether.
    firewall.enable = false;
    # firewall = {
    #   allowedUDPPorts = [ 51820 ]; # Clients and peers can use the same port, see listenport
    # };
    # Enable WireGuard
    wireguard.enable = true;
  };
}
