{
  programs.git = {
    enable = true;
    lfs.enable = true;
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
      credential = {
        helper = "store";
      };

      http.postBuffer = 524288000; # 500MB in bytes

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

    includes = [
      {
        condition = "hasconfig:remote.*.url:git@gitlab.com:*/**";
        contents = {
          user = {
            email = "cameron@realm.security";
          };
        };
      }
      {
        condition = "hasconfig:remote.*.url:git@github.com:*/**";
        contents = {
          commit.gpgsign = true;
          gpg.format = "ssh";
          user = {
            email = "cameronkientz@proton.me";
            signingkey = "~/.ssh/id_ed25519";
          };
        };
      }
    ];
  };
}
