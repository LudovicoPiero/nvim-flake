{ pkgs, ... }:
{
  pkg = pkgs.vimPlugins.gruvbox-material;
  lazy = false;
  priority = 1000;
  config = ''
    function()
      -- For dark version
      vim.o.background = "dark"

      -- Available values: 'hard', 'medium' (default), 'soft'
      vim.g.gruvbox_material_background = "hard"

      -- For better performance
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_transparent_background = 1

      -- Load colorscheme
      vim.cmd.colorscheme("gruvbox-material")
    end
  '';
}
