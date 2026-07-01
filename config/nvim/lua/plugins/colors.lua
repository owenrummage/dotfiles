local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

return {
  {
    dir = vim.fn.stdpath("config"),
    name = "pastel-punch",
    lazy = false,
    priority = 1000,
    config = function()
      local c = {
        bg = "#11131a",
        bg_alt = "#181b24",
        bg_lift = "#232735",
        fg = "#d8d7e8",
        muted = "#7f8496",
        dim = "#5e6475",
        blue = "#8ab4ff",
        cyan = "#7bdff2",
        green = "#9be7a8",
        yellow = "#f2d98a",
        peach = "#f6b08f",
        pink = "#f0a6ca",
        purple = "#c6a0ff",
        red = "#ff8f9a",
      }

      vim.o.background = "dark"
      vim.o.termguicolors = true
      vim.cmd("highlight clear")
      if vim.fn.exists("syntax_on") == 1 then
        vim.cmd("syntax reset")
      end
      vim.g.colors_name = "pastel-punch"

      hl("Normal", { fg = c.fg, bg = c.bg })
      hl("NormalFloat", { fg = c.fg, bg = c.bg_alt })
      hl("FloatBorder", { fg = c.purple, bg = c.bg_alt })
      hl("Cursor", { fg = c.bg, bg = c.fg })
      hl("CursorLine", { bg = c.bg_alt })
      hl("LineNr", { fg = c.dim })
      hl("CursorLineNr", { fg = c.purple, bold = true })
      hl("Visual", { fg = c.fg, bg = c.bg_lift })
      hl("Search", { fg = c.bg, bg = c.yellow })
      hl("IncSearch", { fg = c.bg, bg = c.peach, bold = true })
      hl("StatusLine", { fg = c.fg, bg = c.bg_lift })
      hl("StatusLineNC", { fg = c.muted, bg = c.bg_alt })
      hl("WinSeparator", { fg = c.dim })
      hl("Pmenu", { fg = c.fg, bg = c.bg_alt })
      hl("PmenuSel", { fg = c.bg, bg = c.purple })
      hl("Directory", { fg = c.blue })
      hl("Title", { fg = c.purple, bold = true })
      hl("ErrorMsg", { fg = c.red, bold = true })
      hl("WarningMsg", { fg = c.yellow })
      hl("Comment", { fg = c.muted, italic = true })
      hl("Constant", { fg = c.peach })
      hl("String", { fg = c.green })
      hl("Identifier", { fg = c.fg })
      hl("Function", { fg = c.blue })
      hl("Statement", { fg = c.purple })
      hl("Keyword", { fg = c.purple, bold = true })
      hl("PreProc", { fg = c.cyan })
      hl("Type", { fg = c.cyan })
      hl("Special", { fg = c.pink })
      hl("Underlined", { fg = c.blue, underline = true })
      hl("Todo", { fg = c.bg, bg = c.yellow, bold = true })
      hl("DiagnosticError", { fg = c.red })
      hl("DiagnosticWarn", { fg = c.yellow })
      hl("DiagnosticInfo", { fg = c.blue })
      hl("DiagnosticHint", { fg = c.muted })
      hl("GitSignsAdd", { fg = c.green })
      hl("GitSignsChange", { fg = c.yellow })
      hl("GitSignsDelete", { fg = c.red })
    end,
  },
}
