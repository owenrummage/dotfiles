local function wal_colors()
  local colors = {
    background = "#06070e",
    foreground = "#c0c1c2",
    cursor = "#c0c1c2",
    color0 = "#06070e",
    color1 = "#2135BC",
    color2 = "#172ECC",
    color3 = "#233AD7",
    color4 = "#223AE3",
    color5 = "#2B41DC",
    color6 = "#344BF0",
    color7 = "#c0c1c2",
    color8 = "#555569",
    color9 = "#2135BC",
    color10 = "#172ECC",
    color11 = "#233AD7",
    color12 = "#223AE3",
    color13 = "#2B41DC",
    color14 = "#344BF0",
    color15 = "#c0c1c2",
  }

  local path = vim.fn.expand("~/.cache/wal/colors.sh")
  if vim.fn.filereadable(path) == 0 then
    return colors
  end

  for _, line in ipairs(vim.fn.readfile(path)) do
    local key, value = line:match("^([%w_]+)='(#[0-9A-Fa-f]+)'")
    if key and colors[key] ~= nil then
      colors[key] = value
    end
  end

  return colors
end

return {
  {
    dir = vim.fn.stdpath("config"),
    name = "dotfiles-wal",
    lazy = false,
    priority = 1000,
    config = function()
      local c = wal_colors()

      vim.o.background = "dark"
      vim.cmd("highlight clear")
      if vim.fn.exists("syntax_on") == 1 then
        vim.cmd("syntax reset")
      end
      vim.g.colors_name = "dotfiles-wal"

      local set = vim.api.nvim_set_hl
      set(0, "Normal", { fg = c.foreground, bg = c.background })
      set(0, "NormalFloat", { fg = c.foreground, bg = c.color0 })
      set(0, "FloatBorder", { fg = c.color4, bg = c.color0 })
      set(0, "Cursor", { fg = c.background, bg = c.cursor })
      set(0, "CursorLine", { bg = c.color0 })
      set(0, "LineNr", { fg = c.color8 })
      set(0, "CursorLineNr", { fg = c.color4, bold = true })
      set(0, "Visual", { fg = c.background, bg = c.color4 })
      set(0, "Search", { fg = c.background, bg = c.color3 })
      set(0, "IncSearch", { fg = c.background, bg = c.color11, bold = true })
      set(0, "StatusLine", { fg = c.foreground, bg = c.color8 })
      set(0, "StatusLineNC", { fg = c.color7, bg = c.color0 })
      set(0, "WinSeparator", { fg = c.color8 })
      set(0, "Pmenu", { fg = c.foreground, bg = c.color0 })
      set(0, "PmenuSel", { fg = c.background, bg = c.color4 })
      set(0, "Directory", { fg = c.color4 })
      set(0, "Title", { fg = c.color4, bold = true })
      set(0, "ErrorMsg", { fg = c.color1, bold = true })
      set(0, "WarningMsg", { fg = c.color3 })
      set(0, "Comment", { fg = c.color8, italic = true })
      set(0, "Constant", { fg = c.color3 })
      set(0, "String", { fg = c.color2 })
      set(0, "Identifier", { fg = c.foreground })
      set(0, "Function", { fg = c.color4 })
      set(0, "Statement", { fg = c.color5 })
      set(0, "Keyword", { fg = c.color5 })
      set(0, "PreProc", { fg = c.color6 })
      set(0, "Type", { fg = c.color6 })
      set(0, "Special", { fg = c.color13 })
      set(0, "Underlined", { fg = c.color4, underline = true })
      set(0, "Todo", { fg = c.background, bg = c.color11, bold = true })
      set(0, "DiagnosticError", { fg = c.color1 })
      set(0, "DiagnosticWarn", { fg = c.color3 })
      set(0, "DiagnosticInfo", { fg = c.color4 })
      set(0, "DiagnosticHint", { fg = c.color6 })
      set(0, "GitSignsAdd", { fg = c.color2 })
      set(0, "GitSignsChange", { fg = c.color3 })
      set(0, "GitSignsDelete", { fg = c.color1 })
    end,
  },
}
