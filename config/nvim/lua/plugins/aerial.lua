return {
  {
    "stevearc/aerial.nvim",
    opts = {
      layout = {
        width = 80,
      },
    },
    keys = {
      { "<leader>cs", "<cmd>AerialToggle<cr>", desc = "Toggle Outline (Aerial)" },
    },
    -- Optional dependencies
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },
}
