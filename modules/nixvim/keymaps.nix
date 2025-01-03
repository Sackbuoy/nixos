{
  programs.nixvim.keymaps = [
    # NeoTree
    {
      action = "<cmd>Neotree toggle<CR>";
      key = "<leader>l";
      mode = "n";
      options = {
        noremap = true;
        silent = true;
      };
    }
    {
      action = "<cmd>Neotree reveal<CR>";
      key = "<leader>e";
      mode = "n";
      options = {
        noremap = true;
        silent = true;
      };
    }
    
    # Telescope
    {
      action = "<cmd>Telescope live_grep<CR>";
      key = "<leader>g";
      mode = "n";
      options = {
        noremap = true;
        silent = true;
      };
    }
    {
      action = "<cmd>Telescope find_files<CR>";
      key = "<leader>f";
      mode = "n";
      options = {
        noremap = true;
        silent = true;
      };
    }
    {
      action = "<cmd>Telescope lsp_definitions<CR>";
      key = "gd";
      mode = "n";
      options = {
        noremap = true;
        silent = true;
      };
    }
    {
      action = "<cmd>Telescope lsp_type_definitions<CR>";
      key = "gD";
      mode = "n";
      options = {
        noremap = true;
        silent = true;
      };
    }
    {
      action = ":lua vim.lsp.buf.references()<CR>";
      key = "gr";
      mode = "n";
      options = {
        noremap = true;
        silent = true;
      };
    }
    {
      action = "<cmd>Telescope lsp_implementations<CR>";
      key = "gi";
      mode = "n";
      options = {
        noremap = true;
        silent = true;
      };
    }
    {
      action = "<cmd>Telescope diagnostics<CR>";
      key = "<leader>D";
      mode = "n";
      options = {
        noremap = true;
        silent = true;
      };
    }

    # Global
    {
      action = "<cmd>lua vim.diagnostic.open_float()<CR>";
      key = "<leader>d";
      mode = "n";
      options = {
        noremap = true;
        silent = true;
      };
    }
    {
      action = "<cmd>lua vim.diagnostic.open_float()<CR>";
      key = "<leader>d";
      mode = "n";
      options = {
        noremap = true;
        silent = true;
      };
    }
    {
      action = "<cmd>lua vim.diagnostic.goto_prev()<CR>";
      key = "<leader>[d";
      mode = "n";
      options = {
        noremap = true;
        silent = true;
      };
    }
    {
      action = "<cmd>lua vim.diagnostic.goto_next()<CR>";
      key = "<leader>]d";
      mode = "n";
      options = {
        noremap = true;
        silent = true;
      };
    }
  ];
}
