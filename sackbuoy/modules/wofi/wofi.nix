{
  programs.wofi = {
    enable = true;
    style = builtins.readFile ./styles.css;
  };
}
