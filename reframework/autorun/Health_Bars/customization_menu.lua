local this = {};

local utils;
local config;
local language;
local label_customization;
local bar_customization;
local time;
local enemy_handler;
local error_handler;

local sdk = sdk;
local tostring = tostring;
local pairs = pairs;
local ipairs = ipairs;
local tonumber = tonumber;
local require = require;
local pcall = pcall;
local table = table;
local string = string;
local Vector3f = Vector3f;
local d2d = d2d;
local math = math;
local json = json;
local log = log;
local fs = fs;
local next = next;
local type = type;
local setmetatable = setmetatable;
local getmetatable = getmetatable;
local assert = assert;
local select = select;
local coroutine = coroutine;
local utf8 = utf8;
local re = re;
local imgui = imgui;
local draw = draw;
local Vector2f = Vector2f;
local reframework = reframework;
local os = os;

this.font = nil;
this.full_font_range = {0x1, 0xFFFF, 0};
this.is_opened = false;

this.window_position = Vector2f.new(480, 200);
this.window_pivot = Vector2f.new(0, 0);
this.window_size = Vector2f.new(650, 700);
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
	local cached_language = language.current_language;

	local font_range = cached_language.unicode_glyph_ranges;

	if cached_language.font_name == "" then
		font_range = nil;

	elseif cached_language.unicode_glyph_ranges == nil
	or utils.table.is_empty(cached_language.unicode_glyph_ranges)
	or #cached_language.unicode_glyph_ranges == 1
	or not utils.number.is_odd(#cached_language.unicode_glyph_ranges)
	 then

		font_range = this.full_font_range;
	end

	this.font = imgui.load_font(cached_language.font_name,
		config.current_config.menu_font.size, font_range);

	if pop_push then
		imgui.pop_font();
		imgui.push_font(this.font);
	end
end

function this.init()
	label_customization.init();
	bar_customization.init();
end

function this.draw()
	local cached_config = config.current_config;
	local cached_language = language.current_language.customization_menu;

	local window_position = Vector2f.new(config.current_config.customization_menu.position.x, config.current_config.customization_menu.position.y);
	local window_pivot = Vector2f.new(config.current_config.customization_menu.pivot.x, config.current_config.customization_menu.pivot.y);
	local window_size = Vector2f.new(config.current_config.customization_menu.size.width, config.current_config.customization_menu.size.height);

	imgui.set_next_window_pos(window_position, 1 << 3, window_pivot);
	imgui.set_next_window_size(window_size, 1 << 3);

	imgui.push_font(this.font);

	this.is_opened = imgui.begin_window(
		cached_language.mod_name .. " v" .. config.current_config.version, this.is_opened, this.window_flags);

	if not this.is_opened then
		imgui.pop_font();
		imgui.end_window();
		return;
	end

	local changed = false;
	local config_changed = false;
	local enemy_filters_changed = false;
	local timer_delays_changed = false;
	local language_changed = false;
	local menu_font_changed = false;
	local window_changed = false;
	
	local index = 1;
	local language_index = 1;

	local new_window_position = imgui.get_window_pos();
	if window_position.x ~= new_window_position.x or window_position.y ~= new_window_position.y then
		window_changed = window_changed or true;

		config.current_config.customization_menu.position.x = new_window_position.x;
		config.current_config.customization_menu.position.y = new_window_position.y;
	end

	local new_window_size = imgui.get_window_size();
	if window_size.x ~= new_window_size.x or window_size.y ~= new_window_size.y then
		window_changed = window_changed or true;

		config.current_config.customization_menu.size.width = new_window_size.x;
		config.current_config.customization_menu.size.height = new_window_size.y;
	end

	if imgui.button(cached_language.reset_config) then
		config.reset();
		config_changed = true;
	end

	changed, cached_config.enabled = imgui.checkbox(cached_language.enabled, cached_config.enabled);
	config_changed = config_changed or changed;

	if imgui.tree_node(cached_language.language) then
		imgui.text(cached_language.menu_font_change_disclaimer);

		changed, language_index = imgui.combo(cached_language.language,
			utils.table.find_index(language.language_names, cached_config.language), language.language_names);

		config_changed = config_changed or changed;
		language_changed = language_changed or changed;

		imgui.tree_pop();
	end

	if imgui.tree_node(language.current_language.customization_menu.menu_font) then
		imgui.text(cached_language.menu_font_change_disclaimer);

		local new_value = cached_config.menu_font.size;
		changed, new_value = imgui.input_text(" ", cached_config.menu_font.size, this.decimal_input_flags);
		new_value = tonumber(new_value);

		if new_value ~= nil then
			if new_value < 5 then
				new_value = 5;
			elseif new_value > 100 then
				new_value = 100;
			end

			cached_config.menu_font.size = math.floor(new_value);
		end

		config_changed = config_changed or changed;
		this.menu_font_changed = this.menu_font_changed or changed;

		imgui.same_line();

		changed = imgui.button("-");
		config_changed = config_changed or changed;

		imgui.same_line();

		if changed then
			cached_config.menu_font.size = cached_config.menu_font.size - 1;

			if cached_config.menu_font.size < 5 then
				cached_config.menu_font.size = 5;
			else
				this.menu_font_changed = this.menu_font_changed or changed;
			end
		end

		changed = imgui.button("+");
		config_changed = config_changed or changed;

		imgui.same_line();

		if changed then
			cached_config.menu_font.size = cached_config.menu_font.size + 1;

			if cached_config.menu_font.size > 100 then
				cached_config.menu_font.size = 100;
			else
				this.menu_font_changed = this.menu_font_changed or changed;
			end
		end

		imgui.text(language.current_language.customization_menu.size);

		if imgui.button(language.current_language.customization_menu.apply) then
			menu_font_changed = true;
		end

		imgui.tree_pop();
	end

	if imgui.tree_node(cached_language.ui_font) then
		imgui.text(cached_language.font_notice);
		
		changed, index = imgui.combo(cached_language.family,
			utils.table.find_index(this.fonts, cached_config.ui_font.family), this.fonts);
		config_changed = config_changed or changed;

		if changed then
			cached_config.ui_font.family = this.fonts[index];
		end

		changed, cached_config.ui_font.size = imgui.slider_int(cached_language.size,
			cached_config.ui_font.size, 1, 100);
		config_changed = config_changed or changed;

		changed, cached_config.ui_font.bold = imgui.checkbox(cached_language.bold,
			cached_config.ui_font.bold);
		config_changed = config_changed or changed;

		changed, cached_config.ui_font.italic = imgui.checkbox(cached_language.italic,
			cached_config.ui_font.italic);
		config_changed = config_changed or changed;

		imgui.tree_pop();

	end

	if imgui.tree_node(cached_language.settings) then
		if imgui.tree_node(language.current_language.customization_menu.timer_delays) then

			changed, cached_config.settings.timer_delays.update_singletons_delay = imgui.drag_float(
				language.current_language.customization_menu.update_singletons_delay,
				cached_config.settings.timer_delays.update_singletons_delay, 0.001, 0, 5, "%.3f");
			
			config_changed = config_changed or changed;
			timer_delays_changed = timer_delays_changed or changed;

			changed, cached_config.settings.timer_delays.update_window_size_delay = imgui.drag_float(
				language.current_language.customization_menu.update_window_size_delay,
				cached_config.settings.timer_delays.update_window_size_delay, 0.001, 0, 5, "%.3f");
			
			config_changed = config_changed or changed;
			timer_delays_changed = timer_delays_changed or changed;
			
			changed, cached_config.settings.timer_delays.update_game_data_delay = imgui.drag_float(
				language.current_language.customization_menu.update_game_data_delay,
				cached_config.settings.timer_delays.update_game_data_delay, 0.001, 0, 5, "%.3f");
			
			config_changed = config_changed or changed;
			timer_delays_changed = timer_delays_changed or changed;

			changed, cached_config.settings.timer_delays.update_player_data_delay = imgui.drag_float(
				language.current_language.customization_menu.update_player_data_delay,
				cached_config.settings.timer_delays.update_player_data_delay, 0.001, 0, 5, "%.3f");
			
			config_changed = config_changed or changed;
			timer_delays_changed = timer_delays_changed or changed;

			changed, cached_config.settings.timer_delays.update_enemy_data_delay = imgui.drag_float(
				language.current_language.customization_menu.update_enemy_data_delay,
				cached_config.settings.timer_delays.update_enemy_data_delay, 0.001, 0, 5, "%.3f");
			
			config_changed = config_changed or changed;
			timer_delays_changed = timer_delays_changed or changed;

			imgui.tree_pop();
		end

		imgui.new_line();
		imgui.begin_rect()

		changed, cached_config.settings.use_d2d_if_available = imgui.checkbox(cached_language.use_d2d_renderer_if_available,
			cached_config.settings.use_d2d_if_available);
		config_changed = config_changed or changed;

		imgui.end_rect(5);
		imgui.new_line();
		imgui.begin_rect()

		changed, cached_config.settings.render_during_cutscenes = imgui.checkbox(cached_language.render_during_cutscenes,
			cached_config.settings.render_during_cutscenes);
		config_changed = config_changed or changed;

		changed, cached_config.settings.render_when_game_timer_is_paused = imgui.checkbox(cached_language.render_when_game_timer_is_paused,
			cached_config.settings.render_when_game_timer_is_paused);
		config_changed = config_changed or changed;

		changed, cached_config.settings.render_in_mercenaries = imgui.checkbox(cached_language.render_in_mercenaries,
			cached_config.settings.render_in_mercenaries);
		config_changed = config_changed or changed;
	
		imgui.end_rect(5);
		imgui.new_line();
		imgui.begin_rect();

		changed, cached_config.settings.render_aim_target_enemy = imgui.checkbox(cached_language.render_aim_target_enemy,
			cached_config.settings.render_aim_target_enemy);
		config_changed = config_changed or changed;

		changed, cached_config.settings.render_damaged_enemies = imgui.checkbox(cached_language.render_damaged_enemies,
			cached_config.settings.render_damaged_enemies);
		config_changed = config_changed or changed;

		changed, cached_config.settings.render_everyone_else = imgui.checkbox(cached_language.render_everyone_else,
			cached_config.settings.render_everyone_else);
		config_changed = config_changed or changed;
		
		imgui.end_rect(5);
		imgui.new_line();
		imgui.begin_rect()
		
		changed, cached_config.settings.render_when_normal = imgui.checkbox(cached_language.render_when_normal,
			cached_config.settings.render_when_normal);
		config_changed = config_changed or changed;

		changed, cached_config.settings.render_when_aiming = imgui.checkbox(cached_language.render_when_aiming,
			cached_config.settings.render_when_aiming);
		config_changed = config_changed or changed;

		changed, cached_config.settings.render_when_using_scope = imgui.checkbox(cached_language.render_when_using_scope,
			cached_config.settings.render_when_using_scope);
		config_changed = config_changed or changed;

		imgui.end_rect(5);
		imgui.new_line();
		imgui.begin_rect()

		changed, cached_config.settings.hide_if_dead = imgui.checkbox(cached_language.hide_if_dead,
			cached_config.settings.hide_if_dead);
		config_changed = config_changed or changed;

		changed, cached_config.settings.hide_if_full_health = imgui.checkbox(cached_language.hide_if_full_health,
			cached_config.settings.hide_if_full_health);
		config_changed = config_changed or changed;

		changed, cached_config.settings.hide_if_enemy_model_is_not_being_rendered = imgui.checkbox(cached_language.hide_if_enemy_model_is_not_being_rendered,
			cached_config.settings.hide_if_enemy_model_is_not_being_rendered);
		config_changed = config_changed or changed;

		changed, cached_config.settings.hide_if_no_update_function_is_being_called = imgui.checkbox(cached_language.hide_if_no_update_function_is_being_called,
			cached_config.settings.hide_if_no_update_function_is_being_called);
		config_changed = config_changed or changed;

		imgui.end_rect(5);
		imgui.new_line();
		imgui.begin_rect();

		changed, cached_config.settings.hide_leonardo = imgui.checkbox(cached_language.hide_leonardo,
			cached_config.settings.hide_leonardo);
		config_changed = config_changed or changed;
		enemy_filters_changed = enemy_filters_changed or changed;

		changed, cached_config.settings.hide_duke = imgui.checkbox(cached_language.hide_duke,
			cached_config.settings.hide_duke);
		config_changed = config_changed or changed;
		enemy_filters_changed = enemy_filters_changed or changed;

		imgui.new_line();

		changed, cached_config.settings.hide_blue_bird = imgui.checkbox(cached_language.hide_blue_bird,
			cached_config.settings.hide_blue_bird);
		config_changed = config_changed or changed;
		enemy_filters_changed = enemy_filters_changed or changed;

		changed, cached_config.settings.hide_pigs = imgui.checkbox(cached_language.hide_pigs,
			cached_config.settings.hide_pigs);
		config_changed = config_changed or changed;
		enemy_filters_changed = enemy_filters_changed or changed;

		changed, cached_config.settings.hide_chickens = imgui.checkbox(cached_language.hide_chickens,
			cached_config.settings.hide_chickens);
		config_changed = config_changed or changed;
		enemy_filters_changed = enemy_filters_changed or changed;

		changed, cached_config.settings.hide_goats = imgui.checkbox(cached_language.hide_goats,
			cached_config.settings.hide_goats);
		config_changed = config_changed or changed;
		enemy_filters_changed = enemy_filters_changed or changed;

		changed, cached_config.settings.hide_fish = imgui.checkbox(cached_language.hide_fish,
			cached_config.settings.hide_fish);
		config_changed = config_changed or changed;
		enemy_filters_changed = enemy_filters_changed or changed;

		changed, cached_config.settings.hide_catfish = imgui.checkbox(cached_language.hide_catfish,
			cached_config.settings.hide_catfish);
		config_changed = config_changed or changed;
		enemy_filters_changed = enemy_filters_changed or changed;

		imgui.new_line();

		changed, cached_config.settings.hide_rose_copies = imgui.checkbox(cached_language.hide_rose_copies,
			cached_config.settings.hide_rose_copies);
		config_changed = config_changed or changed;
		enemy_filters_changed = enemy_filters_changed or changed;

		changed, cached_config.settings.hide_masked_duke = imgui.checkbox(cached_language.hide_masked_duke,
			cached_config.settings.hide_masked_duke);
		config_changed = config_changed or changed;
		enemy_filters_changed = enemy_filters_changed or changed;

		changed, cached_config.settings.hide_mia_dolls = imgui.checkbox(cached_language.hide_mia_dolls,
			cached_config.settings.hide_mia_dolls);
		config_changed = config_changed or changed;
		enemy_filters_changed = enemy_filters_changed or changed;

		changed, cached_config.settings.hide_dolls = imgui.checkbox(cached_language.hide_dolls,
			cached_config.settings.hide_dolls);
		config_changed = config_changed or changed;
		enemy_filters_changed = enemy_filters_changed or changed;

		changed, cached_config.settings.hide_rose_illusion = imgui.checkbox(cached_language.hide_rose_illusion,
			cached_config.settings.hide_rose_illusion);
		config_changed = config_changed or changed;
		enemy_filters_changed = enemy_filters_changed or changed;

		changed, cached_config.settings.hide_miranda_crows = imgui.checkbox(cached_language.hide_miranda_crows,
			cached_config.settings.hide_miranda_crows);
		config_changed = config_changed or changed;
		enemy_filters_changed = enemy_filters_changed or changed;

		changed, cached_config.settings.hide_ethan_dlc = imgui.checkbox(cached_language.hide_ethan_in_dlc,
			cached_config.settings.hide_ethan_dlc);
		config_changed = config_changed or changed;
		enemy_filters_changed = enemy_filters_changed or changed;

		imgui.end_rect(5);
		imgui.new_line();
		imgui.begin_rect()

		changed, cached_config.settings.opacity_falloff = imgui.checkbox(cached_language.opacity_falloff,
			cached_config.settings.opacity_falloff);
		config_changed = config_changed or changed;

		changed, cached_config.settings.max_distance = imgui.drag_float(cached_language.max_distance,
			cached_config.settings.max_distance, 1, 0, 10000, "%.0f");
		config_changed = config_changed or changed;

		changed, cached_config.settings.scope_opacity_falloff = imgui.checkbox(cached_language.opacity_Falloff_scope,
			cached_config.settings.scope_opacity_falloff);
		config_changed = config_changed or changed;

		changed, cached_config.settings.scope_max_distance = imgui.drag_float(cached_language.max_distance_scope,
			cached_config.settings.scope_max_distance, 1, 0, 10000, "%.0f");
		config_changed = config_changed or changed;

		imgui.end_rect(5);
		imgui.new_line();
		imgui.begin_rect()

		changed, cached_config.settings.apply_time_duration_on_aiming = imgui.checkbox(cached_language.apply_time_duration_on_aiming,
			cached_config.settings.apply_time_duration_on_aiming);
		config_changed = config_changed or changed;

		changed, cached_config.settings.apply_time_duration_on_aim_target = imgui.checkbox(cached_language.apply_time_duration_on_aim_target,
			cached_config.settings.apply_time_duration_on_aim_target);
		config_changed = config_changed or changed;

		changed, cached_config.settings.apply_time_duration_on_using_scope = imgui.checkbox(cached_language.apply_time_duration_on_using_scope,
			cached_config.settings.apply_time_duration_on_using_scope);
		config_changed = config_changed or changed;

		changed, cached_config.settings.apply_time_duration_on_damage_dealt = imgui.checkbox(cached_language.apply_time_duration_on_damage_dealt,
			cached_config.settings.apply_time_duration_on_damage_dealt);
		config_changed = config_changed or changed;

		changed, cached_config.settings.reset_time_duration_on_aim_target_for_everyone = imgui.checkbox(cached_language.reset_time_duration_on_aim_target_for_everyone,
			cached_config.settings.reset_time_duration_on_aim_target_for_everyone);
		config_changed = config_changed or changed;

		changed, cached_config.settings.reset_time_duration_on_damage_dealt_for_everyone = imgui.checkbox(cached_language.reset_time_duration_on_damage_dealt_for_everyone,
			cached_config.settings.reset_time_duration_on_damage_dealt_for_everyone);
		config_changed = config_changed or changed;

		changed, cached_config.settings.time_duration = imgui.drag_float(cached_language.time_duration,
			cached_config.settings.time_duration, 0.1, 0, 1000, "%.1f");

		imgui.end_rect(5);
		imgui.new_line();
		
		imgui.tree_pop();
	end

	if imgui.tree_node(cached_language.world_offset) then
		changed, cached_config.world_offset.x = imgui.drag_float(cached_language.x,
			cached_config.world_offset.x, 0.01, -10, 10, "%.2f");

		config_changed = config_changed or changed;

		changed, cached_config.world_offset.y = imgui.drag_float(cached_language.y,
			cached_config.world_offset.y, 0.01, -10, 10, "%.2f");

		config_changed = config_changed or changed;

		changed, cached_config.world_offset.z = imgui.drag_float(cached_language.z,
				cached_config.world_offset.z, 0.01, -10, 10, "%.2f");

		config_changed = config_changed or changed;

		imgui.tree_pop();
	end

	changed = label_customization.draw(cached_language.health_value_label, cached_config.health_value_label);
	config_changed = config_changed or changed;
	
	changed = bar_customization.draw(cached_language.health_bar, cached_config.health_bar);
	config_changed = config_changed or changed;

	changed = this.draw_debug();
	config_changed = config_changed or changed;
	
	imgui.end_window();
	imgui.pop_font();

	if timer_delays_changed then
		time.init_global_timers();
	end

	if language_changed then
		cached_config.language = language.language_names[language_index];
		language.update(language_index);
		this.init();

		this.reload_font();
	end

	if menu_font_changed then
		this.reload_font();
	end

	if enemy_filters_changed then
		for enemy_core, enemy in pairs(enemy_handler.enemy_list) do
			enemy_handler.update_is_filtered_out(enemy);
		end
	end

	if config_changed or language_changed or window_changed then
		config.save();
	end
end

function this.draw_debug()
	local cached_config = config.current_config.debug;

	local changed = false;
	local config_changed = false;

	if imgui.tree_node(language.current_language.customization_menu.debug) then
		
		imgui.text_colored(string.format("%s:", language.current_language.customization_menu.current_time), 0xFFAAAA66);
		imgui.same_line();
		imgui.text(string.format("%.3fs", time.total_elapsed_script_seconds));

		if error_handler.is_empty then
			imgui.text(language.current_language.customization_menu.everything_seems_to_be_ok);
		else
			for error_key, error in pairs(error_handler.list) do

				imgui.button(string.format("%.3fs", error.time));
				imgui.same_line();
				imgui.text_colored(error_key, 0xFFAA66AA);
				imgui.same_line();
				imgui.text(error.message);
			end
		end

		if imgui.tree_node(language.current_language.customization_menu.history) then

			changed, cached_config.history_size = imgui.drag_int(
				language.current_language.customization_menu.history_size, cached_config.history_size, 1, 0, 1024);

			config_changed = config_changed or changed;

			if changed then
				error_handler.history = {};
			end

			for index, error in pairs(error_handler.history) do
				imgui.text_colored(index, 0xFF66AA66);
				imgui.same_line();
				imgui.button(string.format("%.3fs", error.time));
				imgui.same_line();
				imgui.text_colored(error.key, 0xFFAA66AA);
				imgui.same_line();
				imgui.text(error.message);
			end


			imgui.tree_pop();
		end

		imgui.tree_pop();
	end

	return config_changed;
end

function this.init_module()
	utils = require("Health_Bars.utils");
	config = require("Health_Bars.config");
	language = require("Health_Bars.language");
	label_customization = require("Health_Bars.label_customization");
	bar_customization = require("Health_Bars.bar_customization");
	time = require("Health_Bars.time");
	enemy_handler = require("Health_Bars.enemy_handler");
	error_handler = require("Health_Bars.error_handler");

	this.init();
	this.reload_font();
end

return this;