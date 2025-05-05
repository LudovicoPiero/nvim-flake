{ pkgs, ... }:
{
  pkg = pkgs.vimPlugins.dashboard-nvim;
  lazy = false;
  opts.__raw = ''
    function()
      -- ASCII logo
      local logo = [[

         ██╗     ██╗   ██╗██████╗  ██████╗ ██╗   ██╗██╗ ██████╗ ██████╗
         ██║     ██║   ██║██╔══██╗██╔═══██╗██║   ██║██║██╔════╝██╔═══██╗
         ██║     ██║   ██║██║  ██║██║   ██║██║   ██║██║██║     ██║   ██║
         ██║     ██║   ██║██║  ██║██║   ██║╚██╗ ██╔╝██║██║     ██║   ██║
         ███████╗╚██████╔╝██████╔╝╚██████╔╝ ╚████╔╝ ██║╚██████╗╚██████╔╝
         ╚══════╝ ╚═════╝ ╚═════╝  ╚═════╝   ╚═══╝  ╚═╝ ╚═════╝ ╚═════╝

      ]]
      logo = string.rep("\n", 8) .. logo .. "\n\n"

      local opts = {
        theme = "doom",
        hide = { statusline = false },
        config = {
          header = vim.split(logo, "\n"),
          center = {
            {
              action = function()
                require("fzf-lua").files()
              end,
              desc = "Find File",
              icon = " ",
              key = "f",
            },
            {
              action = function()
                -- create and open a new empty buffer
                vim.cmd("ene | startinsert")
              end,
              desc = "New File",
              icon = " ",
              key = "n",
            },
            {
              action = function()
                require("fzf-lua").oldfiles()
              end,
              desc = "Recent Files",
              icon = " ",
              key = "r",
            },
            {
              action = function()
                require("fzf-lua").grep()
              end,
              desc = "Find Text",
              icon = " ",
              key = "g",
            },
            {
              action = function()
                vim.api.nvim_input("<cmd>qa<cr>")
              end,
              desc = "Quit",
              icon = " ",
              key = "q",
            },
          },
        },
      }

      -- pad descriptions for uniform alignment
      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
        button.key_format = "  %s"
      end

      return opts
    end
  '';
}
