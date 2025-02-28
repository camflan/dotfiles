return {
  {
    "tehdb/nvim-faker",
    cmd = { "Faker" },
    config = function()
      require("nvim-faker").setup({
        use_global_package = false,
      })
    end,
  },
}
