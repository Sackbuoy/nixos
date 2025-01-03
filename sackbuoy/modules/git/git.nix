{
  programs.git = {
    enable = true;
    delta.enable = true;
    userName = "Sackbuoy";
    userEmail = "cameronkientz@proton.me";
    aliases = {
      co = "checkout";
    };
    extraConfig = {
      url = {
        "ssh://git@github.com" = {
          insteadOf = "https://github.com";
        };
      };
    };
  };
}
