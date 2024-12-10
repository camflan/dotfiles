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
  local preferred_ollama_model = "deepseek-coder-v2:16b"

  if get_hostname() == "mando" then
    preferred_ollama_model = "starcoder2:3b"
  end

  return preferred_ollama_model
end

return {
  {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionActions" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- "stevearc/dressing.nvim", -- Optional: Improves the default Neovim UI
    },
    config = function()
      require("codecompanion").setup({
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
        strategies = {
          agent = {
            adapter = "ollama",
          },
          chat = {
            adapter = "ollama",
          },
          inline = {
            adapter = "ollama",
          },
        },
      })
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
    cond = false,
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
}
