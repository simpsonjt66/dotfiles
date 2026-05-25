hl.workspace_rule({
	workspace = "special:scratchpad",
	on_created_empty = "[float; size 600 600] kitty -e nvim -c 'cd %:p:h' ~/Code/dotfiles/docs/scratch.md",
})
