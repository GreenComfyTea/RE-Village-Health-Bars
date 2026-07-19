local this = {};

local modules = require("Health_Bars.modules");

local outline_styles = {};
local displayed_outline_styles = {};

local fill_directions = {};
local displayed_fill_directions = {};

function this.init()
	local cached_default_language = modules.language.default_language.customization_menu;
	local cached_current_language = modules.language.current_language.customization_menu;

	outline_styles = {
		cached_default_language.inside,
		cached_default_language.center,
		cached_default_language.outside
	};

	displayed_outline_styles = {
		cached_current_language.inside,
		cached_current_language.center,
		cached_current_language.outside
	};

	fill_directions = {
		cached_default_language.left_to_right,
		cached_default_language.right_to_left,
		cached_default_language.top_to_bottom,
		cached_default_language.bottom_to_top
	};

	displayed_fill_directions = {
		cached_current_language.left_to_right,
		cached_current_language.right_to_left,
		cached_current_language.top_to_bottom,
		cached_current_language.bottom_to_top
	};
end

function this.draw(id, bar_name, bar)
	local cached_language = modules.language.current_language.customization_menu;

	local bar_changed = false;
	local changed = false;
    local index = 1;


	if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(bar_name, id)) then
		changed, bar.visible = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.visible, id, "visible"), bar.visible);
        bar_changed = bar_changed or changed;

        if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.settings, id, "settings")) then
            local fill_direction_index = modules.utils.table.find_index(fill_directions, bar.settings.fill_direction);
            changed, fill_direction_index = modules.reframework_globals.imgui.combo(modules.utils.imgui.label(cached_language.fill_direction, id, "settings.fill_direction"), fill_direction_index, displayed_fill_directions);
            bar_changed = bar_changed or changed;

            if changed then
                bar.settings.fill_direction = fill_directions[fill_direction_index];
            end

            changed, bar.settings.inverted = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.inverted, id, "settings.inverted"), bar.settings.inverted);
            bar_changed = bar_changed or changed;

            modules.reframework_globals.imgui.tree_pop();
        end
		
		changed = modules.offset_customization.draw(id, bar.offset);
		bar_changed = bar_changed or changed;

		if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.size, id, "size")) then
			changed, bar.size.width = modules.reframework_globals.imgui.drag_float(modules.utils.imgui.label(cached_language.width, id, "size.width"),
				bar.size.width, 0.1, 0, modules.screen.width, "%.1f");
			bar_changed = bar_changed or changed;

			changed, bar.size.height = modules.reframework_globals.imgui.drag_float(modules.utils.imgui.label(cached_language.height, id, "size.height"),
				bar.size.height, 0.1, 0, modules.screen.height, "%.1f");
			bar_changed = bar_changed or changed;

			modules.reframework_globals.imgui.tree_pop();
		end

		if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.outline, id, "outline")) then
			changed, bar.outline.visible = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.visible, id, "outline.visible")
				, bar.outline.visible);
			bar_changed = bar_changed or changed;

			changed, bar.outline.thickness = modules.reframework_globals.imgui.drag_float(modules.utils.imgui.label(cached_language.thickness, id, "outline.thickness"),
				bar.outline.thickness, 0.1, 0, modules.screen.width, "%.1f");
			bar_changed = bar_changed or changed;

			changed, bar.outline.offset = modules.reframework_globals.imgui.drag_float(modules.utils.imgui.label(cached_language.offset, id, "outline.offset"),
				bar.outline.offset, 0.1, -modules.screen.height, modules.screen.height, "%.1f");
			bar_changed = bar_changed or changed;

			changed, index = modules.reframework_globals.imgui.combo(modules.utils.imgui.label(cached_language.style, id, "outline.style"),
				modules.utils.table.find_index(outline_styles, bar.outline.style),
				displayed_outline_styles);
			bar_changed = bar_changed or changed;

			if changed then
				bar.outline.style = outline_styles[index];
			end

			modules.reframework_globals.imgui.tree_pop();
		end

        if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.colors, id, "colors")) then
            changed, bar.colors.foreground = modules.color_customization.draw(id .. ".colors.foreground", cached_language.foreground, bar.colors.foreground);
            bar_changed = bar_changed or changed;

            changed, bar.colors.background = modules.color_customization.draw(id .. ".colors.background", cached_language.background, bar.colors.background);
            bar_changed = bar_changed or changed;

            changed, bar.colors.outline = modules.color_customization.draw(id .. ".colors.outline", cached_language.outline, bar.colors.outline);
            bar_changed = bar_changed or changed;

            modules.reframework_globals.imgui.tree_pop();
        end
	

		bar_changed = bar_changed or changed;

		modules.reframework_globals.imgui.tree_pop();
	end

	return bar_changed;
end

function this.init_module()
end

return this;
