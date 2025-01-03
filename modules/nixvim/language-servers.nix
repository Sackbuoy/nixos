{
  programs.nixvim.plugins.lsp = {
    enable = true;

    servers = {
      nil_ls = {
        enable = true;
      };

      gopls = {
        enable = true;
        autostart = true;
      };

      rust_analyzer = {
        installCargo = true;
        installRustc = true;
        enable = true;
      };
    };
  };
}
