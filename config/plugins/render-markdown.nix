{ pkgs, ... }:
{
  pkg = pkgs.vimPlugins.render-markdown-nvim;
  dependencies = [ pkgs.vimPlugins.nvim-web-devicons ];
  config = ''
    function()
      require('render-markdown').setup({
          completions = { blink = { enabled = true } },
      })
    end
  '';
}
