hl.on("workspace.created", function(ws)
	if ws.name == "special:scratchpad" and ws.is_empty then
		hl.dispatch(
			hl.dsp.exec_cmd("kitty -e nvim -c 'cd %:p:h' ~/Code/dotfiles/docs/scratch.md", {
				float = true,
				size = "600 600",
			})
		)
	end
end)
