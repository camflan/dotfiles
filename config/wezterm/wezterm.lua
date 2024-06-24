-- https://wezfurlong.org/wezterm/config/lua/general.html
local wezterm = require("wezterm")
local config = wezterm.config_builder()
-- integration with neovim
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")

local utils = require("utils")

-- appearance
config.color_scheme = utils.scheme_for_appearance(
	-- Commented out until I can fix the FZF/bat highlighting in nvim properly
	-- "Solarized Light (Gogh)",
	"Dracula (Official)"
)
config.font = wezterm.font("IBM Plex Mono")
config.font_size = 13
config.inactive_pane_hsb = { brightness = 0.75, saturation = 0.95 }

config.animation_fps = 60
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_rate = 1500
config.cursor_blink_ease_in = "Linear"
config.cursor_blink_ease_out = "EaseOut"

config.initial_cols = 120
config.initial_rows = 50

-- keybindings
config.keys = {
	-- Match split keys from iTerm
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

	-- Match pane zoom from iTerm
	{
		key = "Enter",
		mods = "CMD|SHIFT",
		action = wezterm.action.TogglePaneZoomState,
	},

	-- Disable default QuickSelectMode key and rebind
	{
		key = "Space",
		mods = "CTRL|SHIFT",
		action = wezterm.action.DisableDefaultAssignment,
	},
	{
		key = "/",
		mods = "ALT",
		action = wezterm.action.QuickSelect,
	},

	-- TODO: rebind CopyMode to something easiser: https://wezfurlong.org/wezterm/copymode.html
	-- Disable default ActivateCopyMode key and rebind
	{
		key = "X",
		mods = "CTRL|SHIFT",
		action = wezterm.action.DisableDefaultAssignment,
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

-- TODO: Style tabs
-- https://wezfurlong.org/wezterm/config/lua/window-events/format-tab-title.html

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
-- local function tab_title(tab_info)
-- 	local title = tab_info.tab_title
-- 	-- if the tab title is explicitly set, take that
-- 	if title and #title > 0 then
-- 		return title
-- 	end
-- 	-- Otherwise, use the title from the active pane
-- 	-- in that tab
-- 	return tab_info.active_pane.title
-- end
--
-- wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
-- 	local title = tab_title(tab)
-- 	if tab.is_active then
-- 		return {
-- 			{ Background = { Color = "white" } },
-- 			{ Foreground = { Color = "black" } },
-- 			{ Text = " " .. title .. " " },
-- 		}
-- 	end
-- 	return title
-- end)
-- END OF STYLE TABS

return config
