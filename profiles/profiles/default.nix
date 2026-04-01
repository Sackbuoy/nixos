# Profile definitions
# Combine package sets into usable profiles
{packages}: {
  work = import ./work.nix {inherit packages;};
  personal = import ./personal.nix {inherit packages;};
}
