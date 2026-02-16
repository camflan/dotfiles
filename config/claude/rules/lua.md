---
paths:
  - "**/*.lua"
---
# Lua (Neovim)

- `vim` is a global provided by Neovim — not an error
- Use vim.keymap.set over vim.api.nvim_set_keymap
- Prefer vim.opt over vim.o for list/map options
