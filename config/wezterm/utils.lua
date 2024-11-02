local wezterm = require("wezterm")

local function get_appearance_mode()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end

	return "Dark"
end

return {
	get_font_config = function(font_name)
		local metrics = {
			font_size = 14,
			line_height = 1.05,
		}

		if font_name == "Departure Mono" then
			metrics.font_size = 12
		elseif font_name == "FantasqueSansM Nerd Font Mono" then
			metrics.font_size = 15
			metrics.line_height = 1.1
		elseif font_name == "IBM Plex Mono" then
			metrics.font_size = 13
		elseif font_name == "SF Mono" then
			metrics.font_size = 12
		elseif font_name == "Victor Mono" then
			metrics.font_size = 14
		end

		return metrics
	end,

	is_dark_mode = function()
		return get_appearance_mode():find("Dark")
	end,

	scheme_for_appearance = function(light_color_scheme, dark_color_scheme)
		local appearance = get_appearance_mode()

		if appearance:find("Dark") and dark_color_scheme then
			return dark_color_scheme
		else
			return light_color_scheme
		end
	end,
}
