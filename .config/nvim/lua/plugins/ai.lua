return {
  {
    "coder/claudecode.nvim",
    opts = {
      diff_opts = {
        auto_close_on_accept = true, -- Close diff windows after accepting
        vertical_split = true, -- Use vertical splits for diffs
        open_in_current_tab = false, -- Don't create new tabs
        keep_terminal_focus = true, -- Keep focus on Cluade terminal
      },
    },
  },
}
