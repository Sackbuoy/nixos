{
  programs.nixvim.plugins.lsp = {
    enable = true;

    servers = {
      nil-ls = {
        enable = true;
      };

      gopls = {
        enable = true;
      };

      rust-analyzer = {
        installCargo = true;
        installRustc = true;
        enable = true;
      };
    };
  };
}
