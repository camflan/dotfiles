return {
  {
    "ramilito/kubectl.nvim",
    keys = {
      { "<leader>oK", '<cmd>lua require("kubectl").toggle()<cr>', desc = "Open kubectl" },
    },
    config = function()
      require("kubectl").setup()
    end,
  },
}
