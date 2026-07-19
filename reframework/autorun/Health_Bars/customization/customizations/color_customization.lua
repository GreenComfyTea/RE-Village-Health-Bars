local this = {};

local modules = require("Health_Bars.modules");

function this.draw(id, color_label, color)
	local color_changed = false;
    local changed = false;

	if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(color_label, id)) then
		changed, color = modules.reframework_globals.imgui.color_picker_argb(modules.utils.imgui.label("", id, "color"),  color, modules.customization_menu.color_picker_flags);
		color_changed = color_changed or changed;

		modules.reframework_globals.imgui.tree_pop();
	end

	return color_changed, color;
end

function this.init_module()
end

return this;