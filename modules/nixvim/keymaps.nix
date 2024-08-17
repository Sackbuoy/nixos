{ config, pkgs, ... }:
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
      key = "<leader>fw";
    }
    {
      action = "<cmd>Telescope find_files<CR>";
      key = "<leader>ff";
    }
  ];
}
