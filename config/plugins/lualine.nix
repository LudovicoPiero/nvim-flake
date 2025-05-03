{ pkgs, ... }:
{
  pkg = pkgs.vimPlugins.lualine-nvim;
  lazy = false;
  dependencies = with pkgs.vimPlugins; [ nvim-web-devicons ];
  opts.__raw = ''
    function()
      local lualine = require("lualine")
      local colors = {
        bg       = "#202328", fg = "#bbc2cf", yellow = "#ECBE7B", cyan = "#008080",
        darkblue = "#081633", green = "#98be65", orange = "#FF8800", violet = "#a9a1e1",
        magenta  = "#c678dd", blue = "#51afef", red = "#ec5f67",
      }
      local conditions = {
        buffer_not_empty = function()
          return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
        end,
        hide_in_width = function()
          return vim.fn.winwidth(0) > 80
        end,
        check_git_workspace = function()
          local filepath = vim.fn.expand("%:p:h")
          local gitdir = vim.fn.finddir(".git", filepath .. ";")
          return gitdir and #gitdir > 0 and #gitdir < #filepath
        end,
      }
      local config = {
        options = {
          component_separators = "",
          section_separators = "",
          theme = { normal = { c = { fg = colors.fg, bg = colors.bg } }, inactive = { c = { fg = colors.fg, bg = colors.bg } } },
        },
        sections = { lualine_a = {}, lualine_b = {}, lualine_y = {}, lualine_z = {}, lualine_c = {}, lualine_x = {} },
        inactive_sections = { lualine_a = {}, lualine_b = {}, lualine_y = {}, lualine_z = {}, lualine_c = {}, lualine_x = {} },
      }
      local function ins_left(component)
        table.insert(config.sections.lualine_c, component)
      end
      local function ins_right(component, pos)
        if pos then table.insert(config.sections.lualine_x, pos, component) else table.insert(config.sections.lualine_x, component) end
      end
      ins_left {
        function() return "▊" end,
        color = { fg = colors.blue }, padding = { left = 0, right = 1 },
      }
      -- Mode as text instead of icon
      ins_left {
        "mode",                    -- built-in mode component
        fmt = function(str)       -- capitalize first letter
          return str:sub(1,1):upper() .. str:sub(2)
        end,
        color = function()
          local mode_colors = {
            n = colors.red, i = colors.green, v = colors.blue,
            V = colors.blue, [""] = colors.blue, c = colors.magenta,
            no = colors.red, s = colors.orange, S = colors.orange,
            [""] = colors.orange, ic = colors.yellow, R = colors.violet,
            Rv = colors.violet, cv = colors.red, ce = colors.red,
            r = colors.cyan, rm = colors.cyan, ["r?"] = colors.cyan,
            ["!"] = colors.red, t = colors.red,
          }
          local m = vim.fn.mode()
          return { fg = mode_colors[m] or colors.fg, gui = "bold" }
        end,
        padding = { right = 1 },
      }
      ins_left { "filesize", cond = conditions.buffer_not_empty }
      ins_left { "filename", path = 1, cond = conditions.buffer_not_empty, color = { fg = colors.magenta, gui = "bold" } }
      ins_left { "location" }
      ins_left { "progress", color = { fg = colors.fg, gui = "bold" } }
      ins_left {
        "diagnostics", sources = { "nvim_diagnostic" }, symbols = { error = " ", warn = " ", info = " " },
        diagnostics_color = { error = { fg = colors.red }, warn = { fg = colors.yellow }, info = { fg = colors.cyan } },
      }
      ins_left { function() return"%=" end }
      ins_left {
        function()
          local msg = "No Active Lsp"
          local ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
          for _, client in ipairs(vim.lsp.get_clients()) do
            if client.config.filetypes and vim.fn.index(client.config.filetypes, ft) ~= -1 then
              return client.name
            end
          end
          return msg
        end,
        icon = " LSP:", color = { fg = "#ffffff", gui = "bold" },
      }
      ins_right { "o:encoding", fmt = string.upper, cond = conditions.hide_in_width, color = { fg = colors.green, gui = "bold" } }
      ins_right { "fileformat", fmt = string.upper, icons_enabled = false, color = { fg = colors.green, gui = "bold" } }
      ins_right { "branch", icon = "", color = { fg = colors.violet, gui = "bold" } }
      ins_right {
        "diff", symbols = { added = " ", modified = "󰝤 ", removed = " " },
        diff_color = { added = { fg = colors.green }, modified = { fg = colors.orange }, removed = { fg = colors.red } },
        cond = conditions.hide_in_width,
      }
      ins_right { function() return "▊" end, color = { fg = colors.blue }, padding = { left = 1 } }
      ins_right({
        function()
          local clients = (package.loaded["copilot"] and vim.lsp.get_clients({ name = "copilot", bufnr = 0 })) or {}
          if #clients > 0 then
            local st = require("copilot.api").status.data.status
            local label = (st == "InProgress" and "pending") or (st == "Warning" and "error") or "ok"
            return "  " .. label
          end
          return ""
        end,
        color = function()
          local clients = (package.loaded["copilot"] and vim.lsp.get_clients({ name = "copilot", bufnr = 0 })) or {}
          if #clients > 0 then
            local st = require("copilot.api").status.data.status
            if st == "InProgress" then return { fg = colors.yellow, gui = "bold" }
            elseif st == "Warning" then return { fg = colors.red, gui = "bold" }
            else return { fg = colors.blue, gui = "bold" }
            end
          end
          return { fg = colors.fg }
        end,
      }, 2)
      lualine.setup(config)
    end
  '';
}
