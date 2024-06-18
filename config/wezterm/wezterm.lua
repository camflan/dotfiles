-- https://wezfurlong.org/wezterm/config/lua/general.html
local wezterm = require("wezterm")
local config = wezterm.config_builder()
-- integration with neovim
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")

local utils = require("utils")

-- appearance
config.color_scheme = utils.scheme_for_appearance("Solarized Light (Gogh)", "Dracula (Official)")
config.font = wezterm.font("IBM Plex Mono")
config.font_size = 13
config.inactive_pane_hsb = { brightness = 0.75, saturation = 0.75 }

-- keybindings
config.keys = {
	{
		key = "d",
		mods = "CMD",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},

	{
		key = "d",
		mods = "CMD|SHIFT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},

	{
		key = "Enter",
		mods = "CMD|SHIFT",
		action = wezterm.action.TogglePaneZoomState,
	},
}

-- https://github.com/mrjones2014/smart-splits.nvim?tab=readme-ov-file
smart_splits.apply_to_config(config, {
	-- the default config is here, if you'd like to use the default keys,
	-- you can omit this configuration table parameter and just use
	-- smart_splits.apply_to_config(config)

	-- directional keys to use in order of: left, down, up, right
	direction_keys = { "h", "j", "k", "l" },
	-- modifier keys to combine with direction_keys
	modifiers = {
		move = "CTRL", -- modifier to use for pane movement, e.g. CTRL+h to move left
		resize = "META", -- modifier to use for pane resize, e.g. META+h to resize to the left
	},
})

return config
