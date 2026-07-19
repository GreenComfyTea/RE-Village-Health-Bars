local this = {};

local modules = require("Health_Bars.modules");

function this.draw(id, spacing)
	local cached_language = modules.language.current_language.customization_menu;

	local spacing_changed = false;
	local changed = false;

	if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.spacing, id, "spacing")) then
		changed, spacing.x = modules.reframework_globals.imgui.drag_float(modules.utils.imgui.label(cached_language.x, id, "spacing.x"),
			spacing.x, 0.1, -modules.screen.width, modules.screen.width, "%.1f");
		spacing_changed = spacing_changed or changed;

        changed, spacing.y = modules.reframework_globals.imgui.drag_float(modules.utils.imgui.label(cached_language.y, id, "spacing.y"),
			spacing.y, 0.1, -modules.screen.height, modules.screen.height, "%.1f");
		spacing_changed = spacing_changed or changed;

		modules.reframework_globals.imgui.tree_pop();
	end

	return spacing_changed;
end

function this.init_module()
end

return this;