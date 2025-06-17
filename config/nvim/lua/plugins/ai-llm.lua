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

local function get_preferred_model()
  local preferred_ollama_model = "devstral:24b" -- "qwen3:30b"

  if get_hostname() == "mando" then
    preferred_ollama_model = "devstral"
  end

  return preferred_ollama_model
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
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionChat" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/mcphub.nvim",
      -- "stevearc/dressing.nvim", -- Optional: Improves the default Neovim UI
    },
    opts = {
      adapters = {
        ollama = function()
          return require("codecompanion.adapters").extend("ollama", {
            schema = {
              model = {
                default = get_preferred_model(),
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
                provider = "fzf_lua", -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks"
                contains_code = true,
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
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    cond = false,
    config = function()
      local minuet = require("minuet")

      minuet.setup({
        provider = "openai_compatible",
        provider_options = {
          openai_compatible = {
            model = get_preferred_model(),
            end_point = "http://127.0.0.1:11434/chat/completions",
            name = "Ollama",
          },
        },
      })
    end,
  },

  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    opts = {
      -- add any opts here
      -- for example
      provider = "ollama",
      providers = {
        ollama = {
          model = get_preferred_model(),
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
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
          selector = {
            provider = "fzf_lua",
          },
        },
      },
    },
  },
}
