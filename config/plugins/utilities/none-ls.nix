{ pkgs, ... }:
{
  plugins.none-ls = {
    enable = true;
    sources = {
      formatting = {
        # C / C++
        clang_format.enable = true;

        # C-sharp
        csharpier.enable = true;

        # Nix
        nixfmt = {
          enable = true;
          package = pkgs.nixfmt-rfc-style;
        };

        # Lua
        stylua.enable = true;

        # Bash / SH
        shfmt.enable = true;

        # Python
        black.enable = true;
        isort.enable = true;

        # JS Family
        prettier = {
          disableTsServerFormatter = true;
          enable = true;
        };

        # Go
        gofmt.enable = true;
      };
    };
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
