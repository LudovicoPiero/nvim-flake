require("nvim-highlight-colors").setup({
  -- Render style ('background'|'foreground'|'virtual').
  render = "virtual",

  -- Virtual symbol.
  virtual_symbol = "󱓻",
  -- Virtual symbol prefix.
  virtual_symbol_prefix = "",
  -- Virtual symbol suffix.
  virtual_symbol_suffix = " ",

  -- Virtual symbol position ('inline'|'eol'|'eow').
  virtual_symbol_position = "inline",

  -- Highlight hex colors.
  enable_hex = true,
  -- Highlight short hex colors.
  enable_short_hex = true,
  -- Highlight rgb colors.
  enable_rgb = true,
  -- Highlight hsl colors.
  enable_hsl = true,
  -- Highlight ansi colors.
  enable_ansi = true,
  -- Highlight CSS hsl colors.
  enable_hsl_without_function = true,
  -- Highlight CSS variables.
  enable_var_usage = true,
  -- Highlight named colors.
  enable_named_colors = true,
  -- Highlight tailwind colors.
  enable_tailwind = false,

  -- Custom colors.
  -- Label is a lua pattern.
  custom_colors = {
    { label = "%-%-theme%-primary%-color", color = "#0f1219" },
    { label = "%-%-theme%-secondary%-color", color = "#5a5d64" },
  },
})
