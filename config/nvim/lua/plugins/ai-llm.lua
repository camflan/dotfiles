local function get_hostname()
  local f = io.popen("/bin/hostname")

  if not f then
    return
  end

  local hostname = f:read("*a") or ""
  f:close()
  hostname = string.gsub(hostname, "\n$", "")
  return hostname
end

---@enum  LlmModel
local models = {
  codegemma_code = "codegemma:7b-code",
  deepseekr1 = "deepseek-r1:14b",
  devstral = "devstral:24b",
  gemma3 = "gemma3:4b-it-q4_K_M",
  gemma3n = "gemma3n:e4b",
  gpt_oss_large = "gpt-oss:120b",
  gpt_oss_small = "gpt-oss:20b",
  llama32 = "llama3.2:latest",
  llama4scout = "llama4:scout",
  mistral = "mistral:7b",
  qwen25coder = "qwen2.5-coder:7b",
  qwen25coder_huge = "qwen2.5-coder:32b",
  qwen25coder_small = "qwen2.5-coder:1.5b",
  qwen3 = "qwen3:30b",
  qwen3coder = "qwen3-coder:latest",
  qwen3coder_30b_q3 = "hf.co/unsloth/Qwen3-Coder-30B-A3B-Instruct-GGUF:Q3_K_XL",
  qwen3coder_30b_q8 = "hf.co/unsloth/Qwen3-Coder-30B-A3B-Instruct-GGUF:Q8_K_XL",
  sqlcoder = "sqlcoder:latest",
}

---@enum (keys) LlmRequestType
local llm_request_type = {
  fill_in_the_middle = "fim",
  one_shot = "one_shot",
  chat = "chat",
}

---@param request_type LlmRequestType the type of request for which to choose a model
---@return LlmModel
local function get_preferred_model(request_type)
  if get_hostname() == "mando" then
    return models.qwen25coder_small
  end

  if request_type == "fim" then
    return models.qwen3coder
  end

  return models.qwen3coder_30b_q8
end

local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local group = vim.api.nvim_create_augroup("CodeCompanionFidgetHooks", { clear = true })
vim.api.nvim_create_autocmd({ "User" }, {
  pattern = "CodeCompanion*",
  group = group,
  callback = function(request)
    if request.match == "CodeCompanionChatSubmitted" then
      return
    end

    local msg

    msg = "[CodeCompanion] " .. request.match:gsub("CodeCompanion", "")

    vim.notify(msg, "info", {
      timeout = 1000,
      keep = function()
        return not vim
          .iter({ "Finished", "Opened", "Hidden", "Closed", "Cleared", "Created" })
          :fold(false, function(acc, cond)
            return acc or vim.endswith(request.match, cond)
          end)
      end,
      id = "code_companion_status",
      title = "Code Companion Status",
      opts = function(notif)
        notif.icon = ""
        if vim.endswith(request.match, "Started") then
          ---@diagnostic disable-next-line: undefined-field
          notif.icon = spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
        elseif vim.endswith(request.match, "Finished") then
          notif.icon = " "
        end
      end,
    })
  end,
})

