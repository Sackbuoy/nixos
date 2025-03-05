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
      # Sign all commits using ssh key
      commit.gpgsign = true;
      gpg.format = "ssh";
      user.signingkey = "~/.ssh/id_ed25519.pub";
      url = {
        "ssh://git@github.com" = {
          insteadOf = "https://github.com";
        };
      };

      push = {
        autoSetupRemote = true;
      };

      init = {
        defaultBranch = "main";
      };

      delta = {
        navigate = true;
        side-by-side = true;
      };

      merge = {
        conflictstyle = "diff3";
      };

      diff = {
        colorMoved = "default";
      };
    };
  };
}
