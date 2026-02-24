return {
  {
    "keaising/im-select.nvim",
    event = "InsertEnter",
    config = function()
      require("im_select").setup({
        default_command = "im-select",
        default_im_select = "com.apple.keylayout.ABC",
        keep_quiet_on_no_binary = true,
      })
    end,
  },
}
