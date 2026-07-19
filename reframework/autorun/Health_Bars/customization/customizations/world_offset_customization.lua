local this = {};

local modules = require("Health_Bars.modules");

function this.draw(id, offset)
	local cached_language = modules.language.current_language.customization_menu;

	local offset_changed = false;
	local changed = false;

	if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.world_offset, id, "world_offset")) then
		changed, offset.x = modules.reframework_globals.imgui.drag_float(modules.utils.imgui.label(cached_language.x, id, "world_offset.x"),
			offset.x, 0.001, -modules.screen.width, modules.screen.width, "%.3f");
		offset_changed = offset_changed or changed;

        changed, offset.y = modules.reframework_globals.imgui.drag_float(modules.utils.imgui.label(cached_language.y, id, "world_offset.y"),
			offset.y, 0.001, -modules.screen.width, modules.screen.width, "%.3f");
		offset_changed = offset_changed or changed;

		changed, offset.z = modules.reframework_globals.imgui.drag_float(modules.utils.imgui.label(cached_language.z, id, "world_offset.z"),
			offset.z, 0.001, -modules.screen.width, modules.screen.width, "%.3f");
		offset_changed = offset_changed or changed;

		modules.reframework_globals.imgui.tree_pop();
	end

	return offset_changed;
end

function this.init_module()
end

return this;