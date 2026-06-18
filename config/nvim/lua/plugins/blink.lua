return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "enter",
        ["<CR>"] = {}, -- Disables enter from confirming completion
        ["<C-y>"] = { "select_and_accept", "fallback" },
      },
    },
  },
}
