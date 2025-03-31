# Source: https://github.com/Ruixi-rebirth/nvim-flake/blob/68ffe64e325d082504aeee93451fabece55df19f/config/lazy_plugins/none-ls-nvim.nix
{
  pkgs,
  helpers,
  ...
}:
{
  pkg = pkgs.vimPlugins.none-ls-nvim;
  lazy = true;
  event = [
    "BufReadPre"
    "BufNewFile"
  ];
  dependencies = with pkgs.vimPlugins; [ plenary-nvim ];
  config = ''
    function()
      require("null-ls").setup({
        sources = {
          require("null-ls").builtins.formatting.black.with({
            command = "${pkgs.black}/bin/black",
          }),
          require("null-ls").builtins.formatting.clang_format.with({
            command = "${pkgs.clang-tools}/bin/clang-format",
          }),
          require("null-ls").builtins.formatting.cmake_format.with({
            command = "${pkgs.cmake-format}/bin/cmake-format",
          }),
          require("null-ls").builtins.formatting.gofumpt.with({
            command = "${pkgs.gofumpt}/bin/gofumpt",
          }),
          require("null-ls").builtins.formatting.nixfmt.with({
            command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt",
          }),
          require("null-ls").builtins.formatting.isort.with({
            command = "${pkgs.isort}/bin/isort",
            extra_args = { "--stdout", "--filename", "$FILENAME", "-" },
          }),
          require("null-ls").builtins.formatting.prettier.with({
            command = "${pkgs.nodePackages.prettier}/bin/prettier",
          }),
          require("null-ls").builtins.formatting.shfmt.with({
            command = "${pkgs.shfmt}/bin/shfmt",
          }),
          require("null-ls").builtins.formatting.stylua.with({
            command = "${pkgs.stylua}/bin/stylua",
            extra_args = { "--indent-type", "Spaces", "--indent-width", "2" },
          }),
          require("null-ls").builtins.formatting.gn_format.with({
            command = "${pkgs.gn}/bin/gn",
          }),
        },
      })
    end
  '';

  keys = helpers.mkRaw ''
    {
      {
        "<leader>ff",
        function()
          vim.lsp.buf.format({ async = false })
        end,
        mode = "",
        desc = "[F]ormat buffer",
      },
    }
  '';
}
