local table_utils = require("lib.table")
local utils = require("lib.utils")

---@enum (key) Formatter
local formatters = {
  black = true,
  gofmt = false,
  injected = true,
  isort = true,
  markdownlint = true,
  pg_format = false,
  prettier = true,
  ruff_fix = true,
  ruff_format = true,
  rustfmt = false,
  stylua = true,
  terraform_fmt = true,
  trim_whitespace = true,
  yamlfix = true,
}

---@type table<string, Formatter[] | table<Formatter, any>>
local formatters_by_ft = {
  -- go = { "gofmt" },
  graphql = { "prettier" },
  javascript = { "prettier", "injected" },
  javascriptreact = { "prettier", "injected" },
  json = { "prettier" },
  lua = { "stylua" },
  html = { "prettier" },
  markdown = { "markdownlint", "injected" },
  python = { "isort", "black", "ruff_format", "ruff_fix", "injected" },
  -- rust = { "rustfmt" },
  -- sql = { "pg_format" },
  terraform = { "terraform_fmt" },
  typescript = { "prettier" },
  typescriptreact = { "prettier" },
  yaml = { "yamlfix", "injected" },

  -- all files
  -- ["*"] = { "trim_whitespace" },
  -- files without any formatters available
  ["_"] = { "trim_whitespace" },
}

-- Runs the first available of the table
---@param bufnr integer
---@param ... Formatter
---@return Formatter
local function first(bufnr, ...)
  local conform = require("conform")
  for i = 1, select("#", ...) do
    local formatter = select(i, ...)
    if conform.get_formatter_info(formatter, bufnr).available then
      return formatter
    end
  end
  return select(1, ...)
end

return {
  {
    "stevearc/conform.nvim",
    cmd = { "ConformInfo", "ConformEnable", "ConformDisable" },
    event = { "BufWritePre" },
    keys = {
      {
        -- Customize or remove this keymap to your liking
        "<leader>P",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "n",
        desc = "Format buffer",
      },
    },
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    config = function()
      local conform = require("conform")

      -- Track slow formatting filetypes so we can run async
      local slow_format_filetypes = {}

      conform.setup(
        ---@module "conform"
        ---@type conform.setupOpts
        {
          default_format_opts = {
            lsp_format = "fallback",
          },
          formatters_by_ft = table_utils.assign(formatters_by_ft, {
            ---@param bufnr number
            ---@return Formatter[]
            python = function(bufnr)
              if require("conform").get_formatter_info("ruff_format", bufnr).available then
                return { "ruff_fix", "ruff_format", "injected" }
              end

              return { "isort", "black", "injected" }
            end,
          }),
          formatters = {
            black = {
              -- trying this: https://github.com/stevearc/conform.nvim/issues/390
              command = utils.get_venv_command("black"),
            },
            codespell = {
              condition = function(_, ctx)
                -- NOTE: Do NOT let codespell run on lock files!
                if vim.fs.basename(ctx.filename) == "package-lock.json" then
                  return false
                end

                if vim.fs.basename(ctx.filename) == "package.json" then
                  return false
                end

                -- NOTE: Do not run on Prisma files because it can change some Index types (BRIN => BRING)
                if vim.fs.basename(ctx.filename) == "schema.prisma" then
                  return false
                end

                return true
              end,
            },
            isort = {
              command = utils.get_venv_command("isort"),
            },
            -- https://lyz-code.github.io/yamlfix/#configuration-options
            yamlfix = {
              env = {
                YAMLFIX_SEQUENCE_STYLE = "keep_style",
                YAMLFIX_SECTION_WHITELINES = "1",
                YAMLFIX_WHITELINES = "1",
              },
            },
          },
          -- Set up format-on-save
          format_on_save = function(bufnr)
            -- Disable with a global or buffer-local variable
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end

            if slow_format_filetypes[vim.bo[bufnr].filetype] then
              return
            end

            local function on_format(err)
              if err and err:match("timeout$") then
                slow_format_filetypes[vim.bo[bufnr].filetype] = true
              end
            end

            return { timeout_ms = 200, lsp_format = "fallback" }, on_format
          end,

          format_after_save = function(bufnr)
            if not slow_format_filetypes[vim.bo[bufnr].filetype] then
              return
            end
            return { lsp_format = "fallback" }
          end,
        }
      )

      vim.api.nvim_create_user_command("ConformDisable", function(args)
        if args.bang then
          -- ConformDisable! will disable formatting just for this buffer
          ---@diagnostic disable-next-line: inject-field
          vim.b.disable_autoformat = true
        else
          vim.g.disable_autoformat = true
        end
      end, {
        desc = "Disable autoformat-on-save",
        bang = true,
      })
      vim.api.nvim_create_user_command("ConformEnable", function()
        ---@diagnostic disable-next-line: inject-field
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, {
        desc = "Re-enable autoformat-on-save",
      })
    end,
  },
}
