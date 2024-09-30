local USE_FLASH = true

return {
  {
    "folke/flash.nvim",
    event = { "VeryLazy" },
    cond = USE_FLASH,
    keys = {
      {
        "<leader>l",
        mode = { "n", "x" },
        function()
          local Flash = require("flash")

          ---@param opts Flash.Format
          local function format(opts)
            -- always show first and second label
            return {
              { opts.match.label1, "FlashMatch" },
              { opts.match.label2, "FlashLabel" },
            }
          end

          Flash.jump({
            search = { mode = "search" },
            -- highlight = { label = { after = { 0, 0 } } },
            label = {
              after = false,
              before = { 0, 0 },
              uppercase = false,
              format = format,
            },
            pattern = "^",
            action = function(match, state)
              state:hide()
              Flash.jump({
                search = { max_length = 0 },
                highlight = { matches = false },
                label = { format = format },
                matcher = function(win)
                  -- limit matches to the current label
                  return vim.tbl_filter(function(m)
                    return m.label == match.label and m.win == win
                  end, state.results)
                end,
                labeler = function(matches)
                  for _, m in ipairs(matches) do
                    m.label = m.label2 -- use the second label
                  end
                end,
              })
            end,
            labeler = function(matches, state)
              local labels = state:labels()
              for m, match in ipairs(matches) do
                match.label1 = labels[math.floor((m - 1) / #labels) + 1]
                match.label2 = labels[(m - 1) % #labels + 1]
                match.label = match.label1
              end
            end,
          })
        end,
        desc = "Flash lines",
      },
      {
        "<leader>w",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash jump",
      },
      {
        "<leader>W",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash treesitter",
      },
      {
        "<leader>R",
        mode = { "o" },
        function()
          require("flash").remote({
            remote_op = {
              motion = true,
              restore = true,
            },
          })
        end,
        desc = "Flash remote",
      },
      {
        "<C-/>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
    opts = {
      modes = {
        char = {
          keys = {
            "f",
            "F",
            "t",
            "T",
            [","] = "\\",
            [";"] = ",",
          },
        },
        search = {
          enabled = false,
        },
      },
    },
  },
  {
    "smoka7/hop.nvim",
    cond = not USE_FLASH,
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      {
        "<leader>l",
        ":HopLineStart<CR>",
        mode = { "n" },
        desc = "Jump directly to start of line",
        remap = true,
        silent = true,
      },
      {
        "<leader>w",
        ":HopWord<CR>",
        mode = { "n" },
        desc = "Jump directly to word",
        remap = true,
        silent = true,
      },
      {
        "<leader>hW",
        ":HopWordMW<CR>",
        mode = { "n" },
        desc = "Jump directly to word across all buffers",
        remap = true,
        silent = true,
      },
      {
        "<leader>hf",
        ":HopWordCurrentLineAC<CR>",
        mode = { "n" },
        desc = "Jump directly to word on line after cursor",
        remap = true,
        silent = true,
      },
      {
        "<leader>hF",
        ":HopWordCurrentLineBC<CR>",
        mode = { "n" },
        desc = "Jump directly to word on line before cursor",
        remap = true,
        silent = true,
      },
    },
    opts = {},
  },
}
