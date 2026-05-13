hl.workspace_rule({
	workspace = "special:scratchpad",
	on_created_empty = "[float; size 600 600] kitty -e nvim -c 'cd %:p:h' /home/jsimpson/Documents/Projects/hyperion/scratch.md",
})
