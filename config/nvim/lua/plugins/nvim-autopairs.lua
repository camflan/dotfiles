return {
  {
    "windwp/nvim-autopairs",
    lazy = true,
    event = { "InsertEnter" },
    opts = {
      check_ts = true,
    },
  },
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      opts = {
        enable_close = true,
        enabled_rename = true,
        enable_close_on_slash = true,
      },
    },
  },
}
