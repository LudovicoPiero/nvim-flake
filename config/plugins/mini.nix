{ pkgs, ... }:
{
  pkg = pkgs.vimPlugins.mini-nvim;
  config = ''
    function()
      require('mini.ai').setup { n_lines = 500 }

      require('mini.diff').setup()
      require('mini.git').setup()

      require('mini.splitjoin').setup()

      require('mini.bufremove').setup()
      require('mini.starter').setup()
      require('mini.pairs').setup()
      require('mini.comment').setup()

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup({
        mappings = {
          add = 'gsa', -- Add surrounding in Normal and Visual modes
          delete = 'gsd', -- Delete surrounding
          find = 'gsf', -- Find surrounding (to the right)
          find_left = 'gsf',
          highlight = 'gsh',
          replace = 'gsr',
          update_n_lines = 'gsn',
        },
      })
    end
  '';
}
