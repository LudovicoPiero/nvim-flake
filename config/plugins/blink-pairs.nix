{ pkgs, ... }:
{
  pkg = pkgs.vimPlugins.blink-pairs;
  init = ''
    function()
      vim.keymap.set("n", "<leader>tp", function()
        -- Toggle blink pairs mappings
        vim.g.blink_pairs_disabled = not vim.g.blink_pairs_disabled

        local mappings = require("blink.pairs.mappings")
        if vim.g.blink_pairs_disabled then
          mappings.disable()
        else
          mappings.enable()
        end
      end, { desc = "Toggle auto pairs" })
    end
  '';
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
}
