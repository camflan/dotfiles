return {
  {
    "mfussenegger/nvim-dap",
    lazy = true,
  },

  {
    "leoluz/nvim-dap-go",
    lazy = true,
    config = function()
      local dap_go = require("dap-go")
      dap_go.setup({
        dap_configurations = {
          {
            type = "go",
            name = "Attach remote",
            mode = "remote",
            request = "attach",
            port = 38697,
          },
        },
      })
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    -- only enable for languages we have set up debug adapters for
    ft = { "go" },
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio", "leoluz/nvim-dap-go" },
    opts = {},
    config = function(_, opts)
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup(opts)

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
  },
}
