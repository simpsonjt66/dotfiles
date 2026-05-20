-- Floating windows
hl.window_rule({
	name = "window_rule-1",
	float = true,
	center = true,
	size = "800 600",
	match = {
		tag = "floating-window",
	},
})

hl.window_rule({
	name = "window_rule-2",
	tag = "+floating-window",
	match = {
		class = "org.hyperion.impala",
	},
})

hl.window_rule({
	name = "floating-terminal",
	tag = "+floating-window",
	match = {
		class = "org.hyperion.terminal",
	},
})

hl.window_rule({
	name = "window_rule-btop",
	tag = "+floating-window",
	match = {
		class = "org.hyperion.btop",
	},
})

hl.window_rule({
	name = "window_rule-3",
	tag = "+floating-window",
	match = {
		class = "xdg-desktop-portal-gtk|sublime_text|DesktopEditors|org.gnome.Nautilus",
	},
})

hl.window_rule({
	name = "window_rule-4",
	tag = "+floating-window",
	match = {
		title = "^Open Files?",
	},
})
