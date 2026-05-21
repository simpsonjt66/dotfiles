return {
  "ibhagwan/fzf-lua",
  opts = function(_, opts)
    -- Extend existing options
    opts.previewers = opts.previewers or {}

    -- Configure the builtin image previewer
    opts.previewers.builtin = {
      extensions = {
        -- Define which file types trigger the image previewer
        ["png"] = { "chafa" },
        ["jpg"] = { "chafa" },
        ["jpeg"] = { "chafa" },
        ["gif"] = { "chafa" },
        ["webp"] = { "chafa" },
      },
    }
  end,
}
