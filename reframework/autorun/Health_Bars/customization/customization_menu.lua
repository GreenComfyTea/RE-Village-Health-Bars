local this = {};

local modules = require("Health_Bars.modules");

this.font = nil;
this.full_font_range = {0x1, 0xFFFF, 0};
this.is_opened = false;

this.window_flags = 0x10120;
this.color_picker_flags = 327680;
this.decimal_input_flags = 33;

this.config_changed = false;

this.fonts = {	"Arial", "Arial Black", "Bahnschrift", "Calibri", "Cambria", "Cambria Math", "Candara",
				"Comic Sans MS", "Consolas", "Constantia", "Corbel", "Courier New", "Ebrima",
				"Franklin Gothic Medium", "Gabriola", "Gadugi", "Georgia", "HoloLens MDL2 Assets", "Impact",
				"Ink Free", "Javanese Text", "Leelawadee UI", "Lucida Console", "Lucida Sans Unicode",
				"Malgun Gothic", "Marlett", "Microsoft Himalaya", "Microsoft JhengHei", "Microsoft New Tai Lue",
				"Microsoft PhagsPa", "Microsoft Sans Serif", "Microsoft Tai Le", "Microsoft YaHei",
				"Microsoft Yi Baiti", "MingLiU-ExtB", "Mongolian Baiti", "MS Gothic", "MV Boli", "Myanmar Text",
				"Nirmala UI", "Palatino Linotype", "Segoe MDL2 Assets", "Segoe Print", "Segoe Script", "Segoe UI",
				"Segoe UI Historic", "Segoe UI Emoji", "Segoe UI Symbol", "SimSun", "Sitka", "Sylfaen", "Symbol",
				"Tahoma", "Times New Roman", "Trebuchet MS", "Verdana", "Webdings", "Wingdings", "Yu Gothic"
};

