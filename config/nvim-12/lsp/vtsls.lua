local twoslash = require("twoslash-queries")

local AUGROUP = "cf_vtsls"
local MAPGROUP = AUGROUP .. "_mapping"

local group = vim.api.nvim_create_augroup(AUGROUP, { clear = true })

--- @return table
local function get_buffer_map(bufnr)
  local ok, maps = pcall(vim.api.nvim_buf_get_var, bufnr, MAPGROUP)
  if ok then
    return maps or {}
  else
    return {}
  end
end

--- Remember the mapping in a buffer variable, so the bindings can be removed
--- when the LSP detaches. This isn't a huge problem, as the attach would
--- normally be called, overriding maps anyway.  but if I remove a map from the
--- code here, it would stay with the buffer after reloading if I didn't
--- @param buf integer
--- @param modes string|string[]
--- @param lhs string
--- @param rhs string|function
--- @param opts table
local function remember_buffer_map(buf, modes, lhs, rhs, opts)
  local _opts = opts or {}
  _opts["buffer"] = buf

  vim.keymap.set(modes, lhs, rhs, _opts)

  local maps = get_buffer_map(buf)
  table.insert(maps or {}, { modes = modes, lhs = lhs })
  vim.api.nvim_buf_set_var(buf, MAPGROUP, maps)
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = group,
  callback = function(event)
    local client_id = event.data.client_id
    local client = vim.lsp.get_client_by_id(client_id)
    local bufnr = event.buf

    -- unnecessary, right? This is just to suppress missing nil check warning
    if not client then
      error("No LSP client found")
    end

    twoslash.setup({
      highlight = "Comment",
      is_enabled = true,
      multi_line = true,
    })
    twoslash.enable()
    twoslash.attach(client, bufnr)

    remember_buffer_map(bufnr, { "n" }, "<leader>dq", "<cmd>TwoslashQueriesInspect<CR>", {
      desc = "Add magic twoslash comment for type introspection",
    })

    remember_buffer_map(bufnr, { "n" }, "<leader>dQ", "<cmd>TwoslashQueriesRemove<CR>", {
      desc = "Remove all Twoslash queries from buffer",
    })
  end,
})

vim.api.nvim_create_autocmd("LspDetach", {
  group = group,
  callback = function(event)
    local bufnr = event.buf
    vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })

    twoslash.disable()
  end,
})

return {}
