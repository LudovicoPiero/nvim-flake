{
  plugins.conform-nvim = {
    enable = true;
    notifyOnError = true;
    formattersByFt = {
      nix = [ "nixfmt" ];
      lua = [ "stylua" ];
      python = # Conform will run multiple formatters sequentially
        [
          "isort"
          "black"
        ];
      html = [
        [
          "prettierd"
          "prettier"
        ]
      ];
      css = [
        [
          "prettierd"
          "prettier"
        ]
      ];
      javascriptreact = [
        [
          "prettierd"
          "prettier"
        ]
      ];
      typescript = [
        [
          "prettierd"
          "prettier"
        ]
      ];
      typescriptreact = [
        [
          "prettierd"
          "prettier"
        ]
      ];
      javascript = [
        [
          "prettierd"
          "prettier"
        ]
      ];
      md = [ "prettier" ];
      sh = [ "shfmt" ];
      "_" = [ "trim_whitespace" ];
    };
    # Customize formatters
    formatters = {
      shfmt = {
        prepend_args = [
          "-i"
          "2"
        ];
      };
      stylua = {
        prepend_args = [
          "--indent-type"
          "Spaces"
          "--indent-width"
          "2"
        ];
      };
    };
  };

  keymaps = [
    {
      mode = "";
      key = "<leader>ff";
      action = "<cmd>lua require(\"conform\").format({ async = true, lsp_fallback = true })<cr>";
      options = {
        desc = "Format Buffer";
        silent = true;
      };
    }
  ];
}
