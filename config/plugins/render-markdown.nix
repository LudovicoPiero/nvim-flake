{ pkgs, ... }:
{
  pkg = pkgs.vimPlugins.render-markdown-nvim;
  dependencies = [ pkgs.vimPlugins.nvim-web-devicons ];

  ft = [
    "markdown"
    "norg"
    "org"
  ];

  opts.__raw = ''
    {
      render_modes = { "n", "c", "t" },
      preset = "lazy",
      code = {
        sign = true,
      },
      heading = {
        sign = true,
      },
    }
  '';
}
