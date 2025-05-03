{ pkgs, ... }:
{
  pkg = pkgs.vimPlugins.conform-nvim;
  lazy = true;
  event = [ "BufWritePre" ];
  cmd = [ "ConformInfo" ];
  dependencies = with pkgs.vimPlugins; [ plenary-nvim ];
  config = ''
    function()
      require("conform").setup({
        formatters = {
          stylua = {
            command = "${pkgs.stylua}/bin/stylua",
            prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
          },
          isort = {
            command = "${pkgs.isort}/bin/isort",
            prepend_args = { "--stdout", "--filename", "$FILENAME", "-" },
          },
          black = {
            command = "${pkgs.black}/bin/black",
          },
          clang_format = {
            command = "${pkgs.clang-tools}/bin/clang-format",
          },
          cmake_format = {
            command = "${pkgs.cmake-format}/bin/cmake-format",
          },
          gofumpt = {
            command = "${pkgs.gofumpt}/bin/gofumpt",
          },
          nixfmt = {
            command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt",
          },
          shfmt = {
            command = "${pkgs.shfmt}/bin/shfmt",
          },
          prettier = {
            command = "${pkgs.nodePackages.prettier}/bin/prettier",
          },
          prettierd = {
            command = "${pkgs.prettierd}/bin/prettierd",
          },
          rustfmt = {
            command = "${pkgs.rustfmt}/bin/rustfmt",
          },
          gn = {
            command = "${pkgs.gn}/bin/gn",
          },
        },
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "isort", "black" },
          c = { "clang_format" },
          cpp = { "clang_format" },
          cmake = { "cmake_format" },
          go = { "gofumpt" },
          nix = { "nixfmt" },
          sh = { "shfmt" },
          javascript = {
            "prettierd",
            "prettier",
            stop_after_first = true,
          },
          rust = { "rustfmt", lsp_format = "fallback" },
          gn = { "gn" },
        },
      })
    end
  '';

  keys.__raw = ''
    {
      {
        "<leader>ff",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "[F]ormat bu[F]fer",
      },
    }
  '';
}
