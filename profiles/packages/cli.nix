# CLI utilities
{pkgs}:
with pkgs;
  [
    (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
    awscli2
    fzf
    fd
    ripgrep
    httpie
    gnumake
    gh
    glab
    jq
    yq
    act
    pv
    socat
    htop
    gnupg
  ]
  ++ pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [
    gcc15
  ]
