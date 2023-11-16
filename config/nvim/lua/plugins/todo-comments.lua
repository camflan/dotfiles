return {
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPre", "BufNewFile" },
    cmd = {
        "TodoLocList",
        "TodoQuickFix",
        "TodoTrouble",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = true,
  },
}
