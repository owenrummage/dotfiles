return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    cmd = { "Neotree", "Tree" },
    keys = {
      { "<leader>e", "<cmd>Tree<cr>", desc = "File tree" },
    },
    config = function()
      require("neo-tree").setup({
        filesystem = {
          follow_current_file = { enabled = true },
          filtered_items = {
            visible = true,
            hide_dotfiles = false,
          },
          use_libuv_file_watcher = true,
        },
      })
      vim.api.nvim_create_user_command("Tree", "Neotree toggle reveal left", {})
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    opts = {
      defaults = {
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = function()
      local colors = {
        background = "#101214",
        foreground = "#d7dbe0",
        color1 = "#c28f8f",
        color2 = "#c8cdd3",
        color3 = "#b8aa8a",
        color4 = "#c8cdd3",
        color5 = "#c8cdd3",
        color8 = "#565d66",
      }
      local path = vim.fn.expand("~/.cache/wal/colors.sh")
      if vim.fn.filereadable(path) == 1 then
        for _, line in ipairs(vim.fn.readfile(path)) do
          local key, value = line:match("^([%w_]+)='(#[0-9A-Fa-f]+)'")
          if key and colors[key] ~= nil then
            colors[key] = value
          end
        end
      end

      local theme = {
        normal = {
          a = { fg = colors.background, bg = colors.color4, gui = "bold" },
          b = { fg = colors.foreground, bg = colors.color8 },
          c = { fg = colors.foreground, bg = colors.background },
        },
        insert = {
          a = { fg = colors.background, bg = colors.color2, gui = "bold" },
          b = { fg = colors.foreground, bg = colors.color8 },
          c = { fg = colors.foreground, bg = colors.background },
        },
        visual = {
          a = { fg = colors.background, bg = colors.color5, gui = "bold" },
          b = { fg = colors.foreground, bg = colors.color8 },
          c = { fg = colors.foreground, bg = colors.background },
        },
        replace = {
          a = { fg = colors.background, bg = colors.color1, gui = "bold" },
          b = { fg = colors.foreground, bg = colors.color8 },
          c = { fg = colors.foreground, bg = colors.background },
        },
        command = {
          a = { fg = colors.background, bg = colors.color3, gui = "bold" },
          b = { fg = colors.foreground, bg = colors.color8 },
          c = { fg = colors.foreground, bg = colors.background },
        },
        inactive = {
          a = { fg = colors.color8, bg = colors.background },
          b = { fg = colors.color8, bg = colors.background },
          c = { fg = colors.color8, bg = colors.background },
        },
      }

      return {
        options = {
          theme = theme,
          component_separators = "",
          section_separators = "",
          globalstatus = true,
        },
      }
    end,
  },
}
