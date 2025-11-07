{
  programs.git = {
    enable = true;
    lfs.enable = true;
    delta.enable = true;
    aliases = {
      co = "checkout";
    };
    userName = "Sackbuoy";
    userEmail = "cameronkientz@proton.me";
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
        condition = "gitdir:~/Dev/workin/realm/";
        contents = {
          user = {
            name = "Cameron Kientz";
            email = "cameron@realm.security";
          };
        };
      }
      {
        condition = "gitdir:~/Dev/goofin/";
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
