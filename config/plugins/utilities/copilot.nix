{
  plugins = {
    copilot-lua = {
      enable = true;

      settings = {
        # Needed for copilot-cmp to work.
        panel.enabled = false;
        suggestion.enabled = false;
      };
    };

    copilot-cmp.enable = true;
  };
}
