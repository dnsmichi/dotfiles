-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Keep the editor cursor visible against both the dark and light Ghostty themes.
vim.opt.guicursor = {
  "n-v-c:block-Cursor/lCursor",
  "i-ci:block-Cursor/lCursor",
  "r-cr:hor20-Cursor/lCursor",
  "o:hor50-Cursor/lCursor",
}

local function set_cursor_highlights()
  local cursor_background = "#fabd2f"
  local cursor_foreground = "#282828"

  vim.api.nvim_set_hl(0, "Cursor", {
    bg = cursor_background,
    fg = cursor_foreground,
  })
  vim.api.nvim_set_hl(0, "lCursor", {
    bg = cursor_background,
    fg = cursor_foreground,
  })
  vim.api.nvim_set_hl(0, "CursorIM", {
    bg = cursor_background,
    fg = cursor_foreground,
  })
  vim.api.nvim_set_hl(0, "TermCursor", {
    bg = cursor_background,
    fg = cursor_foreground,
  })
end

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = set_cursor_highlights,
  desc = "Keep the cursor readable after a colorscheme change",
})

set_cursor_highlights()
