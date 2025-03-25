{ pkgs, ... }:
let
  nvim-plugintree = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;

  treesitter-parsers = pkgs.symlinkJoin {
    name = "treesitter-parsers";
    paths = nvim-plugintree.dependencies;
  };
in
{
  pkg = pkgs.vimPlugins.nvim-treesitter;
  event = [
    "BufReadPost"
    "BufNewFile"
    "BufWritePre"
  ];
  config = ''
    function()
      -- Uncomment if you want to enable folding
      -- vim.wo.foldmethod = 'expr'
      -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.opt.runtimepath:append("${nvim-plugintree}")
      vim.opt.runtimepath:append("${treesitter-parsers}")
      require'nvim-treesitter.configs'.setup {
        parser_install_dir = "${treesitter-parsers}",
        ensure_installed = {},
        auto_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      }

      vim.filetype.add({
        extension = { rasi = "rasi", rofi = "rasi", wofi = "rasi" },
        filename = {
          ["vifmrc"] = "vim",
        },
        pattern = {
          [".*/waybar/config"] = "jsonc",
          [".*/mako/config"] = "dosini",
          [".*/kitty/.+%.conf"] = "kitty",
          [".*/hypr/.+%.conf"] = "hyprlang",
          ["%.env%.[%w_.-]+"] = "sh",
        },
      })
      vim.treesitter.language.register("bash", "kitty")
    end
  '';
}
