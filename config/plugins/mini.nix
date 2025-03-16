{ pkgs, ... }:
{
  pkg = pkgs.vimPlugins.mini-nvim;
  config = ''
    function()
      require('mini.extra').setup()
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

      -- UI
      require('mini.tabline').setup()
      require('mini.icons').setup()
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = false }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      local hipatterns = require('mini.hipatterns')
      hipatterns.setup({
        highlighters = {
          -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
          fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
          hack  = { pattern = '%f[%w]()HACK()%f[%W]',  group = 'MiniHipatternsHack'  },
          todo  = { pattern = '%f[%w]()TODO()%f[%W]',  group = 'MiniHipatternsTodo'  },
          note  = { pattern = '%f[%w]()NOTE()%f[%W]',  group = 'MiniHipatternsNote'  },
      
          -- Highlight hex color strings (`#rrggbb`) using that color
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      })

      -- mini-pick
      require('mini.pick').setup()
      vim.keymap.set('n', '<leader>sd', "<Cmd>Pick diagnostic<CR>", { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sh', "<Cmd>Pick help<CR>", { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', "<Cmd>Pick keymaps<CR>", { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', "<Cmd>Pick files<CR>", { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>sg', "<Cmd>Pick grep_live<CR>", { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sr', "<Cmd>Pick resume<CR>", { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>so', "<Cmd>Pick oldfiles<CR>", { desc = '[S]earch [O]ld Files' })
      vim.keymap.set('n', '<leader>st', "<Cmd>Pick grep pattern='(TODO|FIXME|HACK|NOTE):'<CR>", { desc = '[S]earch [T]odo' })
      vim.keymap.set('n', '<leader><leader>', "<Cmd>Pick buffers<CR>", { desc = '[ ] Find existing buffers' })
    end
  '';
}
