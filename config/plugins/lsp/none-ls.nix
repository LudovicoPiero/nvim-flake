{ pkgs, ... }:
{
  plugins.none-ls = {
    enable = true;
    sources = {
      formatting = {
        nixfmt = {
          enable = true;
          package = pkgs.nixfmt-rfc-style;
        };
        stylua.enable = true;
        shfmt.enable = true;
        black.enable = true;
        isort.enable = true;
        prettier = {
          disableTsServerFormatter = true;
          enable = true;
        };
        gofmt.enable = true;
      };
    };
    # onAttach = ''
    #   function(client, bufnr)
    #     if client.supports_method("textDocument/formatting") then
    #       vim.api.nvim_clear_autocmds({ group = vim.api.nvim_create_augroup("LspFormatting", {}), buffer = bufnr })
    #       vim.api.nvim_create_autocmd("BufWritePre", {
    #         group = vim.api.nvim_create_augroup("LspFormatting", {}),
    #         buffer = bufnr,
    #         callback = function()
    #             vim.lsp.buf.format({ async = false })
    #         end,
    #       })
    #     end
    #   end
    # '';
  };

  keymaps = [
    {
      mode = "";
      key = "<leader>ff";
      action = "<cmd>lua vim.lsp.buf.format()<cr>";
      options = {
        desc = "Format Buffer";
        silent = true;
      };
    }
  ];
}
