local this = {};

local modules = require("Health_Bars.modules");

local include_names = {};

this.alignments = {};
local displayed_alignments = {};

function this.init()
    local cached_default_language = modules.language.default_language.customization_menu;
	local cached_current_language = modules.language.current_language.customization_menu;

	this.alignments = {
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

	displayed_alignments = {
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

	include_names = {
		["current_value"] = cached_current_language.current_value,
		["max_value"] = cached_current_language.max_value
	};
end

function this.draw(id, label_name, label)
	local cached_language = modules.language.current_language.customization_menu;

	local label_changed = false;
	local changed = false;

	if modules.reframework_globals.imgui.tree_node(label_name) then
		changed, label.visible = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.visible, id, "visible"), label.visible);
		label_changed = label_changed or changed;

		if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.settings, id, "settings")) then
			local alignment_index = modules.utils.table.find_index(this.alignments, label.settings.alignment);
			changed, alignment_index = modules.reframework_globals.imgui.combo(modules.utils.imgui.label(cached_language.alignment, id, "settings.alignment"), alignment_index, displayed_alignments);
			label_changed = label_changed or changed;

			if changed then
				label.settings.alignment = this.alignments[alignment_index];
			end

			modules.reframework_globals.imgui.tree_pop();
		end


		if label.include ~= nil then
			if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.include, id, "include")) then
				for include_name, include in pairs(label.include) do
					changed, label.include[include_name] = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(include_names[include_name], id, include_names[include_name]), include);
					label_changed = label_changed or changed;
				end

				modules.reframework_globals.imgui.tree_pop();
			end
		end
		

		changed = modules.offset_customization.draw(id, label.offset);
        label_changed = label_changed or changed;
		
		changed, label.color = modules.color_customization.draw(id .. ".color", cached_language.color, label.color);
		label_changed = label_changed or changed;

		if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.shadow, id, "shadow")) then
			changed, label.shadow.visible = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.visible, id, "shadow.visible"), label.shadow.visible);
			label_changed = label_changed or changed;

			changed = modules.offset_customization.draw(id .. ".shadow", label.shadow.offset);
            label_changed = label_changed or changed;
			
			changed, label.shadow.color = modules.color_customization.draw(id .. ".shadow.color", cached_language.color, label.shadow.color);
            label_changed = label_changed or changed;

			modules.reframework_globals.imgui.tree_pop();
		end

		modules.reframework_globals.imgui.tree_pop();
	end

	return label_changed;
end

function this.init_module()
end

return this;