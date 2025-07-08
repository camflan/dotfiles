-- ┌──────────────────────────────┐
-- │******************************│██
-- │******************************│██     _  _  ____  ____  ____  ____  ____  _  _
-- │*******██████*███████████*****│██    / )( \(  __)(__  )(_  _)(  __)(  _ \( \/ )
-- │*****███*****██******██*******│██    \ /\ / ) _)  / _/   )(   ) _)  )   // \/ \
-- │****██********██*█***██*******│██    (_/\_)(____)(____) (__) (____)(__\_)\_)(_/
-- │****██***********██████*******│██      ___  __   __ _  ____  __  ___
-- │****██***********█***██*******│██     / __)/  \ (  ( \(  __)(  )/ __)
-- │****██********██*█***██*******│██    ( (__(  O )/    / ) _)  )(( (_ \
-- │*****███*****██******██*******│██     \___)\__/ \_)__)(__)  (__)\___/
-- │*******███████****███████*****│██
-- │******************************│██     Official docs:
-- │******************************│██     https://wezfurlong.org/wezterm/config/lua/general.html
-- └──────────────────────────────┘██
--   ████████████████████████████████
--
--
local wezterm = require("wezterm")
local config = wezterm.config_builder()
-- integration with neovim
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")

local colorscheme = require("constants.colorscheme")
local fonts = require("constants.fonts")
local utils = require("utils")

-- Set to "Light", "Dark", or "System"
---@type "Dark" | "Light" | "System"
local apperance_mode = "Dark"

-- appearance
config.color_scheme = utils.scheme_for_appearance(colorscheme.light_mode, colorscheme.dark_mode, apperance_mode)

-- fonts
config.font = fonts.font
local font_metrics = fonts.font_metrics

config.font_size = font_metrics.font_size
config.line_height = font_metrics.line_height

config.animation_fps = 60
config.default_cursor_style = "BlinkingUnderline"
config.cursor_blink_rate = 1500
config.cursor_blink_ease_in = "Linear"
config.cursor_blink_ease_out = "EaseOut"

config.initial_cols = 120
config.initial_rows = 50

config.inactive_pane_hsb = { brightness = 1, saturation = 1 }
config.window_background_opacity = 1
-- config.macos_window_background_blur = 30
-- Removes the title bar, leaving only the tab bar. Keeps
-- the ability to resize by dragging the window's edges.
-- On macOS, 'RESIZE|INTEGRATED_BUTTONS' also looks nice if
-- you want to keep the window controls visible and integrate
-- them into the tab bar.
-- config.window_decorations = "RESIZE|INTEGRATED_BUTTONS"
-- Sets the font for the window frame (tab bar)

config.window_frame = {
	font = config.font,
	font_size = 12,
}

config.default_workspace = "default"

config.ssh_domains = {
	{
		multiplexing = "WezTerm",
		name = "studio",
		remote_address = "studio",
		username = "camron",
	},
}

local function segments_for_right_status(window)
	local segments = {
		-- wezterm.strftime("%a %b %-d %H:%M"),
		wezterm.hostname(),
	}

	local current_workspace = window:active_workspace()
	-- don't show a segment for the default workspace
	if current_workspace ~= config.default_workspace then
		table.insert(segments, 1, current_workspace)
	end

	return segments
end

wezterm.on("update-status", function(window, _)
	local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
	local segments = segments_for_right_status(window)

	local color_scheme = window:effective_config().resolved_palette
	-- Note the use of wezterm.color.parse here, this returns
	-- a Color object, which comes with functionality for lightening
	-- or darkening the colour (amongst other things).
	local bg = wezterm.color.parse(color_scheme.background)
	local fg = color_scheme.foreground

	-- We'll build up the elements to send to wezterm.format in this table.
	local elements = {}

	for i, seg in ipairs(segments) do
		local segment_bg = bg
		local segment_fg = fg

		if i % 2 == 0 then
			segment_bg = fg
			segment_fg = bg
		end

		local is_first = i == 1

		if is_first then
			table.insert(elements, { Background = { Color = "none" } })
		end

		table.insert(elements, { Foreground = { Color = segment_bg } })
		table.insert(elements, { Text = SOLID_LEFT_ARROW })

		table.insert(elements, { Foreground = { Color = segment_fg } })
		table.insert(elements, { Background = { Color = segment_bg } })
		table.insert(elements, { Text = " " .. seg .. " " })
	end

	window:set_right_status(wezterm.format(elements))
end)

-- fixes left-alt (option) key for typing characters. eg, ALT-; for …
-- https://github.com/wez/wezterm/issues/3866#issuecomment-1609587925
config.send_composed_key_when_left_alt_is_pressed = true

config.set_environment_variables = {
	PATH = "/opt/homebrew/bin:" .. os.getenv("PATH"),
}

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

	-- Open configuration
	{
		key = ",",
		mods = "CMD",
		action = wezterm.action.SpawnCommandInNewTab({
			cwd = wezterm.config_dir,
			args = { "nvim", wezterm.config_file },
		}),
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

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
local function tab_title(tab_info)
	print(tab_info.tab_index)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.tab_index + " " + tab_info.active_pane.title
end

config.use_fancy_tab_bar = true

-- wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
-- 	local edge_background = "#0b0022"
-- 	local background = "#1b1032"
-- 	local foreground = "#808080"
--
-- 	if tab.is_active then
-- 		background = "#2b2042"
-- 		foreground = "#c0c0c0"
-- 	elseif hover then
-- 		background = "#3b3052"
-- 		foreground = "#909090"
-- 	end
--
-- 	local edge_foreground = background
--
-- 	local title = tab_title(tab)
--
-- 	-- ensure that the titles fit in the available space,
-- 	-- and that we have room for the edges.
-- 	-- title = wezterm.truncate_right(title, max_width - 2)
--
-- 	return {
-- 		{ Background = { Color = edge_background } },
-- 		{ Foreground = { Color = edge_foreground } },
-- 		{ Text = SOLID_LEFT_ARROW },
-- 		{ Background = { Color = background } },
-- 		{ Foreground = { Color = foreground } },
-- 		{ Text = title },
-- 		{ Background = { Color = edge_background } },
-- 		{ Foreground = { Color = edge_foreground } },
-- 		{ Text = SOLID_RIGHT_ARROW },
-- 	}
-- end)
-- END OF STYLE TABS

return config
