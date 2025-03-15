{
  plugins.colorizer = {
    enable = true;
    settings = {
      filetypes = { };
      buftypes = { };
      user_commands = true;
      user_default_options = {
        RGB = true;
        RRGGBB = true;
        names = true;
        RRGGBBAA = true;
        AARRGGBB = true;
        rgb_fn = true;
        hsl_fn = true;
        css = true;
        css_fn = true;
        mode = "background";
        tailwind = true;
        sass = {
          enable = true;
          parsers = [ "css" ];
        };
        virtualtext = "■";
        virtualtext_inline = false;
        virtualtext_mode = "foreground";
        always_update = false;
      };
    };
  };
}
