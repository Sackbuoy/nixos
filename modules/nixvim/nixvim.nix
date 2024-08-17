{
  imports = [
    ./opts.nix
    ./plugins.nix
    ./keymaps.nix
    ./language-servers.nix
  ];

  programs.nixvim = {
    enable = true;

    globals.mapleader = " ";

    colorschemes.nightfox = {
      enable = true;
    };
  };
}
