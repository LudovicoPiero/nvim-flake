{ inputs, pkgs, ... }:
{
  pkg = inputs.blink-pairs.packages.${pkgs.system}.default;
  opts.__raw = ''
    {
      mappings = {
        -- you can call require("blink.pairs.mappings").enable() and require("blink.pairs.mappings").disable() to enable/disable mappings at runtime
        enabled = true,
        -- see the defaults: https://github.com/Saghen/blink.pairs/blob/main/lua/blink/pairs/config/mappings.lua#L10
        pairs = {
          ["'"] = {},
        },
      },
      highlights = {
        enabled = true,
        groups = {
          'BlinkPairsOrange',
          'BlinkPairsPurple',
          'BlinkPairsBlue',
        },
        matchparen = {
          enabled = true,
          group = 'MatchParen',
        },
      },
      debug = false,
    }
  '';
  keys.__raw = ''
    {
      {
        "<leader>tp",
        function()
          if vim.g.minipairs_disable then
            require("blink.pairs.mappings").enable()
            vim.g.minipairs_disable = false
          else
            require("blink.pairs.mappings").disable()
            vim.g.minipairs_disable = true
          end
        end,
        desc = "Toggle auto pairs",
      },
    }
  '';
}
