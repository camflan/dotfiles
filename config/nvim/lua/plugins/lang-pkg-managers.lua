return {
  {
    "jdrupal-dev/parcel.nvim",
    dependencies = {
      "phelipetls/jsonpath.nvim",
    },
    enabled = false,
    ft = { "json" },
    opts = {},
  },

  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    enabled = true,
    opts = {
      autostart = true,
      hide_up_to_date = true,
      hide_unstable_versions = true,
    },
  },
}