function this.reload_font(pop_push)
	local cached_config = modules.config.current_config;
	local cached_language = modules.language.current_language;

	local font_range = cached_language.unicode_glyph_ranges;

	if cached_language.font_name == "" then
		font_range = nil;

	elseif cached_language.unicode_glyph_ranges == nil
		or modules.utils.table.is_empty(cached_language.unicode_glyph_ranges)
		or #cached_language.unicode_glyph_ranges == 1
		or not modules.utils.number.is_odd(#cached_language.unicode_glyph_ranges)
	then

		

		font_range = this.full_font_range;
	end

    local reframework_font_size = 16;

	if cached_config.menu_font.scale_with_reframework_font_size then
		reframework_font_size = modules.reframework_globals.imgui.get_default_font_size();
	end
	
    local final_size = modules.utils.math.round(cached_config.menu_font.size_scale_modifier * reframework_font_size);
	
	this.font = modules.reframework_globals.imgui.load_font(cached_language.font_name, final_size, font_range);

	if pop_push then
		modules.reframework_globals.imgui.pop_font();
		modules.reframework_globals.imgui.push_font(this.font);
	end
end


function this.init()
	modules.bar_customization.init();
	modules.label_customization.init();
	modules.position_customization.init();
end

function this.draw()
	local cached_config = modules.config.current_config;
	local cached_language = modules.language.current_language.customization_menu;

	local window_position = modules.reframework_globals.Vector2f.new(cached_config.customization_menu.position.x, cached_config.customization_menu.position.y);
	local window_pivot = modules.reframework_globals.Vector2f.new(cached_config.customization_menu.pivot.x, cached_config.customization_menu.pivot.y);
	local window_size = modules.reframework_globals.Vector2f.new(cached_config.customization_menu.size.width, cached_config.customization_menu.size.height);

	modules.reframework_globals.imgui.set_next_window_pos(window_position, 1 << 3, window_pivot);
	modules.reframework_globals.imgui.set_next_window_size(window_size, 1 << 3);

	modules.reframework_globals.imgui.push_font(this.font);

	this.is_opened = modules.reframework_globals.imgui.begin_window(
		modules.utils.imgui.label(cached_language.mod_name .. " v" .. modules.config.current_config.version, "window"), this.is_opened, this.window_flags);

	if not this.is_opened then
		modules.reframework_globals.imgui.pop_font();
		modules.reframework_globals.imgui.end_window();
		return;
	end

	local changed = false;
	local config_changed = false;
	local enemy_filters_changed = false;
	local language_changed = false;
	local menu_font_changed = false;
	local window_changed = false;
	
	local index = 1;
	local language_index = 1;

	local new_window_position = modules.reframework_globals.imgui.get_window_pos();
	if window_position.x ~= new_window_position.x or window_position.y ~= new_window_position.y then
		window_changed = true;

		cached_config.customization_menu.position.x = new_window_position.x;
		cached_config.customization_menu.position.y = new_window_position.y;
	end

	local new_window_size = modules.reframework_globals.imgui.get_window_size();
	if window_size.x ~= new_window_size.x or window_size.y ~= new_window_size.y then
		window_changed = true;

		cached_config.customization_menu.size.width = new_window_size.x;
		cached_config.customization_menu.size.height = new_window_size.y;
	end

	if modules.reframework_globals.imgui.button(modules.utils.imgui.label(cached_language.reset_config, "reset_config")) then
		modules.config.reset();
		config_changed = true;
	end

	changed, cached_config.enabled = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.enabled, "enabled"), cached_config.enabled);
	config_changed = config_changed or changed;

    if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.language, "language")) then
        modules.reframework_globals.imgui.text(cached_language.menu_font_change_disclaimer);

        changed, language_index = modules.reframework_globals.imgui.combo(
            modules.utils.imgui.label(cached_language.language, "language.language"),
            modules.utils.table.find_index(modules.language.language_names, cached_config.language),
            modules.language.language_names);

        config_changed = config_changed or changed;
        language_changed = language_changed or changed;

        modules.reframework_globals.imgui.tree_pop();
    end
	
	if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.global_modifiers, "global_modifiers")) then
		changed, cached_config.global_modifiers.size_modifier = modules.reframework_globals.imgui.drag_float(modules.utils.imgui.label(cached_language.size_modifier, "global_modifiers.size_modifier"), cached_config.global_modifiers.size_modifier, 0.001, 0.001, 100, "%.3f");
		config_changed = config_changed or changed;

		changed, cached_config.global_modifiers.scale_size_modifier_with_resolution = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.scale_size_modifier_with_resolution, "global_modifiers.scale_size_modifier_with_resolution"),
			cached_config.global_modifiers.scale_size_modifier_with_resolution);
		config_changed = config_changed or changed;

		changed, cached_config.global_modifiers.position_modifier = modules.reframework_globals.imgui.drag_float(modules.utils.imgui.label(cached_language.position_modifier, "global_modifiers.position_modifier"), cached_config.global_modifiers.position_modifier, 0.001, 0.001, 100, "%.3f");
		config_changed = config_changed or changed;

		changed, cached_config.global_modifiers.scale_position_modifier_with_resolution = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.scale_position_modifier_with_resolution, "global_modifiers.scale_position_modifier_with_resolution"),
			cached_config.global_modifiers.scale_position_modifier_with_resolution);
		config_changed = config_changed or changed;

		modules.reframework_globals.imgui.tree_pop();
	end

	if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.menu_font, "menu_font")) then
		modules.reframework_globals.imgui.text(cached_language.menu_font_change_disclaimer);

		changed, cached_config.menu_font.size_scale_modifier = modules.reframework_globals.imgui.drag_float(modules.utils.imgui.label(cached_language.size_scale_modifier, "menu_font.size_scale_modifier"),
			cached_config.menu_font.size_scale_modifier, 0.01, 0.1, 100, "%.2f");
		config_changed = config_changed or changed;
        menu_font_changed = menu_font_changed or changed;

		changed, cached_config.menu_font.scale_with_reframework_font_size = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.scale_with_reframework_font_size, "menu_font.scale_with_reframework_font_size"), cached_config.menu_font.scale_with_reframework_font_size);
		config_changed = config_changed or changed;
		menu_font_changed = menu_font_changed or changed;

		modules.reframework_globals.imgui.tree_pop();
	end

	if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.ui_font, "ui_font")) then
		modules.reframework_globals.imgui.text(cached_language.font_notice);

		if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.dynamic_ui, "ui_font.dynamic_ui")) then
			changed, index = modules.reframework_globals.imgui.combo(modules.utils.imgui.label(cached_language.family, "ui_font.dynamic_ui.family"),
				modules.utils.table.find_index(this.fonts, cached_config.ui_font.dynamic_ui.family), this.fonts);
			config_changed = config_changed or changed;

			if changed then
				cached_config.ui_font.dynamic_ui.family = this.fonts[index];
			end

			changed, cached_config.ui_font.dynamic_ui.bold = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.bold, "ui_font.dynamic_ui.bold"),
				cached_config.ui_font.dynamic_ui.bold);
			config_changed = config_changed or changed;

			changed, cached_config.ui_font.dynamic_ui.italic = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.italic, "ui_font.dynamic_ui.italic"),
				cached_config.ui_font.dynamic_ui.italic);
			config_changed = config_changed or changed;

			changed, cached_config.ui_font.dynamic_ui.size_scale_modifier = modules.reframework_globals.imgui.drag_float(
				modules.utils.imgui.label(cached_language.size_scale_modifier, "ui_font.dynamic_ui.size_scale_modifier"), cached_config.ui_font.dynamic_ui.size_scale_modifier, 0.01, 0.1, 100, "%.2f");
			config_changed = config_changed or changed;
			
			changed, cached_config.ui_font.dynamic_ui.scale_with_reframework_font_size = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.scale_with_reframework_font_size, "ui_font.dynamic_ui.scale_with_reframework_font_size"), cached_config.ui_font.dynamic_ui.scale_with_reframework_font_size);
			config_changed = config_changed or changed;

			modules.reframework_globals.imgui.tree_pop();
		end

		if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.boss_ui, "ui_font.boss_ui")) then
			changed, index = modules.reframework_globals.imgui.combo(modules.utils.imgui.label(cached_language.family, "ui_font.boss_ui.family"),
				modules.utils.table.find_index(this.fonts, cached_config.ui_font.boss_ui.family), this.fonts);
			config_changed = config_changed or changed;

			if changed then
				cached_config.ui_font.boss_ui.family = this.fonts[index];
			end

			changed, cached_config.ui_font.boss_ui.bold = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.bold, "ui_font.boss_ui.bold"),
				cached_config.ui_font.boss_ui.bold);
			config_changed = config_changed or changed;

			changed, cached_config.ui_font.boss_ui.italic = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.italic, "ui_font.boss_ui.italic"),
				cached_config.ui_font.boss_ui.italic);
			config_changed = config_changed or changed;

			changed, cached_config.ui_font.boss_ui.size_scale_modifier = modules.reframework_globals.imgui.drag_float(
				modules.utils.imgui.label(cached_language.size_scale_modifier, "ui_font.boss_ui.size_scale_modifier"), cached_config.ui_font.boss_ui.size_scale_modifier, 0.01, 0.1, 100, "%.2f");
			config_changed = config_changed or changed;
			
			changed, cached_config.ui_font.boss_ui.scale_with_reframework_font_size = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.scale_with_reframework_font_size, "ui_font.boss_ui.scale_with_reframework_font_size"), cached_config.ui_font.boss_ui.scale_with_reframework_font_size);
			config_changed = config_changed or changed;

			modules.reframework_globals.imgui.tree_pop();
		end

		modules.reframework_globals.imgui.tree_pop();

	end

	if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.settings, "settings")) then
		if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(modules.language.current_language.customization_menu.timer_delays, "settings.timer_delays")) then

			changed, cached_config.settings.timer_delays.update_singletons_delay = modules.reframework_globals.imgui.drag_float(
				modules.utils.imgui.label(modules.language.current_language.customization_menu.update_singletons_delay, "settings.timer_delays.update_singletons_delay"),
				cached_config.settings.timer_delays.update_singletons_delay, 0.001, 0, 5, "%.3f");

			config_changed = config_changed or changed;

			changed, cached_config.settings.timer_delays.update_window_size_delay = modules.reframework_globals.imgui.drag_float(
				modules.utils.imgui.label(modules.language.current_language.customization_menu.update_window_size_delay, "settings.timer_delays.update_window_size_delay"),
				cached_config.settings.timer_delays.update_window_size_delay, 0.001, 0, 5, "%.3f");
			config_changed = config_changed or changed;

			changed, cached_config.settings.timer_delays.update_game_data_delay = modules.reframework_globals.imgui.drag_float(
				modules.utils.imgui.label(modules.language.current_language.customization_menu.update_game_data_delay, "settings.timer_delays.update_game_data_delay"),
				cached_config.settings.timer_delays.update_game_data_delay, 0.001, 0, 5, "%.3f");
			config_changed = config_changed or changed;

			changed, cached_config.settings.timer_delays.update_player_data_delay = modules.reframework_globals.imgui.drag_float(
				modules.utils.imgui.label(modules.language.current_language.customization_menu.update_player_data_delay, "settings.timer_delays.update_player_data_delay"),
				cached_config.settings.timer_delays.update_player_data_delay, 0.001, 0, 5, "%.3f");
			config_changed = config_changed or changed;

			changed, cached_config.settings.timer_delays.update_enemy_data_delay = modules.reframework_globals.imgui.drag_float(
				modules.utils.imgui.label(modules.language.current_language.customization_menu.update_enemy_data_delay, "settings.timer_delays.update_enemy_data_delay"),
				cached_config.settings.timer_delays.update_enemy_data_delay, 0.001, 0, 5, "%.3f");
			config_changed = config_changed or changed;

			modules.reframework_globals.imgui.tree_pop();
		end

		modules.reframework_globals.imgui.new_line();
		modules.reframework_globals.imgui.begin_rect();

		changed, cached_config.settings.use_d2d_if_available = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.use_d2d_renderer_if_available, "settings.use_d2d_if_available"),
			cached_config.settings.use_d2d_if_available);
		config_changed = config_changed or changed;

		modules.reframework_globals.imgui.end_rect(5);
		modules.reframework_globals.imgui.new_line();
		modules.reframework_globals.imgui.begin_rect();

		changed, cached_config.settings.hide_if_no_update_function_is_being_called = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_if_no_update_function_is_being_called, "settings.hide_if_no_update_function_is_being_called"),
			cached_config.settings.hide_if_no_update_function_is_being_called);
		config_changed = config_changed or changed;
	
		modules.reframework_globals.imgui.end_rect(5);
		modules.reframework_globals.imgui.new_line();
		
		
		modules.reframework_globals.imgui.tree_pop();
	end

	if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.dynamic_ui, "dynamic_ui")) then
		changed, cached_config.dynamic_ui.visible = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.visible, "dynamic_ui.visible"),
			cached_config.dynamic_ui.visible);
		config_changed = config_changed or changed;

		if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.settings, "dynamic_ui.settings")) then
			modules.reframework_globals.imgui.begin_rect();

			changed, cached_config.dynamic_ui.settings.render_during_cutscenes = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.render_during_cutscenes, "dynamic_ui.settings.render_during_cutscenes"),
				cached_config.dynamic_ui.settings.render_during_cutscenes);
			config_changed = config_changed or changed;

			changed, cached_config.dynamic_ui.settings.render_when_game_timer_is_paused = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.render_when_game_timer_is_paused, "dynamic_ui.settings.render_when_game_timer_is_paused"),
				cached_config.dynamic_ui.settings.render_when_game_timer_is_paused);
			config_changed = config_changed or changed;

			changed, cached_config.dynamic_ui.settings.render_in_mercenaries = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.render_in_mercenaries, "dynamic_ui.settings.render_in_mercenaries"),
				cached_config.dynamic_ui.settings.render_in_mercenaries);
			config_changed = config_changed or changed;

			modules.reframework_globals.imgui.end_rect(5);
			modules.reframework_globals.imgui.new_line();
			modules.reframework_globals.imgui.begin_rect();

			changed, cached_config.dynamic_ui.settings.render_in_house_benevientos_basement = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.render_in_house_benevientos_basement, "dynamic_ui.settings.render_in_house_benevientos_basement"),
				cached_config.dynamic_ui.settings.render_in_house_benevientos_basement);
			config_changed = config_changed or changed;
		
			modules.reframework_globals.imgui.end_rect(5);
			modules.reframework_globals.imgui.new_line();
			modules.reframework_globals.imgui.begin_rect();

			changed, cached_config.dynamic_ui.settings.render_aim_target_enemy = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.render_aim_target_enemy, "dynamic_ui.settings.render_aim_target_enemy"),
				cached_config.dynamic_ui.settings.render_aim_target_enemy);
			config_changed = config_changed or changed;

			changed, cached_config.dynamic_ui.settings.render_damaged_enemies = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.render_damaged_enemies, "dynamic_ui.settings.render_damaged_enemies"),
				cached_config.dynamic_ui.settings.render_damaged_enemies);
			config_changed = config_changed or changed;

			changed, cached_config.dynamic_ui.settings.render_everyone_else = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.render_everyone_else, "dynamic_ui.settings.render_everyone_else"),
				cached_config.dynamic_ui.settings.render_everyone_else);
			config_changed = config_changed or changed;
			
			modules.reframework_globals.imgui.end_rect(5);
			modules.reframework_globals.imgui.new_line();
			modules.reframework_globals.imgui.begin_rect();
			
			changed, cached_config.dynamic_ui.settings.render_when_normal = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.render_when_normal, "dynamic_ui.settings.render_when_normal"),
				cached_config.dynamic_ui.settings.render_when_normal);
			config_changed = config_changed or changed;

			changed, cached_config.dynamic_ui.settings.render_when_aiming = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.render_when_aiming, "dynamic_ui.settings.render_when_aiming"),
				cached_config.dynamic_ui.settings.render_when_aiming);
			config_changed = config_changed or changed;

			changed, cached_config.dynamic_ui.settings.render_when_using_scope = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.render_when_using_scope, "dynamic_ui.settings.render_when_using_scope"),
				cached_config.dynamic_ui.settings.render_when_using_scope);
			config_changed = config_changed or changed;

			modules.reframework_globals.imgui.end_rect(5);
			modules.reframework_globals.imgui.new_line();
			modules.reframework_globals.imgui.begin_rect();

			changed, cached_config.dynamic_ui.settings.hide_if_dead = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_if_dead, "dynamic_ui.settings.hide_if_dead"),
				cached_config.dynamic_ui.settings.hide_if_dead);
			config_changed = config_changed or changed;

			changed, cached_config.dynamic_ui.settings.hide_if_full_health = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_if_full_health, "dynamic_ui.settings.hide_if_full_health"),
				cached_config.dynamic_ui.settings.hide_if_full_health);
			config_changed = config_changed or changed;

			changed, cached_config.dynamic_ui.settings.hide_if_enemy_model_is_not_being_rendered = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_if_enemy_model_is_not_being_rendered, "dynamic_ui.settings.hide_if_enemy_model_is_not_being_rendered"),
				cached_config.dynamic_ui.settings.hide_if_enemy_model_is_not_being_rendered);
			config_changed = config_changed or changed;

			changed, cached_config.dynamic_ui.settings.hide_if_player_cant_take_damage = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_if_player_cant_take_damage, "dynamic_ui.settings.hide_if_player_cant_take_damage"),
				cached_config.dynamic_ui.settings.hide_if_player_cant_take_damage);
			config_changed = config_changed or changed;

			changed, cached_config.dynamic_ui.settings.hide_if_player_cant_use_items = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_if_player_cant_use_items, "dynamic_ui.settings.hide_if_player_cant_use_items"),
				cached_config.dynamic_ui.settings.hide_if_player_cant_use_items);
			config_changed = config_changed or changed;

			modules.reframework_globals.imgui.end_rect(5);
			modules.reframework_globals.imgui.new_line();
			modules.reframework_globals.imgui.begin_rect();

			changed, cached_config.dynamic_ui.settings.hide_urias = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_urias, "dynamic_ui.settings.hide_urias"),
				cached_config.dynamic_ui.settings.hide_urias);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.dynamic_ui.settings.hide_urias_drac = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_urias_drac, "dynamic_ui.settings.hide_urias_drac"),
				cached_config.dynamic_ui.settings.hide_urias_drac);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.dynamic_ui.settings.hide_urias_strajer = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_urias_strajer, "dynamic_ui.settings.hide_urias_strajer"),
				cached_config.dynamic_ui.settings.hide_urias_strajer);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.dynamic_ui.settings.hide_bela = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_bela, "dynamic_ui.settings.hide_bela"),
				cached_config.dynamic_ui.settings.hide_bela);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.dynamic_ui.settings.hide_cassandra = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_cassandra, "dynamic_ui.settings.hide_cassandra"),
				cached_config.dynamic_ui.settings.hide_cassandra);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.dynamic_ui.settings.hide_daniela = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_daniela, "dynamic_ui.settings.hide_daniela"),
				cached_config.dynamic_ui.settings.hide_daniela);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.dynamic_ui.settings.hide_dimitrescu_chasing = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_dimitrescu_chasing, "dynamic_ui.settings.hide_dimitrescu_chasing"),
				cached_config.dynamic_ui.settings.hide_dimitrescu_chasing);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.dynamic_ui.settings.hide_dimitrescu_boss = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_dimitrescu_boss, "dynamic_ui.settings.hide_dimitrescu_boss"),
				cached_config.dynamic_ui.settings.hide_dimitrescu_boss);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.dynamic_ui.settings.hide_angie = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_angie, "dynamic_ui.settings.hide_angie"),
				cached_config.dynamic_ui.settings.hide_angie);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.dynamic_ui.settings.hide_varcolac = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_varcolac, "dynamic_ui.settings.hide_varcolac"),
				cached_config.dynamic_ui.settings.hide_varcolac);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.dynamic_ui.settings.hide_varcolac_alfa = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_varcolac_alfa, "dynamic_ui.settings.hide_varcolac_alfa"),
				cached_config.dynamic_ui.settings.hide_varcolac_alfa);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.dynamic_ui.settings.hide_moreau = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_moreau, "dynamic_ui.settings.hide_moreau"),
				cached_config.dynamic_ui.settings.hide_moreau);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.dynamic_ui.settings.hide_sturm = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_sturm, "dynamic_ui.settings.hide_sturm"),
				cached_config.dynamic_ui.settings.hide_sturm);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.dynamic_ui.settings.hide_heisenberg = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_heisenberg, "dynamic_ui.settings.hide_heisenberg"),
				cached_config.dynamic_ui.settings.hide_heisenberg);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.dynamic_ui.settings.hide_executioner = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_executioner, "dynamic_ui.settings.hide_executioner"),
				cached_config.dynamic_ui.settings.hide_executioner);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.dynamic_ui.settings.hide_miranda = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_miranda, "dynamic_ui.settings.hide_miranda"),
				cached_config.dynamic_ui.settings.hide_miranda);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.dynamic_ui.settings.hide_miranda_in_dlc = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_miranda_in_dlc, "dynamic_ui.settings.hide_miranda_in_dlc"),
				cached_config.dynamic_ui.settings.hide_miranda_in_dlc);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			modules.reframework_globals.imgui.end_rect(5);
			modules.reframework_globals.imgui.new_line();
			modules.reframework_globals.imgui.begin_rect();

			changed, cached_config.dynamic_ui.settings.hide_leonardo = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_leonardo, "dynamic_ui.settings.hide_leonardo"),
				cached_config.dynamic_ui.settings.hide_leonardo);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.dynamic_ui.settings.hide_duke = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_duke, "dynamic_ui.settings.hide_duke"),
				cached_config.dynamic_ui.settings.hide_duke);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			modules.reframework_globals.imgui.new_line();

			changed, cached_config.dynamic_ui.settings.hide_blue_bird = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_blue_bird, "dynamic_ui.settings.hide_blue_bird"),
				cached_config.dynamic_ui.settings.hide_blue_bird);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.dynamic_ui.settings.hide_pigs = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_pigs, "dynamic_ui.settings.hide_pigs"),
				cached_config.dynamic_ui.settings.hide_pigs);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.dynamic_ui.settings.hide_chickens = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_chickens, "dynamic_ui.settings.hide_chickens"),
				cached_config.dynamic_ui.settings.hide_chickens);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.dynamic_ui.settings.hide_goats = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_goats, "dynamic_ui.settings.hide_goats"),
				cached_config.dynamic_ui.settings.hide_goats);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.dynamic_ui.settings.hide_fish = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_fish, "dynamic_ui.settings.hide_fish"),
				cached_config.dynamic_ui.settings.hide_fish);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.dynamic_ui.settings.hide_catfish = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_catfish, "dynamic_ui.settings.hide_catfish"),
				cached_config.dynamic_ui.settings.hide_catfish);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			modules.reframework_globals.imgui.new_line();

			changed, cached_config.dynamic_ui.settings.hide_rose_copies = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_rose_copies, "dynamic_ui.settings.hide_rose_copies"),
				cached_config.dynamic_ui.settings.hide_rose_copies);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.dynamic_ui.settings.hide_masked_duke = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_masked_duke, "dynamic_ui.settings.hide_masked_duke"),
				cached_config.dynamic_ui.settings.hide_masked_duke);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.dynamic_ui.settings.hide_mia_dolls = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_mia_dolls, "dynamic_ui.settings.hide_mia_dolls"),
				cached_config.dynamic_ui.settings.hide_mia_dolls);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.dynamic_ui.settings.hide_dolls = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_dolls, "dynamic_ui.settings.hide_dolls"),
				cached_config.dynamic_ui.settings.hide_dolls);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.dynamic_ui.settings.hide_rose_illusion = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_rose_illusion, "dynamic_ui.settings.hide_rose_illusion"),
				cached_config.dynamic_ui.settings.hide_rose_illusion);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.dynamic_ui.settings.hide_miranda_crows = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_miranda_crows, "dynamic_ui.settings.hide_miranda_crows"),
				cached_config.dynamic_ui.settings.hide_miranda_crows);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.dynamic_ui.settings.hide_ethan_dlc = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_ethan_in_dlc, "dynamic_ui.settings.hide_ethan_dlc"),
				cached_config.dynamic_ui.settings.hide_ethan_dlc);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			modules.reframework_globals.imgui.end_rect(5);
			modules.reframework_globals.imgui.new_line();
			modules.reframework_globals.imgui.begin_rect();

			changed, cached_config.dynamic_ui.settings.opacity_falloff = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.opacity_falloff, "dynamic_ui.settings.opacity_falloff"),
				cached_config.dynamic_ui.settings.opacity_falloff);
			config_changed = config_changed or changed;

			changed, cached_config.dynamic_ui.settings.max_distance = modules.reframework_globals.imgui.drag_float(modules.utils.imgui.label(cached_language.max_distance, "dynamic_ui.settings.max_distance"),
				cached_config.dynamic_ui.settings.max_distance, 1, 0, 10000, "%.0f");
			config_changed = config_changed or changed;

			changed, cached_config.dynamic_ui.settings.scope_opacity_falloff = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.opacity_Falloff_scope, "dynamic_ui.settings.scope_opacity_falloff"),
				cached_config.dynamic_ui.settings.scope_opacity_falloff);
			config_changed = config_changed or changed;

			changed, cached_config.dynamic_ui.settings.scope_max_distance = modules.reframework_globals.imgui.drag_float(modules.utils.imgui.label(cached_language.max_distance_scope, "dynamic_ui.settings.scope_max_distance"),
				cached_config.dynamic_ui.settings.scope_max_distance, 1, 0, 10000, "%.0f");
			config_changed = config_changed or changed;

			modules.reframework_globals.imgui.end_rect(5);
			modules.reframework_globals.imgui.new_line();
			modules.reframework_globals.imgui.begin_rect();

			changed, cached_config.dynamic_ui.settings.apply_time_duration_on_aiming = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.apply_time_duration_on_aiming, "dynamic_ui.settings.apply_time_duration_on_aiming"),
				cached_config.dynamic_ui.settings.apply_time_duration_on_aiming);
			config_changed = config_changed or changed;

			changed, cached_config.dynamic_ui.settings.apply_time_duration_on_aim_target = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.apply_time_duration_on_aim_target, "dynamic_ui.settings.apply_time_duration_on_aim_target"),
				cached_config.dynamic_ui.settings.apply_time_duration_on_aim_target);
			config_changed = config_changed or changed;

			changed, cached_config.dynamic_ui.settings.apply_time_duration_on_using_scope = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.apply_time_duration_on_using_scope, "dynamic_ui.settings.apply_time_duration_on_using_scope"),
				cached_config.dynamic_ui.settings.apply_time_duration_on_using_scope);
			config_changed = config_changed or changed;

			changed, cached_config.dynamic_ui.settings.apply_time_duration_on_damage_dealt = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.apply_time_duration_on_damage_dealt, "dynamic_ui.settings.apply_time_duration_on_damage_dealt"),
				cached_config.dynamic_ui.settings.apply_time_duration_on_damage_dealt);
			config_changed = config_changed or changed;

			changed, cached_config.dynamic_ui.settings.reset_time_duration_on_aim_target_for_everyone = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.reset_time_duration_on_aim_target_for_everyone, "dynamic_ui.settings.reset_time_duration_on_aim_target_for_everyone"),
				cached_config.dynamic_ui.settings.reset_time_duration_on_aim_target_for_everyone);
			config_changed = config_changed or changed;

			changed, cached_config.dynamic_ui.settings.reset_time_duration_on_damage_dealt_for_everyone = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.reset_time_duration_on_damage_dealt_for_everyone, "dynamic_ui.settings.reset_time_duration_on_damage_dealt_for_everyone"),
				cached_config.dynamic_ui.settings.reset_time_duration_on_damage_dealt_for_everyone);
			config_changed = config_changed or changed;

			changed, cached_config.dynamic_ui.settings.time_duration = modules.reframework_globals.imgui.drag_float(modules.utils.imgui.label(cached_language.time_duration, "dynamic_ui.settings.time_duration"),
				cached_config.dynamic_ui.settings.time_duration, 0.1, 0, 1000, "%.1f");

			modules.reframework_globals.imgui.end_rect(5);
			modules.reframework_globals.imgui.new_line();
			
			modules.reframework_globals.imgui.tree_pop();
		end

		changed = modules.world_offset_customization.draw("dynamic_ui", cached_config.dynamic_ui.world_offset);
		config_changed = config_changed or changed;

		changed = modules.offset_customization.draw("dynamic_ui", cached_config.dynamic_ui.offset);
		config_changed = config_changed or changed;

		if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.health, "dynamic_ui.health")) then
			changed, cached_config.dynamic_ui.health.visible = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.visible, "dynamic_ui.health.visible"), cached_config.dynamic_ui.health.visible);
            config_changed = config_changed or changed;
			
            changed = modules.offset_customization.draw("dynamic_ui.health", cached_config.dynamic_ui.health.offset);
            config_changed = config_changed or changed;
			
			changed = modules.label_customization.draw("dynamic_ui.health.value_label", cached_language.value_label, cached_config.dynamic_ui.health.value_label);
            config_changed = config_changed or changed;
			
			changed = modules.label_customization.draw("dynamic_ui.health.percentage_label", cached_language.percentage_label, cached_config.dynamic_ui.health.percentage_label);
			config_changed = config_changed or changed;

			changed = modules.bar_customization.draw("dynamic_ui.health.bar", cached_language.bar, cached_config.dynamic_ui.health.bar);
			config_changed = config_changed or changed;

			modules.reframework_globals.imgui.tree_pop();
		end
		
		modules.reframework_globals.imgui.tree_pop();
	end

	if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.boss_ui, "boss_ui")) then
		changed, cached_config.boss_ui.visible = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.visible, "boss_ui.visible"),
			cached_config.boss_ui.visible);
		config_changed = config_changed or changed;

		if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.settings, "boss_ui.settings")) then
			modules.reframework_globals.imgui.begin_rect();

			changed, cached_config.boss_ui.settings.render_during_cutscenes = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.render_during_cutscenes, "boss_ui.settings.render_during_cutscenes"),
				cached_config.boss_ui.settings.render_during_cutscenes);
			config_changed = config_changed or changed;

			changed, cached_config.boss_ui.settings.render_when_game_timer_is_paused = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.render_when_game_timer_is_paused, "boss_ui.settings.render_when_game_timer_is_paused"),
				cached_config.boss_ui.settings.render_when_game_timer_is_paused);
			config_changed = config_changed or changed;

			changed, cached_config.boss_ui.settings.render_in_mercenaries = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.render_in_mercenaries, "boss_ui.settings.render_in_mercenaries"),
				cached_config.boss_ui.settings.render_in_mercenaries);
			config_changed = config_changed or changed;

			modules.reframework_globals.imgui.end_rect(5);
			modules.reframework_globals.imgui.new_line();
			modules.reframework_globals.imgui.begin_rect();

			changed, cached_config.boss_ui.settings.render_in_house_benevientos_basement = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.render_in_house_benevientos_basement, "boss_ui.settings.render_in_house_benevientos_basement"),
				cached_config.boss_ui.settings.render_in_house_benevientos_basement);
			config_changed = config_changed or changed;
		
			modules.reframework_globals.imgui.end_rect(5);
			modules.reframework_globals.imgui.new_line();
			modules.reframework_globals.imgui.begin_rect();
			
			changed, cached_config.boss_ui.settings.render_when_normal = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.render_when_normal, "boss_ui.settings.render_when_normal"),
				cached_config.boss_ui.settings.render_when_normal);
			config_changed = config_changed or changed;

			changed, cached_config.boss_ui.settings.render_when_aiming = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.render_when_aiming, "boss_ui.settings.render_when_aiming"),
				cached_config.boss_ui.settings.render_when_aiming);
			config_changed = config_changed or changed;

			changed, cached_config.boss_ui.settings.render_when_using_scope = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.render_when_using_scope, "boss_ui.settings.render_when_using_scope"),
				cached_config.boss_ui.settings.render_when_using_scope);
			config_changed = config_changed or changed;

			modules.reframework_globals.imgui.end_rect(5);
			modules.reframework_globals.imgui.new_line();
			modules.reframework_globals.imgui.begin_rect();

			changed, cached_config.boss_ui.settings.hide_if_dead = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_if_dead, "boss_ui.settings.hide_if_dead"),
				cached_config.boss_ui.settings.hide_if_dead);
			config_changed = config_changed or changed;

			changed, cached_config.boss_ui.settings.hide_if_full_health = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_if_full_health, "boss_ui.settings.hide_if_full_health"),
				cached_config.boss_ui.settings.hide_if_full_health);
			config_changed = config_changed or changed;

			changed, cached_config.boss_ui.settings.hide_if_enemy_model_is_not_being_rendered = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_if_enemy_model_is_not_being_rendered, "boss_ui.settings.hide_if_enemy_model_is_not_being_rendered"),
				cached_config.boss_ui.settings.hide_if_enemy_model_is_not_being_rendered);
			config_changed = config_changed or changed;

			changed, cached_config.boss_ui.settings.hide_if_player_cant_take_damage = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_if_player_cant_take_damage, "boss_ui.settings.hide_if_player_cant_take_damage"),
				cached_config.boss_ui.settings.hide_if_player_cant_take_damage);
			config_changed = config_changed or changed;

			changed, cached_config.boss_ui.settings.hide_if_player_cant_use_items = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_if_player_cant_use_items, "boss_ui.settings.hide_if_player_cant_use_items"),
				cached_config.boss_ui.settings.hide_if_player_cant_use_items);
			config_changed = config_changed or changed;

			modules.reframework_globals.imgui.end_rect(5);
			modules.reframework_globals.imgui.new_line();
			modules.reframework_globals.imgui.begin_rect();

			changed, cached_config.boss_ui.settings.hide_urias = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_urias, "boss_ui.settings.hide_urias"),
				cached_config.boss_ui.settings.hide_urias);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.boss_ui.settings.hide_urias_drac = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_urias_drac, "boss_ui.settings.hide_urias_drac"),
				cached_config.boss_ui.settings.hide_urias_drac);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.boss_ui.settings.hide_urias_strajer = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_urias_strajer, "boss_ui.settings.hide_urias_strajer"),
				cached_config.boss_ui.settings.hide_urias_strajer);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.boss_ui.settings.hide_bela = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_bela, "boss_ui.settings.hide_bela"),
				cached_config.boss_ui.settings.hide_bela);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.boss_ui.settings.hide_bela_invincible = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_bela_invincible, "boss_ui.settings.hide_bela_invincible"),
				cached_config.boss_ui.settings.hide_bela_invincible);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.boss_ui.settings.hide_cassandra = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_cassandra, "boss_ui.settings.hide_cassandra"),
				cached_config.boss_ui.settings.hide_cassandra);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.boss_ui.settings.hide_cassandra_invincible = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_cassandra_invincible, "boss_ui.settings.hide_cassandra_invincible"),
				cached_config.boss_ui.settings.hide_cassandra_invincible);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.boss_ui.settings.hide_daniela = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_daniela, "boss_ui.settings.hide_daniela"),
				cached_config.boss_ui.settings.hide_daniela);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.boss_ui.settings.hide_daniela_invincible = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_daniela_invincible, "boss_ui.settings.hide_daniela_invincible"),
				cached_config.boss_ui.settings.hide_daniela_invincible);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.boss_ui.settings.hide_dimitrescu_chasing = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_dimitrescu_chasing, "boss_ui.settings.hide_dimitrescu_chasing"),
				cached_config.boss_ui.settings.hide_dimitrescu_chasing);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.boss_ui.settings.hide_dimitrescu_boss = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_dimitrescu_boss, "boss_ui.settings.hide_dimitrescu_boss"),
				cached_config.boss_ui.settings.hide_dimitrescu_boss);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.boss_ui.settings.hide_angie = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_angie, "boss_ui.settings.hide_angie"),
				cached_config.boss_ui.settings.hide_angie);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.boss_ui.settings.hide_varcolac = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_varcolac, "boss_ui.settings.hide_varcolac"),
				cached_config.boss_ui.settings.hide_varcolac);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.boss_ui.settings.hide_varcolac_alfa = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_varcolac_alfa, "boss_ui.settings.hide_varcolac_alfa"),
				cached_config.boss_ui.settings.hide_varcolac_alfa);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.boss_ui.settings.hide_moreau = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_moreau, "boss_ui.settings.hide_moreau"),
				cached_config.boss_ui.settings.hide_moreau);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.boss_ui.settings.hide_sturm = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_sturm, "boss_ui.settings.hide_sturm"),
				cached_config.boss_ui.settings.hide_sturm);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.boss_ui.settings.hide_heisenberg = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_heisenberg, "boss_ui.settings.hide_heisenberg"),
				cached_config.boss_ui.settings.hide_heisenberg);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.boss_ui.settings.hide_executioner = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_executioner, "boss_ui.settings.hide_executioner"),
				cached_config.boss_ui.settings.hide_executioner);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.boss_ui.settings.hide_miranda = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_miranda, "boss_ui.settings.hide_miranda"),
				cached_config.boss_ui.settings.hide_miranda);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			changed, cached_config.boss_ui.settings.hide_miranda_in_dlc = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_miranda_in_dlc, "boss_ui.settings.hide_miranda_in_dlc"),
				cached_config.boss_ui.settings.hide_miranda_in_dlc);
			config_changed = config_changed or changed;
			enemy_filters_changed = enemy_filters_changed or changed;

			modules.reframework_globals.imgui.end_rect(5);
			modules.reframework_globals.imgui.new_line();
			
			modules.reframework_globals.imgui.tree_pop();
		end

		changed = modules.position_customization.draw("boss_ui", cached_config.boss_ui.position);
		config_changed = config_changed or changed;

		changed = modules.spacing_customization.draw("boss_ui", cached_config.boss_ui.spacing);
		config_changed = config_changed or changed;

		changed = modules.label_customization.draw("boss_ui.name_label", modules.utils.imgui.label(cached_language.name_label, "boss_ui.name_label"), cached_config.boss_ui.name_label);
		config_changed = config_changed or changed;

		if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.health, "boss_ui.health")) then
	        changed, cached_config.boss_ui.health.visible = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.visible, "boss_ui.health.visible"), cached_config.boss_ui.health.visible);
            config_changed = config_changed or changed;
			
            changed = modules.offset_customization.draw("boss_ui", cached_config.boss_ui.health.offset);
            config_changed = config_changed or changed;
			
			changed = modules.label_customization.draw("boss_ui.health.value_label", cached_language.value_label, cached_config.boss_ui.health.value_label);
            config_changed = config_changed or changed;
			
			changed = modules.label_customization.draw("boss_ui.health.percentage_label", cached_language.percentage_label, cached_config.boss_ui.health.percentage_label);
			config_changed = config_changed or changed;
			
			changed = modules.bar_customization.draw("boss_ui.health.bar", cached_language.bar, cached_config.boss_ui.health.bar);
			config_changed = config_changed or changed;

			modules.reframework_globals.imgui.tree_pop();
		end
		
		modules.reframework_globals.imgui.tree_pop();
	end


	changed = this.draw_debug();
	config_changed = config_changed or changed;
	
	modules.reframework_globals.imgui.end_window();
	modules.reframework_globals.imgui.pop_font();

	if language_changed then
		cached_config.language = modules.language.language_names[language_index];
		modules.language.update(language_index);
		this.init();

		this.reload_font();
	end

	if menu_font_changed then
		this.reload_font();
	end

	if enemy_filters_changed then
		for enemy_core, enemy in pairs(modules.enemy_handler.enemy_list) do
			modules.enemy_handler.update_is_filtered_out(enemy);
		end
	end

	if config_changed or language_changed or window_changed then
		modules.config.save();
	end
