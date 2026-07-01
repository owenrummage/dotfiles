local function pywal_accent()
  local path = vim.fn.expand("~/.cache/wal/colors.sh")
  if vim.fn.filereadable(path) == 0 then
    return "#5f87d7"
  end

  local fallback = nil
  for _, line in ipairs(vim.fn.readfile(path)) do
    local bright = line:match("^color9='(#[0-9A-Fa-f]+)'")
    if bright then
      return bright
    end

    local color = line:match("^color1='(#[0-9A-Fa-f]+)'")
    if color then
      fallback = color
    end
  end

  return fallback or "#5f87d7"
end

return {
  {
    dir = vim.fn.stdpath("config"),
    name = "dotfiles-monochrome",
    lazy = false,
    priority = 1000,
    config = function()
      local accent = pywal_accent()
      local bg = "#101214"
      local bg_alt = "#181b1f"
      local bg_lift = "#20252b"
      local fg = "#f4f7fb"
      local muted = "#6f7880"

      vim.o.background = "dark"
      vim.cmd("highlight clear")
      if vim.fn.exists("syntax_on") == 1 then
        vim.cmd("syntax reset")
      end
      vim.g.colors_name = "dotfiles-monochrome"

      local set = vim.api.nvim_set_hl
      set(0, "Normal", { fg = fg, bg = bg })
      set(0, "NormalFloat", { fg = fg, bg = bg_alt })
      set(0, "FloatBorder", { fg = accent, bg = bg_alt })
      set(0, "Cursor", { fg = bg, bg = accent })
      set(0, "CursorLine", { bg = bg_alt })
      set(0, "LineNr", { fg = muted })
      set(0, "CursorLineNr", { fg = accent, bold = true })
      set(0, "Visual", { fg = bg, bg = accent })
      set(0, "Search", { fg = bg, bg = accent })
      set(0, "IncSearch", { fg = bg, bg = accent, bold = true })
      set(0, "StatusLine", { fg = fg, bg = bg_lift })
      set(0, "StatusLineNC", { fg = muted, bg = bg_alt })
      set(0, "WinSeparator", { fg = muted })
      set(0, "Pmenu", { fg = fg, bg = bg_alt })
      set(0, "PmenuSel", { fg = bg, bg = accent })
      set(0, "Directory", { fg = accent })
      set(0, "Title", { fg = accent, bold = true })
      set(0, "ErrorMsg", { fg = accent, bold = true })
      set(0, "WarningMsg", { fg = accent })
      set(0, "Comment", { fg = muted, italic = true })
      set(0, "Constant", { fg = fg })
      set(0, "String", { fg = fg })
      set(0, "Identifier", { fg = fg })
      set(0, "Function", { fg = fg })
      set(0, "Statement", { fg = accent })
      set(0, "Keyword", { fg = accent })
      set(0, "PreProc", { fg = fg })
      set(0, "Type", { fg = fg })
      set(0, "Special", { fg = accent })
      set(0, "Underlined", { fg = accent, underline = true })
      set(0, "Todo", { fg = bg, bg = accent, bold = true })
      set(0, "DiagnosticError", { fg = accent })
      set(0, "DiagnosticWarn", { fg = accent })
      set(0, "DiagnosticInfo", { fg = fg })
      set(0, "DiagnosticHint", { fg = muted })
      set(0, "GitSignsAdd", { fg = accent })
      set(0, "GitSignsChange", { fg = accent })
      set(0, "GitSignsDelete", { fg = accent })
    end,
  },
}
