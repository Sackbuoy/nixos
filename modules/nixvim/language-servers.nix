{
  programs.nixvim.plugins.lsp = {
    enable = true;

    servers = {
      nil-ls = {
        enable = true;
      };

      gopls = {
        enable = true;
        autostart = true;
      };

      rust-analyzer = {
        installCargo = true;
        installRustc = true;
        enable = true;
      };
    };
  };
}
