hl.bind("ALT + S", hl.dsp.workspace.toggle_special("scratchpad"), { description = "Toggle scratchpad" })

-- Apps
hl.bind("SUPER + return", hl.dsp.exec_cmd([[uwsm-app -- xdg-terminal-exec]]))
hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd("launch-browser"))

-- Actions
hl.bind("SUPER + W", hl.dsp.window.close())

hl.bind("PRINT", hl.dsp.exec_cmd("cmd-screenshot"), { description = "Screenshot of region" })
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("cmd-screenshot window"), { description = "Screenshot of window" })
hl.bind("CTRL + PRINT", hl.dsp.exec_cmd("cmd-screenshot output"), { description = "Screenshot of display" })

-- Webapps
-- hl.bind(SUPER, E, Email, exec, launch-webapp "https://mail.google.com"
-- hl.bind(SUPER, A, ChatGPT, exec, launch-webapp "https://claude.ai"

-- Containers
hl.bind("SUPER + left", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + up", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + down", hl.dsp.focus({ direction = "down" }))

hl.bind("SUPER + SHIFT + LEFT", hl.dsp.window.swap({ direction = "l" }), { description = "Swap window to the left" })
hl.bind("SUPER + SHIFT + RIGHT", hl.dsp.window.swap({ direction = "r" }), { description = "Swap window to the right" })
hl.bind("SUPER + SHIFT + UP", hl.dsp.window.swap({ direction = "u" }), { description = "Swap window up" })
hl.bind("SUPER + SHIFT + DOWN", hl.dsp.window.swap({ direction = "d" }), { description = "Swap window down" })

-- workspaces
for workspace = 1, 10 do
	local key = "code:" .. tostring(workspace + 9)
	hl.bind(
		"SUPER + " .. key,
		hl.dsp.focus({ workspace = tostring(workspace) }),
		{ description = "Switch to workspace " .. workspace }
	)
	hl.bind(
		"SUPER + SHIFT + " .. key,
		hl.dsp.window.move({ workspace = tostring(workspace) }),
		{ description = "Move window to workspace " .. workspace }
	)
	hl.bind(
		"SUPER + SHIFT + ALT + " .. key,
		hl.dsp.window.move({ workspace = tostring(workspace), follow = false }),
		{ description = "Move window silently to workspace " .. workspace }
	)
end

-- Floating
-- Layout
hl.bind("SUPER + J", hl.dsp.layout("togglesplit"), { description = "Toggle window split" })
hl.bind("SUPER + P", hl.dsp.window.pseudo(), { description = "Pseudo window" })
hl.bind("SUPER + T", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle window floating/tiling" })
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }), { description = "Full screen" })
hl.bind(
	"SUPER + CTRL + F",
	hl.dsp.window.fullscreen_state({ internal = 0, client = 2 }),
	{ description = "Tiled full screen" }
)
hl.bind("SUPER + ALT + F", hl.dsp.window.fullscreen({ mode = "maximized" }), { description = "Full width" })
--

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Move window" })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window" }) -- hl.bind(m = $mainMod, mouse:272, movewindow

-- Rofi
-- hl.bind( = $mainMod, K, Show key bindings, exec, rofi-menu-keybindings
hl.bind("Menu", hl.dsp.exec_cmd("hyperion-menu"), { description = "System menu" })
hl.bind("SUPER + space", hl.dsp.exec_cmd("hyperion-menu apps"), { description = "Apps menu" })
hl.bind("XF86PowerOff", hl.dsp.exec_cmd("hyperion-menu system"), { description = "Power menu" })
hl.bind("SUPER + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu -display-comlumns 2 | cliphist decode | wl-copy"))

-- Session
hl.bind("SUPER + SHIFT + M", hl.dsp.exec_cmd("uwsm stop"))

-- Brightness control
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightness up"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightness down"))

-- Volume Control
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("volume up"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("volume down"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("volume mute"))