return {
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    lazy = true,
    build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
    config = function()
      require("mcphub").setup()
    end,
  },

  {
    "GeorgesAlkhouri/nvim-aider",
    cmd = "Aider",
    -- Example key mappings for common actions:
    keys = {
      { "<leader>a/", "<cmd>Aider toggle<cr>", desc = "Toggle Aider" },
      { "<leader>as", "<cmd>Aider send<cr>", desc = "Send to Aider", mode = { "n", "v" } },
      { "<leader>ac", "<cmd>Aider command<cr>", desc = "Aider Commands" },
      { "<leader>ab", "<cmd>Aider buffer<cr>", desc = "Send Buffer" },
      { "<leader>a+", "<cmd>Aider add<cr>", desc = "Add File" },
      { "<leader>a-", "<cmd>Aider drop<cr>", desc = "Drop File" },
      { "<leader>ar", "<cmd>Aider add readonly<cr>", desc = "Add Read-Only" },
      { "<leader>aR", "<cmd>Aider reset<cr>", desc = "Reset Session" },
      -- Example nvim-tree.lua integration if needed
      { "<leader>a+", "<cmd>AiderTreeAddFile<cr>", desc = "Add File from Tree to Aider", ft = "NvimTree" },
      { "<leader>a-", "<cmd>AiderTreeDropFile<cr>", desc = "Drop File from Tree from Aider", ft = "NvimTree" },
    },
    dependencies = {
      "folke/snacks.nvim",
      --- The below dependencies are optional
      "catppuccin/nvim",
      "nvim-tree/nvim-tree.lua",
      --- Neo-tree integration
      {
        "nvim-neo-tree/neo-tree.nvim",
        opts = function(_, opts)
          -- Example mapping configuration (already set by default)
          -- opts.window = {
          --   mappings = {
          --     ["+"] = { "nvim_aider_add", desc = "add to aider" },
          --     ["-"] = { "nvim_aider_drop", desc = "drop from aider" }
          --     ["="] = { "nvim_aider_add_read_only", desc = "add read-only to aider" }
          --   }
          -- }
          require("nvim_aider.neo_tree").setup(opts)
        end,
      },
    },
    config = true,
  },

  -- {
  --   "mozanunal/sllm.nvim",
  --   dependencies = {
  --     "folke/snacks.nvim",
  --   },
  --   lazy = true,
  --   keys = {
  --     {
  --       "<leader>ss",
  --     },
  --   },
  --   config = function()
  --     require("sllm").setup({
  --       default_model = get_preferred_model(llm_request_type.chat),
  --       notify_func = require("snacks.notifier").notify,
  --       pick_func = require("snacks.picker").select,
  --     })
  --   end,
  -- },

  {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionChat" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/mcphub.nvim",
    },
    opts = {
      adapters = {
        ollama = function()
          return require("codecompanion.adapters").extend("ollama", {
            schema = {
              model = {
                default = get_preferred_model(llm_request_type.chat),
              },
            },
          })
        end,
      },
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            show_result_in_chat = true,
            maek_vars = true,
            make_slash_commands = true,
          },
        },
      },
      strategies = {
        agent = {
          adapter = "ollama",
        },
        chat = {
          adapter = "ollama",
          slash_commands = {
            ["file"] = {
              callback = "strategies.chat.slash_commands.file",
              description = "Select a file using FZF",
              opts = {
                contains_code = true,
                -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks"
                provider = "fzf_lua",
              },
            },
          },
        },
        inline = {
          adapter = "ollama",
        },
      },
    },
    config = function(_, opts)
      require("codecompanion").setup(opts)
    end,
  },

  {
    "David-Kunz/gen.nvim",
    cond = false,
    opts = {
      model = "zephyr", -- The default model to use.
      -- host = "localhost", -- The host running the Ollama service.
      -- port = "11434", -- The port on which the Ollama service is listening.
      display_mode = "split", -- The display mode. Can be "float" or "split".
      show_prompt = false, -- Shows the Prompt submitted to Ollama.
      show_model = true, -- Displays which model you are using at the beginning of your chat session.
      no_auto_close = false, -- Never closes the window automatically.
      init = function()
        pcall(io.popen, "ollama serve > /dev/null 2>&1 &")
      end,
      -- Function to initialize Ollama
      -- command = function(options)
      --   return "curl --silent --no-buffer -X POST http://"
      --     .. options.host
      --     .. ":"
      --     .. options.port
      --     .. "/api/generate -d $body"
      -- end,
      -- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
      -- This can also be a command string.
      -- The executed command must return a JSON object with { response, context }
      -- (context property is optional).
      -- list_models = '<omitted lua function>', -- Retrieves a list of model names
      debug = false, -- Prints errors and the command which is run.
    },
  },

  {
    "dustinblackman/oatmeal.nvim",
    cmd = { "Oatmeal" },
    keys = {
      { "<leader>oO", mode = "n", desc = "Start Oatmeal session" },
    },
    opts = {
      backend = "ollama",
      model = "codellama:latest",
    },
  },

  {
    "nomnivore/ollama.nvim",
    cond = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },

    -- All the user commands added by the plugin
    cmd = { "Ollama", "OllamaModel", "OllamaServe", "OllamaServeStop" },
    opts = {},
  },

  {
    "milanglacier/minuet-ai.nvim",
    lazy = true,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    opts = {
      provider = "openai_fim_compatible",
      n_completions = 1, -- recommend for local model for resource saving
      -- I recommend beginning with a small context window size and incrementally
      -- expanding it, depending on your local computing power. A context window
      -- of 512, serves as an good starting point to estimate your computing
      -- power. Once you have a reliable estimate of your local computing power,
      -- you should adjust the context window to a larger value.
      context_window = 1024,
      provider_options = {
        openai_fim_compatible = {
          -- For Windows users, TERM may not be present in environment variables.
          -- Consider using APPDATA instead.
          api_key = "TERM",
          name = "Ollama",
          end_point = "http://localhost:11434/v1/completions",
          model = get_preferred_model(llm_request_type.fill_in_the_middle),
          optional = {
            max_tokens = 512,
            top_p = 0.9,
          },
        },
      },
    },
  },

  {
    "yetone/avante.nvim",
    cmd = {
      "AvanteAsk",
      "AvanteBuild",
      "AvanteChat",
      "AvanteEdit",
      "AvanteHistory",
    },
    -- event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    opts = {
      -- add any opts here
      -- for example
      provider = "ollama",
      providers = {
        ollama = {
          model = get_preferred_model(llm_request_type.chat),
          stream = true,
        },
      },
      selector = {
        provider = "fzf_lua",
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      -- "echasnovski/mini.pick", -- for file_selector provider mini.pick
      -- "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      -- "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      -- "zbirenbaum/copilot.lua", -- for providers='copilot'
      -- {
      --   -- support for image pasting
      --   "HakonHarnes/img-clip.nvim",
      --   event = "VeryLazy",
      --   opts = {
      --     -- recommended settings
      --     default = {
      --       embed_image_as_base64 = false,
      --       prompt_for_file_name = false,
      --       drag_and_drop = {
      --         insert_mode = true,
      --       },
      --       -- required for Windows users
      --       use_absolute_path = true,
      --     },
      --     selector = {
      --       provider = "fzf_lua",
      --     },
      --   },
      -- },
    },
  },
}
