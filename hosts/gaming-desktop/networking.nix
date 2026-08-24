# Networking configuration for gaming-desktop
{lib, ...}: {
  networking.hostName = "gaming-desktop";

  # Use NetworkManager for easy WiFi / Ethernet management
  networking.networkmanager.enable = true;

  # Firewall — open extra ports as needed (e.g. game servers, Parsec, etc.)
  networking.firewall = {
    enable = true;
    # allowedTCPPorts = [ 27015 ];
    # allowedUDPPorts = [ 27015 ];
  };
}
