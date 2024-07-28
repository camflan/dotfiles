return {
  {
    "folke/todo-comments.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/trouble.nvim",
    },
    event = { "BufReadPre", "BufNewFile" },
    cmd = {
      "TodoLocList",
      "TodoQuickFix",
      "TodoTrouble",
    },
    config = true,
  },
}
