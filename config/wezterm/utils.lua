local wezterm = require("wezterm")

local function get_appearance_mode(mode)
	if mode == "System" and wezterm.gui then
		return wezterm.gui.get_appearance()
	end

	if not mode then
		return "Dark"
	end

	return mode
end

return {
	is_dark_mode = function()
		return get_appearance_mode():find("Dark")
	end,

	scheme_for_appearance = function(light_color_scheme, dark_color_scheme, appearance_mode)
		local appearance = get_appearance_mode(appearance_mode)

		if appearance:find("Dark") and dark_color_scheme then
			return dark_color_scheme
		else
			return light_color_scheme
		end
	end,
}
