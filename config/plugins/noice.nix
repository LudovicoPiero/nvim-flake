{ pkgs, inputs, ... }:
{
  pkg = pkgs.vimPlugins.noice-nvim;
  event = "VeryLazy";
  dependencies = [ (pkgs.vimPlugins.nui-nvim.overrideAttrs { src = inputs.nui-nvim; }) ];
  config = ''
    function()
      require("noice").setup({
          lsp = {
              override = {
                  ["cmp.entry.get_documentation"] = true,
                  ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                  ["vim.lsp.util.stylize_markdown"] = true,
              },
          },
          presets = {
              bottom_search = true,
              command_palette = true,
              inc_rename = false,
              long_message_to_split = true,
              lsp_doc_border = false
          },
          routes = {
              {
                  filter = {
                      any = {
                          { find = "%d+L, %d+B" },
                          { find = "; after #%d+" },
                          { find = "; before #%d+" },
                          { find = "%d fewer lines" },
                          { find = "%d more lines" },
                      },
                      event = "msg_show",
                  },
                  opts = { skip = true },
              },
          },
          views = {
              cmdline_popup = {
                  position = { col = "50%", row = 13 },
                  size = { height = "auto", min_width = 60, width = "auto" },
              },
              cmdline_popupmenu = {
                  border = { padding = { 0, 1 }, style = "rounded" },
                  position = { col = "50%", row = 16 },
                  relative = "editor",
                  size = { height = "auto", max_height = 15, width = 60 },
                  win_options = { winhighlight = { FloatBorder = "NoiceCmdlinePopupBorder", Normal = "Normal" } },
              },
              mini = { win_options = { winblend = 0 } },
          },
      })
    end
  '';
}
