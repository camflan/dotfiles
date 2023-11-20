return {
  {
    "folke/todo-comments.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
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
