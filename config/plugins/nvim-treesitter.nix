{ pkgs, ... }:
let
  nvim-plugintree = pkgs.vimPlugins.nvim-treesitter.withPlugins (
    p: with p; [
      bash
      c
      cmake
      cpp
      diff
      html
      go
      haskell
      javascript
      json
      lua
      luadoc
      markdown
      markdown_inline
      meson
      nix
      python
      query
      rust
      toml
      vim
      vimdoc
      yaml
    ]
  );

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
    end
  '';
}
