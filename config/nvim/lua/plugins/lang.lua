return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "http" },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      heading = {
        sign = true,
        position = "inline",
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      },
      code = {
        sign = true,
      },
      win_options = {
        conceallevel = { default = 0, rendered = 3 },
      },
    },
  },
}
