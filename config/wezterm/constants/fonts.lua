local wezterm = require("wezterm")
local table_utils = require("lib.table")

local fonts = {
	sf = { family = "SF Mono", style = "Normal", weight = "Regular" },
	plex = { family = "IBM Plex Mono", style = "Normal", weight = 450 }, -- primary font
	departure = { family = "Departure Mono", style = "Normal", weight = "Regular" }, -- pixel font
	victor = { family = "Victor Mono", style = "Normal", weight = "Medium" }, -- cursive, fancy

	proto = { family = "0xProto", style = "Normal", weight = "Regular" },
	andale = { family = "Andale Mono", style = "Normal", weight = "Regular" },
	b612 = { family = "B612 Mono", style = "Normal", weight = "Regular" },
	fira = { family = "Fira Code", style = "Normal", weight = "Regular" },
	intel = { family = "Intel One Mono", style = "Normal", weight = "Regular" },
	intone = { family = "IntoneMono Nerd Font", style = "Normal", weight = "Regular" },
	jetbrains = { family = "JetBrains Mono", style = "Normal", weight = "Regular" },
	menlo = { family = "Menlo", style = "Normal", weight = "Regular" },
	argon = { family = "Monaspace Argon", style = "Normal", weight = "Regular" },
	neon = { family = "Monaspace Neon", style = "Normal", weight = "Regular" },
	pt = { family = "PT Mono", style = "Normal", weight = "Regular" },
	recursive = { family = "Recursive Mono Static Beta 1.020", style = "Normal", weight = 433 },
	spot = { family = "Spot Mono", style = "Normal", weight = "Regular" },
	fantasque = { family = "FantasqueSansM Nerd Font Mono", style = "Normal", weight = "Regular" },
}

local font_metrics = {
	default = {
		font_size = 14,
		line_height = 1.05,
	},
	[fonts.departure] = {
		font_size = 12,
	},
	[fonts.fantasque] = {
		font_size = 15,
		line_height = 1.1,
	},
	[fonts.intel] = {
		line_height = 0.95,
	},
	[fonts.plex] = {
		font_size = 13,
	},
	[fonts.recursive] = {
		font_size = 14,
	},
	[fonts.sf] = {
		font_size = 13,
	},
	[fonts.victor] = {
		font_size = 13,
	},
}

local font = fonts.plex

return {
	font = wezterm.font_with_fallback({ font, fonts.sf }),
	font_metrics = table_utils.assign(font_metrics.default, font_metrics[font]),
}
