local this = {};

local modules = require("Health_Bars.modules");

this.current_language = {};

--[[
	EXAMPLE: 
	unicode_glyph_ranges = {
		0x0020, 0x00FF, -- Basic Latin + Latin Supplement
		0x2000, 0x206F, -- General Punctuation
		0x3000, 0x30FF, -- CJK Symbols and Punctuations, Hiragana, Katakana
		0x31F0, 0x31FF, -- Katakana Phonetic Extensions
		0x4e00, 0x9FAF, -- CJK Ideograms
		0xFF00, 0xFFEF, -- Half-width characters
		0
	},
]]

this.default_language = {
	font_name = "",
	unicode_glyph_ranges = {0},
	
	customization_menu = {
		mod_name = "Health Bars";

		enabled = "Enabled",
		reset_config = "Reset Config",

		menu_font_change_disclaimer = "Changing Language and Menu Font Size several times will cause a crash!",
		language = "Language",

		global_modifiers = "Global Modifiers",
		size_modifier = "Size Modifier",
		scale_size_modifier_with_resolution = "Scale Size Modifier with Resolution",
		position_modifier = "Position Modifier",
		scale_position_modifier_with_resolution = "Scale Position Modifier with Resolution",

		size_scale_modifier = "Size Scale Modifier",
		scale_with_reframework_font_size = "Scale with REFramework Font Size",

		ui_font = "UI Font",
		menu_font = "Menu Font",
		font_notice = "Any changes to the font require script reload!",
		family = "Family",
		bold = "Bold",
		italic = "Italic",

		settings = "Settings",

		timer_delays = "Timer Delays",

		update_singletons_delay = "Update Singletons (sec)",
		update_window_size_delay = "Update Window Size (sec)",
		update_game_data_delay = "Update Game Data (sec)",
		update_player_data_delay = "Update Player Data (sec)",
		update_enemy_data_delay = "Update Enemy Data (sec)",

		use_d2d_renderer_if_available = "Use Direct2D Renderer if Available",

		render_during_cutscenes = "Render during Cutscenes",
		render_when_game_timer_is_paused = "Render when Game Timer is Paused",
		render_in_mercenaries = "Render in Mercenaries",
		render_in_house_benevientos_basement = "Render in House Beneviento's Basement",

		render_aim_target_enemy = "Render Aim Target Enemy",
		render_damaged_enemies = "Render Damaged Enemies",
		render_everyone_else = "Render Everyone Else",
		
		render_when_normal = "Render when Normal",
		render_when_aiming = "Render when Aiming",
		render_when_using_scope = "Render when using Scope",

		hide_if_dead = "Hide if Dead",
		hide_if_full_health = "Hide if Full Health",
		hide_if_enemy_model_is_not_being_rendered = "Hide if Enemy Model is not being Rendered",
		hide_if_no_update_function_is_being_called = "Hide if No Update Function is Being Called",
		hide_if_player_cant_take_damage = "Hide if Player can't take Damage",
		hide_if_player_cant_use_items = "Hide if Player can't use Items",

		hide_leonardo = "Hide Leonardo",
		hide_duke = "Hide Duke",

		hide_blue_bird = "Hide Blue Bird",
		hide_pigs = "Hide Pigs",
		hide_chickens = "Hide Chickens",
		hide_goats = "Hide Goats",
		hide_fish = "Hide Fish",
		hide_catfish = "Hide Catfish",
		
		hide_rose_copies = "Hide Rose Copies",
		hide_masked_duke = "Hide Masked Duke",
		hide_mia_dolls = "Hide Mia Dolls",
		hide_dolls = "Hide Dolls",
		hide_rose_illusion = "Hide Rose Illusion",
		hide_miranda_crows = "Hide Miranda Crows",
		hide_ethan_in_dlc = "Hide Ethan in DLC",

		hide_urias = "Hide Uriaș",
		hide_urias_drac = "Hide Uriaș Drac",
		hide_urias_strajer = "Hide Uriaș Străjer",
		hide_bela = "Hide Bela",
		hide_bela_invincible = "Hide Bela (Invincible)",
		hide_cassandra = "Hide Cassandra",
		hide_cassandra_invincible = "Hide Cassandra (Invincible)",
		hide_daniela = "Hide Daniela",
		hide_daniela_invincible = "Hide Daniela (Invincible)",
		hide_dimitrescu_chasing = "Hide Dimitrescu (Chasing)",
		hide_dimitrescu_boss = "Hide Dimitrescu (Boss)",
		hide_angie = "Hide Angie",
		hide_varcolac = "Hide Vârcolac",
		hide_varcolac_alfa = "Hide Vârcolac Alfa",
		hide_moreau = "Hide Moreau",
		hide_sturm = "Hide Sturm",
		hide_heisenberg = "Hide Heisenberg",
		hide_executioner = "Hide Executioner",
		hide_miranda = "Hide Miranda",
		hide_miranda_in_dlc = "Hide Miranda in DLC",

		opacity_falloff = "Opacity Falloff",
		max_distance = "Max Distance",
		opacity_Falloff_scope = "Opacity Falloff (Scope)",
		max_distance_scope = "Max Distance (Scope)",

		apply_time_duration_on_aiming = "Apply Time Duration on Aiming",
		apply_time_duration_on_aim_target = "Apply Time Duration on Aim Target",
		apply_time_duration_on_using_scope = "Apply Time Duration on using Scope",
		apply_time_duration_on_damage_dealt = "Apply Time Duration on Damage Dealt",
		reset_time_duration_on_aim_target_for_everyone = "Reset Time Duration on Aim Target for Everyone",
		reset_time_duration_on_damage_dealt_for_everyone = "Reset Time Duration on Damage Dealt for Everyone",
		time_duration = "Time Duration (sec)",

		dynamic_ui = "Dynamic UI",
		boss_ui = "Boss UI",

		world_offset = "World Offset",
		x = "X",
		y = "Y",
		z = "Z",

		position = "Position",
        anchor = "Anchor",
		spacing = "Spacing",
		
		alignment = "Alignment",
		top_left = "Top-Left",
		top_middle = "Top-Middle",
		top_right = "Top-Right",
		middle_left = "Middle-Left",
		middle_right = "Middle-Right",
		bottom_left = "Bottom-Left",
		bottom_middle = "Bottom-Middle",
		bottom_right = "Bottom-Right",

		name_label = "Name Label",

		health = "Health",
		value_label = "Value Label",
		percentage_label = "Percentage Label",
		bar = "Bar",

		visible = "Visible",

		include = "Include",
		current_value = "Current Value",
		max_value = "Max Value",
		
		offset = "Offset",
		color = "Color",
		shadow = "Shadow",

		fill_direction = "Fill Direction",
		left_to_right = "Left to Right",
		right_to_left = "Right to Left",
		top_to_bottom = "Top to Bottom",
		bottom_to_top = "Bottom to Top",

		inverted = "Inverted",

		size = "Size",
		width = "Width",
		height = "Height",

		outline = "Outline",
		thickness = "Thickness",
		style = "Style",
		inside = "Inside",
		center = "Center",
		outside = "Outside",

		colors = "Colors",
		foreground = "Foreground",
		background = "Background",

		debug = "Debug",
		current_time = "Current Time",
		everything_seems_to_be_ok = "Everything seems to be OK!",
		history = "History",
		history_size = "History Size",
	},

	ui = {
		urias = "Uriaș",
		urias_drac = "Uriaș Drac",
		urias_strajer = "Uriaș Străjer",
		bela = "Bela",
		cassandra = "Cassandra",
		daniela = "Daniela",
		dimitrescu = "Dimitrescu",
		angie = "Angie",
		varcolac = "Vârcolac",
		varcolac_alfa = "Vârcolac Alfa",
		moreau = "Moreau",
		sturm = "Sturm",
		heisenberg = "Heisenberg",
		executioner = "Executioner",
		miranda = "Miranda",
	}
};

