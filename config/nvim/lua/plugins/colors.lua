local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

return {
  {
    dir = vim.fn.stdpath("config"),
    name = "dotfiles-editor",
    lazy = false,
    priority = 1000,
    config = function()
      local c = {
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
      vim.g.colors_name = "dotfiles-editor"

      hl("Normal", { fg = c.fg, ctermbg = 0 })
      hl("NormalFloat", { fg = c.fg, ctermbg = 0 })
      hl("FloatBorder", { fg = c.purple, ctermbg = 0 })
      hl("Cursor", { ctermfg = 0, ctermbg = 7 })
      hl("CursorLine", { ctermbg = 0 })
      hl("LineNr", { fg = c.dim })
      hl("CursorLineNr", { fg = c.purple, bold = true })
      hl("Visual", { fg = c.fg, ctermbg = 8 })
      hl("Search", { fg = "#11131a", bg = c.yellow })
      hl("IncSearch", { fg = "#11131a", bg = c.peach, bold = true })
      hl("StatusLine", { fg = c.fg, ctermbg = 8 })
      hl("StatusLineNC", { fg = c.muted, ctermbg = 0 })
      hl("WinSeparator", { fg = c.dim })
      hl("Pmenu", { fg = c.fg, ctermbg = 0 })
      hl("PmenuSel", { fg = "#11131a", bg = c.purple })
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
      hl("Todo", { fg = "#11131a", bg = c.yellow, bold = true })
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
