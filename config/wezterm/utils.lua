local wezterm = require("wezterm")

local function get_appearance_mode()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end
	return "Dark"
end

return {
	scheme_for_appearance = function(light_color_scheme, dark_color_scheme)
		local appearance = get_appearance_mode()

		if appearance:find("Dark") and dark_color_scheme then
			return dark_color_scheme
		else
			return light_color_scheme
		end
	end,
}
