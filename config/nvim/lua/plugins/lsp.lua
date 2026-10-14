return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        qmlls = {
          -- Override the command to point to the Arch-specific executable name
          cmd = { "qmlls6" },
        },
      },
    },
  },
}
