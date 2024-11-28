{helpers, ...}: {
  plugins.neocord = {
    enable = helpers.enableExceptInTests;
    settings = {
      auto_update = true;
      blacklist = [];
      client_id = "1157438221865717891";
      debounce_timeout = 10;
      enable_line_number = false;
      file_assets = null;
      file_explorer_text = "📁 Browsing Files";
      git_commit_text = "📝 Committing changes";
      global_timer = true;
      line_number_text = "Line %s out of %s";
      log_level = null;
      logo = "auto";
      logo_tooltip = null;
      main_image = "language";
      plugin_manager_text = "💄 Managing plugins";
      reading_text = "🤓 Reading %s";
      show_time = true;
      terminal_text = "Using Terminal";
    };

    luaConfig.post = ''
      -- Source: https://github.com/scottmckendry/Windots/blob/5283ac9baf87bde2513c9d61f2c27aa7ce4bcd72/nvim/lua/plugins/neocord.lua
      require("neocord").setup({
        editing_text = function(_)
          local filepath = vim.fn.expand("%:~:.") -- Get the relative path (from cwd) or full path if it's outside
          if filepath == "" then
            return "✏️ Editing a file"
          end
          return "✏️ Editing " .. filepath
        end,

        workspace_text = function(project_name)
          if project_name == nil then
            return "💻 Just chilling"
          end

          local git_origin = vim.system({ "git", "config", "--get", "remote.origin.url" }):wait()

          -- Only display projects that I personally own or have forked, otherwise assume it's not something I want to share
          if string.find(git_origin.stdout, "LudovicoPiero") ~= nil then
            return "Working on " .. project_name:gsub("%a", string.upper, 1) .. " 🚀"
          end

          return "Working on a private project 🤫"
        end,
      })
    '';
  };
}