end

function this.draw_debug()
    local cached_config = modules.config.current_config.debug;
	local cached_language = modules.language.current_language.customization_menu;

	local changed = false;
	local config_changed = false;

	if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.debug, "debug")) then
		
		modules.reframework_globals.imgui.text_colored(string.format("%s:", cached_language.current_time), 0xFFAAAA66);
		modules.reframework_globals.imgui.same_line();
		modules.reframework_globals.imgui.text(string.format("%.3fs", modules.time.total_elapsed_script_seconds));

		if modules.error_handler.is_empty then
			modules.reframework_globals.imgui.text(cached_language.everything_seems_to_be_ok);
		else
			for error_key, error in pairs(modules.error_handler.list) do

				modules.reframework_globals.imgui.button(modules.utils.imgui.label(string.format("%.3fs", error.time), "debug.list.list_entry_" .. tostring(error)));
				modules.reframework_globals.imgui.same_line();
				modules.reframework_globals.imgui.text_colored(error_key, 0xFFAA66AA);
				modules.reframework_globals.imgui.same_line();
				modules.reframework_globals.imgui.text(error.message);
			end
		end

		if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.history, "debug.history")) then

			changed, cached_config.history_size = modules.reframework_globals.imgui.drag_int(
				modules.utils.imgui.label(cached_language.history_size, "debug.history.history_size"), cached_config.history_size, 1, 0, 1024);

			config_changed = config_changed or changed;

			if changed then
				modules.error_handler.history = {};
			end

			for index, error in pairs(modules.error_handler.history) do
				modules.reframework_globals.imgui.text_colored(index, 0xFF66AA66);
				modules.reframework_globals.imgui.same_line();
				modules.reframework_globals.imgui.button(modules.utils.imgui.label(string.format("%.3fs", error.time), "debug.history.history_entry_" .. tostring(error)));
				modules.reframework_globals.imgui.same_line();
				modules.reframework_globals.imgui.text_colored(error.key, 0xFFAA66AA);
				modules.reframework_globals.imgui.same_line();
				modules.reframework_globals.imgui.text(error.message);
			end


			modules.reframework_globals.imgui.tree_pop();
		end

		modules.reframework_globals.imgui.tree_pop();
	end

	return config_changed;
end

function this.init_module()
	this.init();
	this.reload_font();
end

return this;