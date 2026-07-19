local this = {};

local modules = require("Health_Bars.modules");

this.anchors = {};
local displayed_anchors = {};

function this.init()
	local cached_default_language = modules.language.default_language.customization_menu;
	local cached_current_language = modules.language.current_language.customization_menu;

	this.anchors = {
		cached_default_language.top_left,
		cached_default_language.top_middle,
		cached_default_language.top_right,
		cached_default_language.middle_left,
		cached_default_language.center,
		cached_default_language.middle_right,
		cached_default_language.bottom_left,
		cached_default_language.bottom_middle,
		cached_default_language.bottom_right
	};

	displayed_anchors = {
		cached_current_language.top_left,
		cached_current_language.top_middle,
		cached_current_language.top_right,
		cached_current_language.middle_left,
		cached_current_language.center,
		cached_current_language.middle_right,
		cached_current_language.bottom_left,
		cached_current_language.bottom_middle,
		cached_current_language.bottom_right
    };
end

function this.draw(id, position)
	local cached_language = modules.language.current_language.customization_menu;

	local position_changed = false;
	local changed = false;

	if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.position, "position")) then
		changed, position.x = modules.reframework_globals.imgui.drag_float(modules.utils.imgui.label(cached_language.x, id, "position.x"),
			position.x, 0.1, -modules.screen.width, modules.screen.width, "%.1f");
		position_changed = position_changed or changed;

        changed, position.y = modules.reframework_globals.imgui.drag_float(modules.utils.imgui.label(cached_language.y, id, "position.y"),
			position.y, 0.1, -modules.screen.height, modules.screen.height, "%.1f");
		position_changed = position_changed or changed;

		local anchor_index = modules.utils.table.find_index(this.anchors, position.anchor);
		changed, anchor_index = modules.reframework_globals.imgui.combo(modules.utils.imgui.label(cached_language.anchor, id, "position.anchor"), anchor_index, displayed_anchors);
		position_changed = position_changed or changed;

		if changed then
			position.anchor = this.anchors[anchor_index];
		end

		modules.reframework_globals.imgui.tree_pop();
	end

	return position_changed;
end

function this.init_module()
end

return this;