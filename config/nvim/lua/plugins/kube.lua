return {
  {
    "ramilito/kubectl.nvim",
    config = function()
      require("kubectl").setup()

      vim.keymap.set("n", "<leader>oK", '<cmd>lua require("kubectl").toggle()<cr>', { noremap = true, silent = true })
    end,
  },
}
