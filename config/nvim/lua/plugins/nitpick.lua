return {
  {
    "iai6203/nitpick",
    name = "nitpick.nvim",
    version = "*",
    cmd = "Nitpick",
    keys = {
      { "<leader>rc", ":Nitpick comment<CR>", mode = "x", desc = "Nitpick comment" },
      { "<leader>rd", ":Nitpick delete<CR>", mode = "x", desc = "Nitpick delete" },
      { "<leader>rl", ":Nitpick label<CR>", mode = "x", desc = "Nitpick label" },
      { "<leader>rc", "<Cmd>Nitpick comment<CR>", desc = "Nitpick comment line" },
      { "<leader>rl", "<Cmd>Nitpick label<CR>", desc = "Nitpick label line" },
      { "<leader>rg", "<Cmd>Nitpick global<CR>", desc = "Nitpick global comment" },
      { "<leader>re", "<Cmd>Nitpick edit<CR>", desc = "Nitpick edit" },
      { "<leader>rx", "<Cmd>Nitpick remove<CR>", desc = "Nitpick remove" },
      { "<leader>ry", "<Cmd>Nitpick copy<CR>", desc = "Nitpick copy" },
      { "<leader>rp", "<Cmd>Nitpick paste<CR>", desc = "Nitpick paste" },
    },
    opts = {
      -- 라벨 목록. 아래는 기본값이라 labels를 생략해도 그대로 포함됩니다.
      labels = {
        { emoji = "❓", text = "Clarify this" },
        {
          emoji = "🗺️",
          text = "Missing overview",
          tip = "Provide a narrative overview of what is being built, why it is being built, and how it will be built. Add this before the implementation details.",
        },
        {
          emoji = "🔍",
          text = "Verify this",
          tip = "This seems like an assumption. Verify by reading the actual code before proceeding.",
        },
        {
          emoji = "🔬",
          text = "Give me an example",
          tip = "This is too abstract. Show a before/after, a sample input/output, or a specific scenario so I can see how this actually works.",
        },
        {
          emoji = "🧬",
          text = "Match existing patterns",
          tip = "Search the codebase for existing patterns, components, or utilities that already solve this. Reuse what exists rather than introducing a new approach.",
        },
        {
          emoji = "🔄",
          text = "Consider alternatives",
          tip = "Propose 2-3 alternative approaches with trade-offs based on the actual codebase. Also check the Plannotator plans directory (PLANNOTATOR_DATA_DIR or ~/.plannotator/plans/) for prior plan versions that may have already explored or rejected similar approaches.",
        },
        {
          emoji = "📉",
          text = "Ensure no regression",
          tip = "Verify that this change will not break existing behavior. Identify what could regress and how to protect against it.",
        },
        {
          emoji = "🚫",
          text = "Out of scope",
          tip = "This is not part of the current task. Remove it and stay focused on what was actually requested.",
        },
        { emoji = "🧪", text = "Needs tests" },
        { emoji = "👍", text = "Nice approach" },
        { emoji = "👍", text = "Looks good" },
      },
    },
  },
}
