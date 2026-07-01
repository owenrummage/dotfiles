local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

local function hex_to_rgb(hex)
  return tonumber(hex:sub(2, 3), 16), tonumber(hex:sub(4, 5), 16), tonumber(hex:sub(6, 7), 16)
end

local function rgb_to_hex(r, g, b)
  return string.format("#%02x%02x%02x", r, g, b)
end

local function mix(a, b, amount)
  local ar, ag, ab = hex_to_rgb(a)
  local br, bg, bb = hex_to_rgb(b)
  local function channel(x, y)
    return math.floor(x + (y - x) * amount + 0.5)
  end
  return rgb_to_hex(channel(ar, br), channel(ag, bg), channel(ab, bb))
end

local function wal_background()
  local path = vim.fn.expand("~/.cache/wal/colors.sh")
  if vim.fn.filereadable(path) == 0 then
    return "#11131a"
  end

  for _, line in ipairs(vim.fn.readfile(path)) do
    local value = line:match("^background='(#[0-9A-Fa-f]+)'")
    if value then
      return value
    end
  end

  return "#11131a"
end

return {
  {
    dir = vim.fn.stdpath("config"),
    name = "pastel-punch",
    lazy = false,
    priority = 1000,
    config = function()
      local theme_bg = wal_background()
      local c = {
        bg = mix(theme_bg, "#000000", 0.35),
        bg_alt = mix(theme_bg, "#ffffff", 0.05),
        bg_lift = mix(theme_bg, "#ffffff", 0.12),
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
