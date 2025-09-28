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
          ruff_format = {
            command = "${pkgs.ruff}/bin/ruff",
            args = { "format", "--stdin-filename", "$FILENAME", "-" },
            stdin = true,
          },
          ruff_fix = {
            command = "${pkgs.ruff}/bin/ruff",
            args = { "check", "--fix", "--stdin-filename", "$FILENAME", "-" },
            stdin = true,
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
          goimports = {
            command = "${pkgs.gotools}/bin/goimports",
          },
          nixfmt = {
            command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt",
            prepend_args = { "--strict" },
          },
          shfmt = {
            command = "${pkgs.shfmt}/bin/shfmt",
          },
          shellcheck = {
            command = "${pkgs.shellcheck}/bin/shellcheck",
          },
          shellharden = {
            command = "${pkgs.shellharden}/bin/shellharden",
          },
          prettier = {
            command = "${pkgs.nodePackages.prettier}/bin/prettier",
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
          python = { "ruff_fix", "ruff_format" },
          c = { "clang_format" },
          cpp = { "clang_format" },
          cmake = { "cmake_format" },
          go = { "gofumpt", "goimports" },
          nix = { "nixfmt" },
          sh = { "shellcheck", "shellharden", "shfmt" },
          bash = { "shellcheck", "shellharden", "shfmt" },
          html = { "prettier" },
          javascript = { "prettier" },
          json = { "prettier" },
          rust = { "rustfmt", lsp_format = "fallback" },
          gn = { "gn" },
          yaml = { "prettier" },
          markdown = { "prettier" },
          css = { "prettier" },
          scss = { "prettier" },
          less = { "prettier" },
          typescript = { "prettier" },
          typescriptreact = { "prettier" },
          javascriptreact = { "prettier" },
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
