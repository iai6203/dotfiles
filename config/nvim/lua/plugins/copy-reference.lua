return {
  {
    "cajames/copy-reference.nvim",
    opts = {},
    keys = {
      { "<leader>yf", "<cmd>CopyReference file<cr>", mode = { "n", "v" }, desc = "Copy file path" },
      { "<leader>yl", "<cmd>CopyReference line<cr>", mode = { "n", "v" }, desc = "Copy file:line reference" },
    },
  },
}