this.language_folder = tostring(this.default_language.customization_menu.mod_name) .. "\\languages\\";
this.mod_name_underscore = this.default_language.customization_menu.mod_name:gsub(" ", "_");
this.language_names = { "default" };
this.languages = { this.default_language };

function this.load()
	local language_files = modules.reframework_globals.fs.glob([[Health Bars\\languages\\.*json]]);

	if language_files == nil then
		return;
	end

	for i, language_file_name in ipairs(language_files) do

		local language_name = language_file_name:gsub(this.language_folder, ""):gsub(".json","");

		local loaded_language = modules.reframework_globals.json.load_file(language_file_name);
		if loaded_language ~= nil then

			modules.log.info(tostring(language_file_name) .. ".json loaded successfully");
			table.insert(this.language_names, language_name);

			local merged_language = modules.utils.table.merge(this.default_language, loaded_language);
			table.insert(this.languages, merged_language);

			this.save(language_file_name, merged_language);
		else
			modules.log.error("Failed to load " .. tostring(language_file_name) .. ".json");
		end
	end
end

function this.save(file_name, language_table)
	local success = modules.reframework_globals.json.dump_file(file_name, language_table);
	if success then
		modules.log.info(tostring(file_name) .. " saved successfully");
	else
		modules.log.error("Failed to saved " .. tostring(file_name));
	end
end

function this.save_default()
	this.save(this.language_folder .. "en-us.json", this.default_language);
end

function this.update(index)
	this.current_language = this.languages[index];
end

function this.init_module()
	this.save_default();
	this.load();
	this.current_language = this.default_language;
end

return this;
