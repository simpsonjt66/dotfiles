-- https://wiki.hypr.land/Configuring/Variables/#input
hl.config({
	input = {
		kb_layout = "us",
		kb_options = "caps:escape",

		follow_mouse = 1,

		sensitivity = 0,

		touchpad = {
			natural_scroll = false,
		},
	},
})

-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices,
hl.device({
	name = "synps/2-synaptics-touchpad",
	scroll_method = "edge",
})
