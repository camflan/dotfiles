return {
  {
    "AndrewRadev/switch.vim",
    lazy = true,
    event = "VeryLazy",
    init = function()
      vim.g.switch_custom_definitions = {
        { "enabled", "disabled" },
      }
    end,
  },
}
