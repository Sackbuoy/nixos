{
  programs.nixvim.keymaps = [
    # NeoTree
    {
      action = "<cmd>Neotree toggle<CR>";
      key = "<leader>l";
    }
    
    # Telescope
    {
      action = "<cmd>Telescope live_grep<CR>";
      key = "<leader>fg";
    }
    {
      action = "<cmd>Telescope find_files<CR>";
      key = "<leader>ff";
    }
    {
      action = "<cmd>Telescope lsp_definitions<CR>";
      key = "<leader>gd";
    }
    {
      action = "<cmd>Telescope lsp_references<CR>";
      key = "<leader>gr";
    }
    {
      action = "<cmd>Telescope lsp_implementations<CR>";
      key = "<leader>gi";
    }
  ];
}
