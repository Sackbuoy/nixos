{pkgs, ...}: {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "Maple Mono NF:size=11";
        dpi-aware = "no";
        prompt = "\"❯ \"";
        layer = "overlay";
        lines = 10;
        width = 35;
        horizontal-pad = 12;
        vertical-pad = 8;
        inner-pad = 4;
      };
      colors = {
        background = "282a36ff";
        text = "f8f8f2ff";
        selection = "44475aff";
        selection-text = "f8f8f2ff";
        border = "bd93f9ff";
        match = "bd93f9ff";
        selection-match = "bd93f9ff";
      };
      border = {
        width = 1;
        radius = 10;
      };
    };
  };
}
