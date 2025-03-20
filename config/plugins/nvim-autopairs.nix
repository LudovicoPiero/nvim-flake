{ pkgs, ... }:
{
  pkg = pkgs.vimPlugins.nvim-autopairs;
  event = "InsertEnter";
  config = ''
    function()
      require("nvim-autopairs").setup {}
    end
  '';
}
