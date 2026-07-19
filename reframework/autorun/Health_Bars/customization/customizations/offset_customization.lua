local this = {};

local modules = require("Health_Bars.modules");

function this.draw(id, offset)
	local cached_language = modules.language.current_language.customization_menu;

	local offset_changed = false;
	local changed = false;

	if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.offset, id, "offset")) then
		changed, offset.x = modules.reframework_globals.imgui.drag_float(modules.utils.imgui.label(cached_language.x, id, "offset.x"),
			offset.x, 0.1, -modules.screen.width, modules.screen.width, "%.1f");
		offset_changed = offset_changed or changed;

        changed, offset.y = modules.reframework_globals.imgui.drag_float(modules.utils.imgui.label(cached_language.y, id, "offset.y"),
			offset.y, 0.1, -modules.screen.height, modules.screen.height, "%.1f");
		offset_changed = offset_changed or changed;

		modules.reframework_globals.imgui.tree_pop();
	end

	return offset_changed;
end

function this.init_module()
end

return this;