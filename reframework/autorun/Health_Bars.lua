package.preload[ "Health_Bars.bar_customization" ] = assert( (loadstring or load)( "local this = {};\
\
local utils;\
local config;\
local language;\
local screen;\
local customization_menu;\
\
local sdk = sdk;\
local tostring = tostring;\
local pairs = pairs;\
local ipairs = ipairs;\
local tonumber = tonumber;\
local require = require;\
local pcall = pcall;\
local table = table;\
local string = string;\
local Vector3f = Vector3f;\
local d2d = d2d;\
local math = math;\
local json = json;\
local log = log;\
local fs = fs;\
local next = next;\
local type = type;\
local setmetatable = setmetatable;\
local getmetatable = getmetatable;\
local assert = assert;\
local select = select;\
local coroutine = coroutine;\
local utf8 = utf8;\
local re = re;\
local imgui = imgui;\
local draw = draw;\
local Vector2f = Vector2f;\
local reframework = reframework;\
local os = os;\
\
local outline_styles = {};\
local displayed_outline_styles = {};\
\
local directions = {};\
local displayed_directions = {};\
\
function this.init()\
\9local cached_default_language = language.default_language.customization_menu;\
\9local cached_current_language = language.current_language.customization_menu;\
\
\9outline_styles = {\
\9\9cached_default_language.inside,\
\9\9cached_default_language.center,\
\9\9cached_default_language.outside\
\9};\
\
\9displayed_outline_styles = {\
\9\9cached_current_language.inside,\
\9\9cached_current_language.center,\
\9\9cached_current_language.outside\
\9};\
\
\9directions = {\
\9\9cached_default_language.left_to_right,\
\9\9cached_default_language.right_to_left,\
\9\9cached_default_language.top_to_bottom,\
\9\9cached_default_language.bottom_to_top\
\9};\
\
\9displayed_directions = {\
\9\9cached_current_language.left_to_right,\
\9\9cached_current_language.right_to_left,\
\9\9cached_current_language.top_to_bottom,\
\9\9cached_current_language.bottom_to_top\
\9};\
end\
\
function this.draw(bar_name, bar)\
\9local cached_language = language.current_language.customization_menu;\
\
\9local bar_changed = false;\
\9local changed = false;\
\9local index = 1;\
\
\9if imgui.tree_node(bar_name) then\
\9\9changed, bar.visibility = imgui.checkbox(cached_language.visible, bar.visibility);\
\9\9bar_changed = bar_changed or changed;\
\
\9\9if imgui.tree_node(cached_language.settings) then\
\9\9\9local fill_direction_index = utils.table.find_index(directions, bar.settings.fill_direction);\
\9\9\9changed, fill_direction_index = imgui.combo(cached_language.fill_type, fill_direction_index, displayed_directions);\
\
\9\9\9bar_changed = bar_changed or changed;\
\
\9\9\9if changed then\
\9\9\9\9bar.settings.fill_direction = directions[fill_direction_index];\
\9\9\9end\
\
\9\9\9imgui.tree_pop();\
\9\9end\
\
\9\9if imgui.tree_node(cached_language.offset) then\
\9\9\9changed, bar.offset.x = imgui.drag_float(cached_language.x,\
\9\9\9\9bar.offset.x, 0.1, -screen.width, screen.width, \"%.1f\");\
\9\9\9bar_changed = bar_changed or changed;\
\
\9\9\9changed, bar.offset.y = imgui.drag_float(cached_language.y,\
\9\9\9\9bar.offset.y, 0.1, -screen.height, screen.height, \"%.1f\");\
\9\9\9bar_changed = bar_changed or changed;\
\
\9\9\9imgui.tree_pop();\
\9\9end\
\
\9\9if imgui.tree_node(cached_language.size) then\
\9\9\9changed, bar.size.width = imgui.drag_float(cached_language.width,\
\9\9\9\9bar.size.width, 0.1, 0, screen.width, \"%.1f\");\
\9\9\9bar_changed = bar_changed or changed;\
\
\9\9\9changed, bar.size.height = imgui.drag_float(cached_language.height,\
\9\9\9\9bar.size.height, 0.1, 0, screen.height, \"%.1f\");\
\9\9\9bar_changed = bar_changed or changed;\
\
\9\9\9imgui.tree_pop();\
\9\9end\
\
\9\9if imgui.tree_node(cached_language.outline) then\
\9\9\9changed, bar.outline.visibility = imgui.checkbox(cached_language.visible\
\9\9\9\9, bar.outline.visibility);\
\9\9\9bar_changed = bar_changed or changed;\
\
\9\9\9changed, bar.outline.thickness = imgui.drag_float(cached_language.thickness,\
\9\9\9\9bar.outline.thickness, 0.1, 0, screen.width, \"%.1f\");\
\9\9\9bar_changed = bar_changed or changed;\
\
\9\9\9changed, bar.outline.offset = imgui.drag_float(cached_language.offset,\
\9\9\9\9bar.outline.offset, 0.1, -screen.height, screen.height, \"%.1f\");\
\9\9\9bar_changed = bar_changed or changed;\
\
\
\9\9\9changed, index = imgui.combo(cached_language.style,\
\9\9\9\9utils.table.find_index(outline_styles, bar.outline.style),\
\9\9\9\9displayed_outline_styles);\
\9\9\9bar_changed = bar_changed or changed;\
\
\9\9\9if changed then\
\9\9\9\9bar.outline.style = outline_styles[index];\
\9\9\9end\
\
\9\9\9imgui.tree_pop();\
\9\9end\
\
\9\9if imgui.tree_node(cached_language.colors) then\
\9\9\9if imgui.tree_node(cached_language.foreground) then\
\9\9\9\9changed, bar.colors.foreground = imgui.color_picker_argb(\"\", bar.colors.foreground,\
\9\9\9\9\9customization_menu.color_picker_flags);\
\9\9\9\9bar_changed = bar_changed or changed;\
\
\9\9\9\9imgui.tree_pop();\
\9\9\9end\
\
\9\9\9if imgui.tree_node(cached_language.background) then\
\9\9\9\9changed, bar.colors.background = imgui.color_picker_argb(\"\", bar.colors.background,\
\9\9\9\9\9customization_menu.color_picker_flags);\
\9\9\9\9bar_changed = bar_changed or changed;\
\
\9\9\9\9imgui.tree_pop();\
\9\9\9end\
\
\9\9\9if imgui.tree_node(cached_language.outline) then\
\9\9\9\9changed, bar.colors.outline = imgui.color_picker_argb(\"\", bar.colors.outline,\
\9\9\9\9\9customization_menu.color_picker_flags);\
\9\9\9\9bar_changed = bar_changed or changed;\
\
\9\9\9\9imgui.tree_pop();\
\9\9\9end\
\
\9\9\9imgui.tree_pop();\
\9\9end\
\
\9\9bar_changed = bar_changed or changed;\
\
\9\9imgui.tree_pop();\
\9end\
\
\9return bar_changed;\
end\
\
function this.init_module()\
\9utils = require(\"Health_Bars.utils\");\
\9config = require(\"Health_Bars.config\");\
\9language = require(\"Health_Bars.language\");\
\9screen = require(\"Health_Bars.screen\");\
\9customization_menu = require(\"Health_Bars.customization_menu\");\
end\
\
return this;\
", '@'..".\\Health_Bars\\bar_customization.lua" ) )

package.preload[ "Health_Bars.config" ] = assert( (loadstring or load)( "local this = {};\
local version = \"1.2\";\
\
local utils;\
local language;\
\
local sdk = sdk;\
local tostring = tostring;\
local pairs = pairs;\
local ipairs = ipairs;\
local tonumber = tonumber;\
local require = require;\
local pcall = pcall;\
local table = table;\
local string = string;\
local Vector3f = Vector3f;\
local d2d = d2d;\
local math = math;\
local json = json;\
local log = log;\
local fs = fs;\
local next = next;\
local type = type;\
local setmetatable = setmetatable;\
local getmetatable = getmetatable;\
local assert = assert;\
local select = select;\
local coroutine = coroutine;\
local utf8 = utf8;\
local re = re;\
local imgui = imgui;\
local draw = draw;\
local Vector2f = Vector2f;\
local reframework = reframework;\
local os = os;\
\
this.current_config = nil;\
this.config_file_name = \"Health Bars/config.json\";\
\
this.default_config = {};\
\
function this.init()\
\9this.default_config = {\
\9\9enabled = true,\
\9\9\
\9\9version = this.version,\
\9\9language = \"default\",\
\
\9\9customization_menu = {\
\9\9\9position = {\
\9\9\9\9x = 480,\
\9\9\9\9y = 200\
\9\9\9},\
\
\9\9\9size = {\
\9\9\9\9width = 650,\
\9\9\9\9height = 480\
\9\9\9},\
\
\9\9\9pivot = {\
\9\9\9\9x = 0,\
\9\9\9\9y = 0\
\9\9\9}\
\9\9},\
\
\9\9menu_font = {\
\9\9\9size = 15\
\9\9},\
\
\9\9ui_font = {\
\9\9\9family = \"Consolas\",\
\9\9\9size = 13,\
\9\9\9bold = true,\
\9\9\9italic = false\
\9\9},\
\
\9\9settings = {\
\9\9\9timer_delays = {\
\9\9\9\9update_singletons_delay = 0,\
\9\9\9\9update_window_size_delay = 0,\
\9\9\9\9update_game_data_delay = 0.1,\
\9\9\9\9update_player_data_delay = 0.1,\
\9\9\9\9update_enemy_data_delay = 0.1,\
\9\9\9},\
\9\9\9\
\9\9\9use_d2d_if_available = true,\
\
\9\9\9render_during_cutscenes = false,\
\9\9\9render_when_game_timer_is_paused = false,\
\9\9\9render_in_mercenaries = false,\
\
\9\9\9render_aim_target_enemy = true,\
\9\9\9render_damaged_enemies = true,\
\9\9\9render_everyone_else = true,\
\
\9\9\9render_when_normal = true,\
\9\9\9render_when_aiming = true,\
\9\9\9render_when_using_scope = true,\
\
\9\9\9hide_if_dead = true,\
\9\9\9hide_if_full_health = true,\
\9\9\9hide_if_enemy_model_is_not_being_rendered = true,\
\9\9\9hide_if_no_update_function_is_being_called = true,\
\
\9\9\9hide_leonardo = false,\
\9\9\9hide_duke = true,\
\
\9\9\9hide_blue_bird = true,\
\9\9\9hide_pigs = true,\
\9\9\9hide_chickens = true,\
\9\9\9hide_goats = true,\
\9\9\9hide_fish = true,\
\9\9\9hide_catfish = true,\
\9\9\9\
\9\9\9hide_rose_copies = false,\
\9\9\9hide_masked_duke = true,\
\9\9\9hide_mia_dolls = true,\
\9\9\9hide_dolls = true,\
\9\9\9hide_rose_illusion = false,\
\9\9\9hide_miranda_crows = true,\
\9\9\9hide_ethan_dlc = true,\
\
\9\9\9opacity_falloff = true,\
\9\9\9max_distance = 30,\
\9\9\9scope_opacity_falloff = true,\
\9\9\9scope_max_distance = 300,\
\
\9\9\9apply_time_duration_on_aiming = false,\
\9\9\9apply_time_duration_on_aim_target = false,\
\9\9\9apply_time_duration_on_using_scope = false,\
\9\9\9apply_time_duration_on_damage_dealt = false,\
\9\9\9reset_time_duration_on_aim_target_for_everyone = true,\
\9\9\9reset_time_duration_on_damage_dealt_for_everyone = true,\
\9\9\9time_duration = 15,\
\9\9},\
\
\9\9world_offset = {\
\9\9\9x = 0,\
\9\9\9y = 0.35,\
\9\9\9z = 0\
\9\9},\
\
\9\9health_value_label = {\
\9\9\9visibility = true,\
\
\9\9\9settings = {\
\9\9\9\9right_alignment_shift = 11\
\9\9\9},\
\
\9\9\9include = {\
\9\9\9\9current_value = true,\
\9\9\9\9max_value = true\
\9\9\9},\
\
\9\9\9text_format = \"%s\", -- current_health/max_health\
\
\9\9\9offset = {\
\9\9\9\9x = -20,\
\9\9\9\9y = 0\
\9\9\9},\
\9\9\9\
\9\9\9color = 0xFFFFFCC0,\
\
\9\9\9shadow = {\
\9\9\9\9visibility = true,\
\9\9\9\9offset = {\
\9\9\9\9\9x = 1,\
\9\9\9\9\9y = 1\
\9\9\9\9},\
\9\9\9\9color = 0xFF000000\
\9\9\9}\
\9\9},\
\
\9\9health_bar = {\
\9\9\9visibility = true,\
\
\9\9\9settings = {\
\9\9\9\9fill_direction = \"Left to Right\"\
\9\9\9},\
\
\9\9\9offset = {\
\9\9\9\9x = -64,\
\9\9\9\9y = 0\
\9\9\9},\
\
\9\9\9size = {\
\9\9\9\9width = 128,\
\9\9\9\9height = 8\
\9\9\9},\
\
\9\9\9outline = {\
\9\9\9\9visibility = true,\
\9\9\9\9thickness = 2.5,\
\9\9\9\9offset = 0,\
\9\9\9\9style = \"Outside\"\
\9\9\9},\
\
\9\9\9colors = {\
\9\9\9\9foreground = 0x80A0FF71,\
\9\9\9\9background = 0x48000000,\
\9\9\9\9outline = 0x68000000\
\9\9\9}\
\9\9},\
\
\9\9debug = {\
\9\9\9history_size = 64\
\9\9}\
\9};\
end\
\
function this.load()\
\9local loaded_config = json.load_file(this.config_file_name);\
\9if loaded_config ~= nil then\
\9\9log.info(\"[Health Bars] config.json loaded successfully\");\
\9\9this.current_config = utils.table.merge(this.default_config, loaded_config);\
\9else\
\9\9log.error(\"[Health Bars] Failed to load config.json\");\
\9\9this.current_config = utils.table.deep_copy(this.default_config);\
\9end\
end\
\
function this.save()\
\9-- save current config to disk, replacing any existing file\
\9local success = json.dump_file(this.config_file_name, this.current_config);\
\9if success then\
\9\9log.info(\"[Health Bars] config.json saved successfully\");\
\9else\
\9\9log.error(\"[Health Bars] Failed to save config.json\");\
\9end\
end\
\
function this.reset()\
\9this.current_config = utils.table.deep_copy(this.default_config);\
\9this.current_config.version = version;\
end\
\
function this.init_module()\
\9utils = require(\"Health_Bars.utils\");\
\9language = require(\"Health_Bars.language\");\
\
\9this.init();\
\9this.load();\
\9this.current_config.version = version;\
\
\9language.update(utils.table.find_index(language.language_names, this.current_config.language));\
end\
\
return this;\
", '@'..".\\Health_Bars\\config.lua" ) )

package.preload[ "Health_Bars.core.enemy_handler" ] = assert( (loadstring or load)( "local this = {};\
\
local modules = require(\"Health_Bars.modules\");\
\
this.enemy_list = {};\
this.enemy_owner_list = {};\
\
local minimal_update_time = 0.6;\
\
local lowest_position = modules.reframework_globals.Vector3f.new(0, -1000000, 0);\
\
local executioner_enemy_core = nil;\
\
local enemy_core_type_def = modules.reframework_globals.sdk.find_type_definition(\"app.EnemyCore\");\
local enemy_core_update_method = enemy_core_type_def:get_method(\"update\");\
local enemy_core_on_damage_method = enemy_core_type_def:get_method(\"onDamage\"); -- Possible alternative: app.CharacterCore.sendAttackHitResult()\
local enemy_core_on_die_method = enemy_core_type_def:get_method(\"onDie\");\
local enemy_core_destroy_method = enemy_core_type_def:get_method(\"destroy\");\
local enemy_core_get_owner_method = enemy_core_type_def:get_method(\"get_owner\");\
local enemy_core_on_warp_method = enemy_core_type_def:get_method(\"onWarp\");\
local enemy_core_restart_method = enemy_core_type_def:get_method(\"restart\");\
local enemy_core_damage_controller_field = enemy_core_type_def:get_field(\"DamageController\");\
local enemy_core_character_status_field = enemy_core_type_def:get_field(\"CharacterStatus\");\
\
local em_1370_core_type_def = modules.reframework_globals.sdk.find_type_definition(\"app.Em1370.Em1370Core\");\
local get_stabbed_status_method = em_1370_core_type_def:get_method(\"get_stabbedStatus\");\
local update_sub_scenario_num_method = em_1370_core_type_def:get_method(\"updateSubScenarioNum\");\
local request_dead_clip_start_method = em_1370_core_type_def:get_method(\"requestDeadClipStart\");\
\
local damage_controller_type_def = enemy_core_damage_controller_field:get_type();\
local get_health_method = damage_controller_type_def:get_method(\"get_health\");\
local get_max_health_method = damage_controller_type_def:get_method(\"get_maxHealth\");\
\
local enemy_status_type_def = modules.reframework_globals.sdk.find_type_definition(\"app.EnemyStatus\");\
local get_is_visible_method = enemy_status_type_def:get_method(\"get_isVisible\");\
\
local game_object_type_def = modules.reframework_globals.sdk.find_type_definition(\"via.GameObject\");\
local get_name_method = game_object_type_def:get_method(\"get_Name\");\
local get_transform_method = game_object_type_def:get_method(\"get_Transform\");\
\
local transform_type_def = get_transform_method:get_return_type();\
local get_joint_by_name_method = transform_type_def:get_method(\"getJointByName\");\
\
local joint_type_def = get_joint_by_name_method:get_return_type();\
local get_position_method = joint_type_def:get_method(\"get_Position\");\
\
local em_1260_core_type_def = modules.reframework_globals.sdk.find_type_definition(\"app.Em1260.Em1260Core\");\
local my_status_em_1260_field = em_1260_core_type_def:get_field(\"MyStatus\");\
\
local em_1260_status_type_def = modules.reframework_globals.sdk.find_type_definition(\"app.Em1260.Em1260Status\");\
local get_is_in_cold_area_method = em_1260_status_type_def:get_method(\"get_isInColdArea\");\
\
\
\
-- DLC\
\
-- Executioner Boss\
local em_1600_core_type_def = modules.reframework_globals.sdk.find_type_definition(\"app.Em1600.Em1600Core\");\
local em_1600_core_on_core_damage_method = em_1600_core_type_def:get_method(\"onCoreDamage\");\
local em_1600_core_on_core_die_method = em_1600_core_type_def:get_method(\"onCoreDie\");\
local core_list_field = em_1600_core_type_def:get_field(\"CoreList\");\
\
local core_list_type_def = core_list_field:get_type();\
local core_list_get_count_method = core_list_type_def:get_method(\"get_Count\");\
local core_list_get_item_method = core_list_type_def:get_method(\"get_Item\");\
\
local em_1600_core_controller_type_def = modules.reframework_globals.sdk.find_type_definition(\"app.Em1600.Em1600CoreController\");\
local em_1600_core_controller_update_core_method = em_1600_core_controller_type_def:get_method(\"updateCore\");\
local em_1600_core_controller_is_permit_open_core_field = em_1600_core_controller_type_def:get_field(\"<isPermitOpenCore>k__BackingField\");\
local em_1600_core_controller_is_dead_field = em_1600_core_controller_type_def:get_field(\"<isDead>k__BackingField\");\
local em_1600_core_controller_damage_controller_field = em_1600_core_controller_type_def:get_field(\"DamageController\");\
\
function this.get_vital_state_name(index)\
\9for state_name, state_index in pairs(this.vital_states) do\
\9\9if state_index == index then\
\9\9\9return state_name;\
\9\9end\
\9end\
\
\9return \"None\";\
end\
\
function this.new(enemy_core)\
\9local enemy = {};\
\9enemy.enemy_core = enemy_core;\
\
\9enemy.is_initialized = false;\
\
\9enemy.health = -1;\
\9enemy.max_health = -100;\
\9enemy.health_percentage = 0;\
\9enemy.is_dead = false;\
\
\9enemy.is_dimitrescu_daughter_in_cold_area = false;\
\9enemy.angie_stabbed_count = 0;\
\
\
\9enemy.is_visible = false;\
\9enemy.is_filtered_out = false;\
\9enemy.is_boss_filtered_out = false;\
\
\9enemy.position = lowest_position;\
\9enemy.distance = 0;\
\
\9enemy.first_update_time = 0;\
\9enemy.last_reset_time = 0;\
\9enemy.last_update_time = 0;\
\
\9enemy.owner = nil;\
\
\9enemy.type = enemy.enemy_core:get_type_definition():get_name();\
\
\9enemy.is_duke = enemy.type == \"Em4070Core\"; -- works normally\
\9\
\9enemy.is_urias_type = enemy.type == \"Em1060Core\"; -- works normally\
\9enemy.is_leonardo = enemy.type == \"Em1360Core\";\
\9enemy.is_dimitrescu_daughter_type = enemy.type == \"Em1260Core\";\
\9enemy.is_dimitrescu = enemy.type == \"Em1000Core\";\
\9enemy.is_dimitrescu_boss = enemy.type == \"Em1230Core\";\
\9enemy.is_angie = enemy.type == \"Em1370Core\";\
\9enemy.is_baby = enemy.type == \"Em1380Core\";\
\9enemy.is_varcolac_type = enemy.type == \"Em1280Core\";\
\9enemy.is_mutated_moreau = enemy.type == \"Em1301Core\"; -- no coordinates\
\9enemy.is_moreau_boss = enemy.type == \"Em1302Core\";\
\9enemy.is_sturm = enemy.type == \"Em1040Core\"; -- works normally\
\9enemy.is_heisenberg_boss = enemy.type == \"Em1310Core\";\
\9enemy.is_miranda_boss = enemy.type == \"Em1320Core\";\
\
\9enemy.is_blue_bird = enemy.type == \"Em3000Core\";\
\9enemy.is_pig = enemy.type == \"Em3020Core\";\
\9enemy.is_chicken = enemy.type == \"Em3070Core\";\
\9enemy.is_goat = enemy.type == \"Em3080Core\";\
\9enemy.is_fish = enemy.type == \"Em3090Core\";\
\9enemy.is_catfish = enemy.type == \"Em3100Core\";\
\
\9enemy.is_k = enemy.type == \"Em4470Core\";\
\9enemy.is_rose_copy = enemy.type == \"Em4440Core\";\
\9enemy.is_masked_duke = enemy.type == \"Em4450Core\";\
\9enemy.is_executioner = enemy.type == \"Em1600Core\";\
\9enemy.is_mia_doll = enemy.type == \"Em1400Core\";\
\9enemy.is_doll = enemy.type == \"Em1390Core\";\
\9enemy.is_eveline = enemy.type == \"Em1800Core\";\
\9enemy.is_eveline_doll = enemy.type == \"Em1810Core\";\
\9enemy.is_miranda_crow = enemy.type == \"Em3002Core\";\
\9enemy.is_rose_illusion = enemy.type == \"Em4490Core\";\
\9enemy.is_miranda_boss_dlc = enemy.type == \"Em1900Core\";\
\9enemy.is_ethan_dlc = enemy.type == \"Em4460Core\";\
\
\9enemy.is_urias = false;\
\9enemy.is_urias_drac = false;\
\9enemy.is_urias_strajer = false;\
\
\9enemy.is_bela = false;\
\9enemy.is_cassandra = false;\
\9enemy.is_daniela = false;\
\
\9enemy.is_varcolac = false;\
\9enemy.is_varcolac_alfa = false;\
\
\9enemy.is_always_visible =\
\9\9enemy.is_dimitrescu_boss\
\9\9-- or enemy.is_angie\
\9\9-- or enemy.is_baby\
\9\9-- or enemy.is_mutated_moreau\
\9\9or enemy.is_moreau_boss\
\9\9or enemy.is_heisenberg_boss\
\9\9or enemy.is_miranda_boss\
\9\9\
\9\9or enemy.is_blue_bird\
\9\9or enemy.is_pig\
\9\9or enemy.is_chicken\
\9\9or enemy.is_goat\
\9\9or enemy.is_fish\
\9\9or enemy.is_catfish\
\
\9\9or enemy.is_k\
\9\9or enemy.is_rose_copy\
\9\9or enemy.is_masked_duke\
\9\9or enemy.is_executioner\
\9\9or enemy.is_mia_doll\
\9\9or enemy.is_doll\
\9\9or enemy.is_eveline\
\9\9or enemy.is_miranda_crow\
\9\9or enemy.is_rose_illusion\
\9\9or enemy.is_miranda_boss_dlc\
\9\9or enemy.is_ethan_dlc\
\9\9or enemy.is_miranda_boss_dlc;\
\
\9this.update_health(enemy);\
\
\9if enemy.health == -1 or enemy.max_health == -1 then\
\9\9return nil;\
\9end\
\
\9this.update_owner(enemy);\
\9this.update_urias_type(enemy)\
\9this.update_dimitrescu_daughter_type(enemy);\
\9this.update_varcolac_type(enemy);\
\9this.update_head_joint(enemy);\
\9this.update_position(enemy);\
\9this.update_is_visible(enemy);\
\9this.update_is_filtered_out(enemy);\
\9this.update_is_boss_filtered_out(enemy);\
\9this.update_angie_stabbed_count(enemy);\
\
\9enemy.is_boss =\
\9\9enemy.is_urias\
\9\9or enemy.is_urias_drac\
\9\9or enemy.is_urias_strajer\
\9\9or enemy.is_dimitrescu_daughter_type\
\9\9or enemy.is_bela\
\9\9or enemy.is_cassandra\
\9\9or enemy.is_daniela\
\9\9or enemy.is_dimitrescu\
\9\9or enemy.is_dimitrescu_boss\
\9\9or enemy.is_angie\
\9\9or enemy.is_varcolac\
\9\9or enemy.is_varcolac_alfa\
\9\9or enemy.is_moreau_boss\
\9\9or enemy.is_sturm\
\9\9or enemy.is_heisenberg_boss\
\9\9or enemy.is_executioner\
\9\9or enemy.is_miranda_boss\
\9\9or enemy.is_miranda_boss_dlc;\
\
\9\9enemy.is_scripted_death_boss =\
\9\9\9enemy.is_dimitrescu\
\9\9\9or enemy.is_dimitrescu_boss\
\9\9\9or enemy.is_moreau_boss\
\9\9\9or enemy.is_heisenberg_boss;\
\
\9this.enemy_list[enemy_core] = enemy;\
\9\
\9return enemy;\
end\
\
function this.get_enemy(enemy_core)\
\9local enemy = this.enemy_list[enemy_core];\
\9if enemy == nil then\
\9\9enemy = this.new(enemy_core);\
\9end\
\9\
\9return enemy;\
end\
\
function this.get_enemy_null(enemy_core, create_if_not_found)\
\9if create_if_not_found == nil then\
\9\9create_if_not_found = true;\
\9end\
\
\9local enemy = this.enemy_list[enemy_core];\
\9if enemy == nil and create_if_not_found then\
\9\9enemy = this.new(enemy_core);\
\9end\
\
\9return enemy;\
end\
\
function this.update_health(enemy)\
\9if enemy == nil then\
\9\9modules.error_handler.report(\"enemy.update_health\", \"No Enemy\");\
\9\9return;\
\9end\
\
\9if enemy.is_executioner then\
\9\9local is_core = this.update_core_health_executioner(enemy);\
\9\9\
\9\9if is_core then\
\9\9\9return;\
\9\9end\
\9end\
\
\9local damage_controller = enemy_core_damage_controller_field:get_data(enemy.enemy_core);\
\
\9if damage_controller == nil then\
\9\9modules.error_handler.report(\"enemy.update_health\", \"No EnemyDamageController\");\
\9\9return;\
\9end\
\
\9local health = get_health_method:call(damage_controller);\
\9local max_health = get_max_health_method:call(damage_controller);\
\
\9if health == nil then\
\9\9modules.error_handler.report(\"enemy.update_health\", \"No Health\");\
\9else\
\9\9enemy.health = modules.utils.math.round(health);\
\9end\
\
\9if max_health == nil then\
\9\9modules.error_handler.report(\"enemy.update_health\", \"No MaxHealth\");\
\9else\
\9\9enemy.max_health = modules.utils.math.round(max_health);\
\9end\
\
\9if enemy.max_health == 0 then\
\9\9enemy.health_percentage = 0;\
\9else\
\9\9enemy.health_percentage = enemy.health / enemy.max_health;\
\9end\
\
\9if enemy.is_boss and not enemy.is_scripted_death_boss and enemy.health < 1.1 then\
\9\9enemy.is_dead = true;\
\9end\
end\
\
function this.update_core_health_executioner(enemy)\
\9local is_core = false;\
\
\9local core_list = core_list_field:get_data(enemy.enemy_core);\
\
\9if core_list == nil then\
\9\9modules.error_handler.report(\"enemy.update_core_health_executioner\", \"No Core List\");\
\9\9return is_core;\
\9end\
\
\9local core_list_count = core_list_get_count_method:call(core_list);\
\
\9if core_list_count == nil then\
\9\9modules.error_handler.report(\"enemy.update_core_health_executioner\", \"No Core List Count\");\
\9\9return is_core;\
\9end\
\
\9if core_list_count == 0 then\
\9\9return is_core;\
\9end\
\
\9for i = 0, core_list_count - 1 do\
\9\9local core = core_list_get_item_method:call(core_list, i);\
\
\9\9if core == nil then\
\9\9\9modules.error_handler.report(\"enemy.update_core_health_executioner\", string.format(\"No Core No. %d\", i));\
\9\9\9goto continue;\
\9\9end\
\9\9\
\9\9local is_permit_open_core = em_1600_core_controller_is_permit_open_core_field:get_data(core);\
\9\9\
\9\9if is_permit_open_core == nil then\
\9\9\9modules.error_handler.report(\"enemy.update_core_health_executioner\", string.format(\"No Core No. %d -> is_permit_open_core\", i));\
\9\9\9goto continue;\
\9\9end\
\
\9\9if not is_permit_open_core then\
\9\9\9goto continue;\
\9\9end\
\
\9\9local is_dead = em_1600_core_controller_is_dead_field:get_data(core);\
\9\9\
\9\9if is_dead == nil then\
\9\9\9modules.error_handler.report(\"enemy.update_core_health_executioner\", string.format(\"No Core No. %d -> is_dead\", i));\
\9\9\9goto continue;\
\9\9end\
\
\9\9if is_dead then\
\9\9\9goto continue;\
\9\9end\
\
\9\9local damage_controller = em_1600_core_controller_damage_controller_field:get_data(core);\
\
\9\9if damage_controller == nil then\
\9\9\9modules.error_handler.report(\"enemy.update_core_health_executioner\", string.format(\"No Core No. %d -> Damage Controller\", i));\
\9\9\9goto continue;\
\9\9end\
\
\9\9local health = get_health_method:call(damage_controller);\
\9\9local max_health = get_max_health_method:call(damage_controller);\
\
\9\9if health == nil then\
\9\9\9modules.error_handler.report(\"enemy.update_core_health_executioner\", string.format(\"No Core No. %d -> Health\", i));\
\9\9else\
\9\9\9enemy.health = modules.utils.math.round(health);\
\9\9end\
\
\9\9if max_health == nil then\
\9\9\9modules.error_handler.report(\"enemy.update_core_health_executioner\", string.format(\"No Core No. %d -> Max Health\", i));\
\9\9else\
\9\9\9enemy.max_health = modules.utils.math.round(max_health);\
\9\9end\
\
\9\9if enemy.max_health == 0 then\
\9\9\9enemy.health_percentage = 0;\
\9\9else\
\9\9\9enemy.health_percentage = enemy.health / enemy.max_health;\
\9\9end\
\
\9\9is_core = true;\
\9\9break;\
\
\9\9::continue::\
\9end\
\
\9return is_core;\
end\
\
function this.update_is_visible(enemy)\
\9if enemy == nil then\
\9\9modules.error_handler.report(\"enemy.is_visible\", \"No Enemy\");\
\9\9return;\
\9end\
\
\9local character_status = enemy_core_character_status_field:get_data(enemy.enemy_core);\
\
\9if character_status == nil then\
\9\9modules.error_handler.report(\"enemy.is_visible\", \"No EnemyCharacterStatus\");\
\9\9return;\
\9end\
\
\9local is_visible = get_is_visible_method:call(character_status);\
\
\9if is_visible == nil then\
\9\9modules.error_handler.report(\"enemy.is_visible\", \"No IsVisible\");\
\9\9return;\
\9end\
\
\9enemy.is_visible = is_visible;\
end\
\
function this.update_is_filtered_out(enemy)\
\9local cached_config = modules.config.current_config.dynamic_ui.settings;\
\
\9enemy.is_filtered_out =\
\9\9(cached_config.hide_urias and enemy.is_urias)\
\9\9or (cached_config.hide_urias_drac and enemy.is_urias_drac)\
\9\9or (cached_config.hide_urias_strajer and enemy.is_urias_strajer)\
\9\9or (cached_config.hide_bela and enemy.is_bela and enemy.is_dimitrescu_daughter_in_cold_area)\
\9\9or (cached_config.hide_bela_invincible and enemy.is_bela and not enemy.is_dimitrescu_daughter_in_cold_area)\
\9\9or (cached_config.hide_cassandra and enemy.is_cassandra and enemy.is_dimitrescu_daughter_in_cold_area)\
\9\9or (cached_config.hide_cassandra_invincible and enemy.is_cassandra and not enemy.is_dimitrescu_daughter_in_cold_area)\
\9\9or (cached_config.hide_daniela and enemy.is_daniela and enemy.is_dimitrescu_daughter_in_cold_area)\
\9\9or (cached_config.hide_daniela_invincible and enemy.is_daniela and not enemy.is_dimitrescu_daughter_in_cold_area)\
\9\9or (cached_config.hide_dimitrescu_chasing and enemy.is_dimitrescu)\
\9\9or (cached_config.hide_dimitrescu_boss and enemy.is_dimitrescu_boss)\
\9\9or (cached_config.hide_angie and enemy.is_angie)\
\9\9or (cached_config.hide_varcolac and enemy.is_varcolac)\
\9\9or (cached_config.hide_varcolac_alfa and enemy.is_varcolac_alfa)\
\9\9or (cached_config.hide_moreau and enemy.is_moreau_boss)\
\9\9or (cached_config.hide_sturm and enemy.is_sturm)\
\9\9or (cached_config.hide_heisenberg and enemy.is_heisenberg_boss)\
\9\9or (cached_config.hide_executioner and enemy.is_executioner)\
\9\9or (cached_config.hide_miranda and enemy.is_miranda_boss)\
\9\9or (cached_config.hide_miranda_in_dlc and enemy.is_miranda_boss_dlc)\
\9\9or (cached_config.hide_leonardo and enemy.is_leonardo)\
\9\9or (cached_config.hide_duke and enemy.is_duke)\
\9\9or (cached_config.hide_blue_bird and enemy.is_blue_bird)\
\9\9or (cached_config.hide_pigs and enemy.is_pig)\
\9\9or (cached_config.hide_chickens and enemy.is_chicken)\
\9\9or (cached_config.hide_goats and enemy.is_goat)\
\9\9or (cached_config.hide_fish and enemy.is_fish)\
\9\9or (cached_config.hide_catfish and enemy.is_catfish)\
\9\9or (cached_config.hide_rose_copies and enemy.is_rose_copy)\
\9\9or (cached_config.hide_masked_duke and enemy.is_masked_duke)\
\9\9or (cached_config.hide_mia_dolls and enemy.is_mia_doll)\
\9\9or (cached_config.hide_dolls and enemy.is_doll)\
\9\9or (cached_config.hide_rose_illusion and enemy.is_rose_illusion)\
\9\9or (cached_config.hide_miranda_crows and enemy.is_miranda_crow)\
\9\9or (cached_config.hide_ethan_dlc and enemy.is_ethan_dlc);\
end\
\
function this.update_is_boss_filtered_out(enemy)\
\9local cached_config = modules.config.current_config.boss_ui.settings;\
\
\9enemy.is_boss_filtered_out =\
\9\9(cached_config.hide_urias and enemy.is_urias)\
\9\9or (cached_config.hide_urias_drac and enemy.is_urias_drac)\
\9\9or (cached_config.hide_urias_strajer and enemy.is_urias_strajer)\
\9\9or (cached_config.hide_bela and enemy.is_bela and enemy.is_dimitrescu_daughter_in_cold_area)\
\9\9or (cached_config.hide_bela_invincible and enemy.is_bela and not enemy.is_dimitrescu_daughter_in_cold_area)\
\9\9or (cached_config.hide_cassandra and enemy.is_cassandra and enemy.is_dimitrescu_daughter_in_cold_area)\
\9\9or (cached_config.hide_cassandra_invincible and enemy.is_cassandra and not enemy.is_dimitrescu_daughter_in_cold_area)\
\9\9or (cached_config.hide_daniela and enemy.is_daniela and enemy.is_dimitrescu_daughter_in_cold_area)\
\9\9or (cached_config.hide_daniela_invincible and enemy.is_daniela and not enemy.is_dimitrescu_daughter_in_cold_area)\
\9\9or (cached_config.hide_dimitrescu_chasing and enemy.is_dimitrescu)\
\9\9or (cached_config.hide_dimitrescu_boss and enemy.is_dimitrescu_boss)\
\9\9or (cached_config.hide_angie and enemy.is_angie)\
\9\9or (cached_config.hide_varcolac and enemy.is_varcolac)\
\9\9or (cached_config.hide_varcolac_alfa and enemy.is_varcolac_alfa)\
\9\9or (cached_config.hide_moreau and enemy.is_moreau_boss)\
\9\9or (cached_config.hide_sturm and enemy.is_sturm)\
\9\9or (cached_config.hide_heisenberg and enemy.is_heisenberg_boss)\
\9\9or (cached_config.hide_executioner and enemy.is_executioner)\
\9\9or (cached_config.hide_miranda and enemy.is_miranda_boss)\
\9\9or (cached_config.hide_miranda_in_dlc and enemy.is_miranda_boss_dlc)\
\9\9or (not enemy.is_boss);\
end\
\
function this.update_dimitrescu_daughter(enemy)\
\9if enemy == nil then\
\9\9modules.error_handler.report(\"enemy.update_dimitrescu_daughter\", \"No Enemy\");\
\9\9return;\
\9end\
\
\9if not enemy.is_dimitrescu_daughter_type then\
\9\9return;\
\9end\
\
\9local em_1260_status = my_status_em_1260_field:get_data(enemy.enemy_core);\
\9if em_1260_status == nil then\
\9\9modules.error_handler.report(\"enemy.update_dimitrescu_daughter\", \"No em1260Status\");\
\9\9return;\
\9end\
\
\9local is_in_cold_area = get_is_in_cold_area_method:call(em_1260_status);\
\9if is_in_cold_area == nil then\
\9\9modules.error_handler.report(\"enemy.update_dimitrescu_daughter\", \"No IsInColdArea\");\
\9\9return;\
\9end\
\
\9enemy.is_dimitrescu_daughter_in_cold_area = is_in_cold_area;\
end\
\
function this.update_last_reset_time(enemy)\
\9if enemy == nil then\
\9\9modules.error_handler.report(\"enemy.update_last_reset_time\", \"No Enemy\");\
\9\9return;\
\9end\
\9\
\9enemy.last_reset_time = modules.time.total_elapsed_script_seconds;\
end\
\
function this.update_all_positions()\
\9for enemy_core, enemy in pairs(this.enemy_list) do\
\9\9this.update_head_joint(enemy);\
\9\9this.update_position(enemy);\
\9end\
end\
\
function this.update_position(enemy)\
\9if enemy.head_joint == nil then\
\9\9modules.error_handler.report(\"enemy_handler.update_position\", \"No Head Joint\");\
\9\9return;\
\9end\
\
\9local head_joint_position = get_position_method:call(enemy.head_joint);\
\9if head_joint_position == nil then\
\9\9modules.error_handler.report(\"enemy_handler.update_position\", \"No Head Joint Position\");\
\9\9return;\
\9end\
\
\9enemy.position = head_joint_position;\
\9enemy.distance = (modules.player_handler.player.position - head_joint_position):length();\
end\
\
function this.update_all_periodics()\
\9local cached_config = modules.config.current_config.settings.timer_delays;\
\
\9for enemy_core, enemy in pairs(this.enemy_list) do\
\9\9if modules.config.current_config.settings.hide_if_no_update_function_is_being_called and modules.time.total_elapsed_script_seconds - enemy.last_update_time > cached_config.update_enemy_data_delay then\
\9\9\9this.enemy_list[enemy_core] = nil;\
\
\9\9\9for enemy_owner, enemy_in_enemy_owner_list in pairs(this.enemy_owner_list) do\
\9\9\9\9if enemy_in_enemy_owner_list == enemy or (type(enemy_in_enemy_owner_list) == \"table\" and enemy_in_enemy_owner_list.enemy_core == enemy_core) then\
\9\9\9\9\9this.enemy_owner_list[enemy_owner] = nil;\
\9\9\9\9end\
\9\9\9end\
\
\9\9\9goto continue;\
\9\9end\
\
\9\9this.update_is_visible(enemy);\
\9\9this.update_dimitrescu_daughter(enemy);\
\9\9this.update_is_filtered_out(enemy);\
\9\9this.update_is_boss_filtered_out(enemy);\
\9\
\9\9::continue::\
\9end\
end\
\
function this.update_head_joint(enemy)\
\9if enemy.owner == nil then\
\9\9modules.error_handler.report(\"enemy_handler.update_head_joint\", \"No GameObject\");\
\9\9return;\
\9end\
\
\9local enemy_transform = get_transform_method:call(enemy.owner);\
\9if enemy_transform == nil then\
\9\9modules.error_handler.report(\"enemy_handler.update_head_joint\", \"No Transform\");\
\9\9return;\
\9end\
\
\9local joint = get_joint_by_name_method:call(enemy_transform, \"Head_Human\")\
\9or get_joint_by_name_method:call(enemy_transform, \"HumanHead\")\
\9or get_joint_by_name_method:call(enemy_transform, \"Head\")\
\9or get_joint_by_name_method:call(enemy_transform, \"head\")\
\9or get_joint_by_name_method:call(enemy_transform, \"root\");\
\
\9if joint == nil then\
\9\9modules.error_handler.report(\"enemy_handler.update_head_joint\", \"No Head Joint\");\
\9\9return;\
\9end\
\
\9enemy.head_joint = joint;\
end\
\
function this.update_owner(enemy)\
\9if enemy == nil then\
\9\9modules.error_handler.report(\"enemy.update_owner\", \"No Enemy\");\
\9\9return;\
\9end\
\
\9local owner = enemy_core_get_owner_method:call(enemy.enemy_core);\
\
\9if owner == nil then\
\9\9modules.error_handler.report(\"enemy.update_owner\", \"No Enemy Owner\");\
\9\9return;\
\9end\
\
\9enemy.owner = owner;\
\
\9this.enemy_owner_list[owner] = enemy;\
end\
\
function this.update_urias_type(enemy)\
\9if enemy == nil then\
\9\9modules.error_handler.report(\"enemy.update_urias_type\", \"No Enemy\");\
\9\9return;\
\9end\
\
\9if not enemy.is_urias_type then\
\9\9return;\
\9end\
\
\9if enemy.owner == nil then\
\9\9modules.error_handler.report(\"enemy.update_urias_type\", \"No Enemy Owner\");\
\9\9return;\
\9end\
\
\9local owner_name = get_name_method:call(enemy.owner);\
\9if owner_name == nil then\
\9\9modules.error_handler.report(\"enemy.update_urias_type\", \"No Enemy Owner Name\");\
\9\9return;\
\9end\
\
\9if owner_name == \"em1060\" then\
\9\9enemy.is_urias = true;\
\9elseif owner_name == \"em1061\" then\
\9\9enemy.is_urias_strajer = true;\
\9elseif owner_name == \"em1062\" then\
\9\9enemy.is_urias_drac = true;\
\9end\
end\
\
function this.update_dimitrescu_daughter_type(enemy)\
\9if enemy == nil then\
\9\9modules.error_handler.report(\"enemy.update_dimitrescu_daughter_type\", \"No Enemy\");\
\9\9return;\
\9end\
\
\9if not enemy.is_dimitrescu_daughter_type then\
\9\9return;\
\9end\
\
\9if enemy.owner == nil then\
\9\9modules.error_handler.report(\"enemy.update_dimitrescu_daughter_type\", \"No Enemy Owner\");\
\9\9return;\
\9end\
\
\9local owner_name = get_name_method:call(enemy.owner);\
\9if owner_name == nil then\
\9\9modules.error_handler.report(\"enemy.update_dimitrescu_daughter_type\", \"No Enemy Owner Name\");\
\9\9return;\
\9end\
\
\9if owner_name == \"em1260\" then\
\9\9enemy.is_daniela = true;\
\9elseif owner_name == \"em1261\" then\
\9\9enemy.is_cassandra = true;\
\9elseif owner_name == \"em1262\" then\
\9\9enemy.is_bela = true;\
\9end\
end\
\
function this.update_varcolac_type(enemy)\
\9if enemy == nil then\
\9\9modules.error_handler.report(\"enemy.update_varcolac_type\", \"No Enemy\");\
\9\9return;\
\9end\
\
\9if not enemy.is_varcolac_type then\
\9\9return;\
\9end\
\
\9if enemy.owner == nil then\
\9\9modules.error_handler.report(\"enemy.update_varcolac_type\", \"No Enemy Owner\");\
\9\9return;\
\9end\
\
\9local owner_name = get_name_method:call(enemy.owner);\
\9if owner_name == nil then\
\9\9modules.error_handler.report(\"enemy.update_varcolac_type\", \"No Enemy Owner Name\");\
\9\9return;\
\9end\
\
\9if owner_name == \"em1280\" then\
\9\9enemy.is_varcolac = true;\
\9elseif owner_name == \"em1281\" then\
\9\9enemy.is_varcolac_alfa = true;\
\9end\
end\
\
function this.update_angie_stabbed_count(enemy)\
\9if enemy == nil then\
\9\9modules.error_handler.report(\"enemy.update_angie_stabbed_count\", \"No Enemy\");\
\9\9return;\
\9end\
\
\9if not enemy.is_angie then\
\9\9return;\
\9end\
\
\9local stabbed_status = get_stabbed_status_method:call(enemy.enemy_core);\
\9if stabbed_status == nil then\
\9\9modules.error_handler.report(\"enemy.update_angie_stabbed_count\", \"No Stabbed Status\");\
\9\9return;\
\9end\
\
\9enemy.angie_stabbed_count = math.max(1, stabbed_status) - 1;\
\9if enemy.angie_stabbed_count == 3 then\
\9\9enemy.is_dead = true;\
\9end\
end\
\
function this.update_angie_core_stabbed_count(enemy_core)\
\9if enemy_core == nil then\
\9\9modules.error_handler.report(\"enemy.update_angie_core_stabbed_count\", \"No EnemyCore\");\
\9\9return;\
\9end\
\
\9local enemy = this.get_enemy(enemy_core);\
\9if enemy == nil then\
\9\9return;\
\9end\
\
\9this.update_angie_stabbed_count(enemy);\
end\
\
function this.on_angie_core_request_dead_clip_start(enemy_core)\
\9if enemy_core == nil then\
\9\9modules.error_handler.report(\"enemy.increase_angie_stabbed_count\", \"No EnemyCore\");\
\9\9return;\
\9end\
\
\9local enemy = this.get_enemy(enemy_core);\
\9if enemy == nil then\
\9\9return;\
\9end\
\
\9enemy.is_dead = true;\
end\
\
function this.on_update(enemy_core)\
\9if enemy_core == nil then\
\9\9modules.error_handler.report(\"enemy.on_enemy_update\", \"No EnemyCore\");\
\9\9return;\
\9end\
\
\9local enemy = this.get_enemy(enemy_core);\
\9if enemy == nil then\
\9\9return;\
\9end\
\
\9if modules.utils.number.is_equal(enemy.first_update_time, 0) then\
\9\9enemy.first_update_time = modules.time.total_elapsed_script_seconds;\
\9end\
\
\9enemy.last_update_time = modules.time.total_elapsed_script_seconds;\
\
\9if enemy.last_update_time - enemy.first_update_time > minimal_update_time then\
\9\9enemy.is_initialized = true;\
\9end\
end\
\
function this.on_damage(attacked_enemy_core)\
\9local cached_config = modules.config.current_config.settings;\
\
\9if attacked_enemy_core == nil then\
\9\9modules.error_handler.report(\"enemy.on_damage\", \"No EnemyCore\");\
\9\9return;\
\9end\
\
\9local attacked_enemy = this.get_enemy(attacked_enemy_core);\
\
\9if attacked_enemy == nil then\
\9\9return;\
\9end\
\
\9this.update_health(attacked_enemy);\
\
\9if cached_config.reset_time_duration_on_damage_dealt_for_everyone then\
\9\9for enemy_core, enemy in pairs(this.enemy_list) do\
\9\9\9if modules.time.total_elapsed_script_seconds - enemy.last_reset_time < cached_config.time_duration then\
\9\9\9\9this.update_last_reset_time(enemy);\
\9\9\9end\
\9\9end\
\9end\
\9\
\9if cached_config.apply_time_duration_on_damage_dealt then\
\9\9this.update_last_reset_time(attacked_enemy);\
\9end\
end\
\
function this.on_die(enemy_core)\
\9if enemy_core == nil then\
\9\9modules.error_handler.report(\"enemy.on_die\", \"No EnemyCore\");\
\9\9return;\
\9end\
\
\9local enemy = this.get_enemy(enemy_core);\
\
\9if enemy == nil then\
\9\9return;\
\9end\
\
\9this.update_health(enemy);\
\9enemy.is_dead = true;\
end\
\
function this.on_core_damage_executioner(attacked_enemy_core)\
\9local cached_config = modules.config.current_config.settings;\
\
\9if attacked_enemy_core == nil then\
\9\9modules.error_handler.report(\"enemy.on_core_damage_executioner\", \"No EnemyCore\");\
\9\9return;\
\9end\
\
\9local attacked_enemy = this.get_enemy(attacked_enemy_core);\
\
\9if attacked_enemy == nil then\
\9\9return;\
\9end\
\
\9this.update_health(attacked_enemy);\
\
\9if cached_config.reset_time_duration_on_damage_dealt_for_everyone then\
\9\9for enemy_core, enemy in pairs(this.enemy_list) do\
\9\9\9if modules.time.total_elapsed_script_seconds - enemy.last_reset_time < cached_config.time_duration then\
\9\9\9\9this.update_last_reset_time(enemy);\
\9\9\9end\
\9\9end\
\9end\
\9\
\9if cached_config.apply_time_duration_on_damage_dealt then\
\9\9this.update_last_reset_time(attacked_enemy);\
\9end\
end\
\
function this.on_post_core_die_executioner(enemy_core)\
\9if enemy_core == nil then\
\9\9modules.error_handler.report(\"enemy.on_post_core_die_executioner\", \"No EnemyCore\");\
\9\9return;\
\9end\
\
\9local enemy = this.get_enemy(enemy_core);\
\
\9if enemy == nil then\
\9\9return;\
\9end\
\
\9this.update_health(enemy);\
end\
\
function this.on_update_core_executioner(core_controller)\
\9if core_controller == nil then\
\9\9modules.error_handler.report(\"enemy.on_open_core_executioner\", \"No CoreController\");\
\9\9return;\
\9end\
\
\9local core_controller_owner = core_controller:get_owner();\
\
\9if core_controller_owner == nil then\
\9\9modules.error_handler.report(\"enemy.on_open_core_executioner\", \"No CoreControllerOwner\");\
\9\9return;\
\9end\
\
\9local attacked_enemy_core = this.enemy_owner_list[core_controller_owner];\
\
\9if attacked_enemy_core == nil then\
\9\9modules.error_handler.report(\"enemy.on_open_core_executioner\", \"No Attacked EnemyCore\");\
\9\9return;\
\9end\
\
\9this.update_health(attacked_enemy_core);\
end\
\
function this.on_warp(enemy_core)\
\9if enemy_core == nil then\
\9\9modules.error_handler.report(\"enemy.on_warp\", \"No Enemy core\");\
\9\9return;\
\9end\
\
\9local enemy = this.get_enemy_null(enemy_core, false);\
\
\9if enemy == nil then\
\9\9return;\
\9end\
\
\9if enemy.is_boss and not enemy.is_scripted_death_boss then\
\9\9if enemy.health < 1.1 then\
\9\9\9enemy.is_dead = true;\
\9\9end\
\
\9\9return;\
\9end\
\
\9this.update_health(enemy);\
\9enemy.is_dead = modules.utils.number.is_equal(enemy.health, 0);\
end\
\
function this.on_restart(enemy_core)\
\9if enemy_core == nil then\
\9\9modules.error_handler.report(\"enemy.on_restart\", \"No Enemy core\");\
\9\9return;\
\9end\
\
\9local enemy = this.get_enemy(enemy_core);\
\
\9if enemy == nil then\
\9\9return;\
\9end\
\
\9if enemy.is_boss and not enemy.is_scripted_death_boss then\
\9\9if enemy.health < 1.1 then\
\9\9\9enemy.is_dead = true;\
\9\9end\
\
\9\9return;\
\9end\
\
\9this.update_health(enemy);\
\9enemy.is_dead = modules.utils.number.is_equal(enemy.health, 0);\
end\
\
function this.on_destroy(enemy_core)\
\9if enemy_core == nil then\
\9\9modules.error_handler.report(\"enemy.on_destroy\", \"No EnemyCore\");\
\9\9return;\
\9end\
\
\9local destroyed_enemy = this.enemy_list[enemy_core];\
\
\9this.enemy_list[enemy_core] = nil;\
\
\9for enemy_owner, enemy in pairs(this.enemy_owner_list) do\
\9\9if enemy == destroyed_enemy or (type(enemy) == \"table\" and enemy.enemy_core == enemy_core) then\
\9\9\9this.enemy_owner_list[enemy_owner] = nil;\
\9\9end\
\9end\
end\
\
function this.init_module()\
\9modules.reframework_globals.sdk.hook(enemy_core_update_method, function(args)\
\9\9local enemy_core = modules.reframework_globals.sdk.to_managed_object(args[2]);\
\9\9\
\9\9this.on_update(enemy_core);\
\9end, function(retval)\
\9\9return retval;\
\9end);\
\
\9modules.reframework_globals.sdk.hook(enemy_core_on_damage_method, function(args)\
\9\9local enemy_core = modules.reframework_globals.sdk.to_managed_object(args[2]);\
\9\9\
\9\9this.on_damage(enemy_core);\
\9end, function(retval)\
\9\9return retval;\
\9end);\
\
\9modules.reframework_globals.sdk.hook(enemy_core_on_die_method, function(args)\
\9\9local enemy_core = modules.reframework_globals.sdk.to_managed_object(args[2]);\
\9\9\
\9\9this.on_die(enemy_core);\
\9end, function(retval)\
\9\9return retval;\
\9end);\
\
\9modules.reframework_globals.sdk.hook(enemy_core_on_warp_method, function(args)\
\9\9local enemy_core = modules.reframework_globals.sdk.to_managed_object(args[2]);\
\9\9\
\9\9this.on_warp(enemy_core);\
\9end, function(retval)\
\9\9return retval;\
\9end);\
\
\9modules.reframework_globals.sdk.hook(enemy_core_restart_method, function(args)\
\9\9local enemy_core = modules.reframework_globals.sdk.to_managed_object(args[2]);\
\9\9\
\9\9this.on_restart(enemy_core);\
\9end, function(retval)\
\9\9return retval;\
\9end);\
\
\9modules.reframework_globals.sdk.hook(enemy_core_destroy_method, function(args)\
\9\9local enemy_core = modules.reframework_globals.sdk.to_managed_object(args[2]);\
\9\9\
\9\9this.on_destroy(enemy_core);\
\9end, function(retval)\
\9\9return retval;\
\9end);\
\
\9-- DLC\
\
\9modules.reframework_globals.sdk.hook(em_1600_core_on_core_damage_method, function(args)\
\9\9local enemy_core = modules.reframework_globals.sdk.to_managed_object(args[2]);\
\9\9\
\9\9this.on_core_damage_executioner(enemy_core);\
\9end, function(retval)\
\9\9return retval;\
\9end);\
\
\9modules.reframework_globals.sdk.hook(em_1600_core_on_core_die_method, function(args)\
\9\9local enemy_core = modules.reframework_globals.sdk.to_managed_object(args[2]);\
\9\9\
\9\9executioner_enemy_core = enemy_core;\
\9end, function(retval)\
\9\9this.on_post_core_die_executioner(executioner_enemy_core);\
\9\9\
\9\9return retval;\
\9end);\
\
\9modules.reframework_globals.sdk.hook(em_1600_core_controller_update_core_method, function(args)\
\9\9local core_controller = modules.reframework_globals.sdk.to_managed_object(args[2]);\
\9\9\
\9\9this.on_update_core_executioner(core_controller);\
\9end, function(retval)\
\9\9return retval;\
\9end);\
\
\9modules.reframework_globals.sdk.hook(update_sub_scenario_num_method, function(args)\
\9\9local enemy_core = modules.reframework_globals.sdk.to_managed_object(args[2]);\
\9\9\
\9\9this.update_angie_core_stabbed_count(enemy_core);\
\9end, function(retval)\
\9\9return retval;\
\9end);\
\
\9modules.reframework_globals.sdk.hook(request_dead_clip_start_method, function(args)\
\9\9local enemy_core = modules.reframework_globals.sdk.to_managed_object(args[2]);\
\9\9\
\9\9this.on_angie_core_request_dead_clip_start(enemy_core);\
\9end, function(retval)\
\9\9return retval;\
\9end);\
end\
\
return this;\
", '@'..".\\Health_Bars\\core\\enemy_handler.lua" ) )

package.preload[ "Health_Bars.core.game_handler" ] = assert( (loadstring or load)( "local this = {};\
\
local modules = require(\"Health_Bars.modules\");\
\
this.game = {};\
this.game.is_cutscene_playing = false;\
this.game.is_paused = false;\
this.game.is_mercenaries = false;\
\
local update_time_limit = 0.6;\
\
local pause_off_timer = nil;\
local cutscene_off_timer = nil;\
\
local content_timer_type_def = modules.reframework_globals.sdk.find_type_definition(\"app.ContentTimer\");\
local on_pause_method = content_timer_type_def:get_method(\"onPause\");\
\
local event_system_app_type_def = modules.reframework_globals.sdk.find_type_definition(\"app.EventSystemApp\");\
local is_running_event_method = event_system_app_type_def:get_method(\"isRunningEvent(System.Boolean)\");\
\
local mercenaries_utility_type_def = modules.reframework_globals.sdk.find_type_definition(\"app.MercenariesUtility\");\
local is_mercenaries_mode_method = mercenaries_utility_type_def:get_method(\"inMercenariesMode\");\
\
local map_manager_type_def = modules.reframework_globals.sdk.find_type_definition(\"app.MapManager\");\
local get_current_indoor_unit_method = map_manager_type_def:get_method(\"get_currentIndoorUnit\");\
local get_current_room_unit_method = map_manager_type_def:get_method(\"get_currentRoomUnit\");\
\
local indoor_unit_type_def = modules.reframework_globals.sdk.find_type_definition(\"app.MapManagerData.IndoorUnit\");\
local get_indoor_name_method = indoor_unit_type_def:get_method(\"get_indoorName\");\
\
local room_unit_type_def = modules.reframework_globals.sdk.find_type_definition(\"app.MapManagerData.RoomUnit\");\
local get_floor_no_method = room_unit_type_def:get_method(\"get_floorNo\");\
\
function this.update_is_cutscene()\
\9local event_system_app = modules.singletons.event_system_app;\
\
\9if event_system_app == nil then\
\9\9modules.error_handler.report(\"game_handler.update_is_cutscene\", \"No EventSystemApp\");\
        return;\
    end\
\
\9local is_player_event_playing = is_running_event_method:call(event_system_app, true);\
\9local is_event_playing = is_running_event_method:call(event_system_app, false);\
\
\9if is_player_event_playing == nil then\
\9\9modules.error_handler.report(\"game_handler.update_is_cutscene\",  \"No IsPlayerEventPlaying\");\
\9\9is_player_event_playing = false;\
\9end\
\
\9if is_event_playing == nil then\
\9\9modules.error_handler.report(\"game_handler.update_is_cutscene\", \"No IsEventPlaying\");\
\9\9is_event_playing = false;\
\9end\
\
\9local is_cutscene_playing = is_player_event_playing or is_event_playing;\
\
\9-- Cutscene\
\9if is_cutscene_playing then\
\9\9this.game.is_cutscene_playing = true;\
\9\9modules.time.remove_delay_timer(cutscene_off_timer);\
\9\9cutscene_off_timer = nil;\
\9\9return;\
\9end\
\
\9-- Game No Cutscene, State No Cutscene\
\9if not this.game.is_cutscene_playing then\
\9\9modules.time.remove_delay_timer(cutscene_off_timer);\
\9\9cutscene_off_timer = nil;\
\9\9return;\
\9end\
\
\9-- Game No Cutscene, State Cutscene, Timer is On\
\9if cutscene_off_timer ~= nil then\
\9\9return;\
\9end\
\
\9-- Game No Cutscene, State Cutscene, Timer is Off\
\9cutscene_off_timer = modules.time.new_delay_timer(function()\
\9\9this.game.is_cutscene_playing = false;\
\9\9cutscene_off_timer = nil;\
\9end,\
\9update_time_limit);\
end\
\
function this.update_is_mercenaries()\
\9local is_mercenaries_mode = is_mercenaries_mode_method:call(nil);\
\9if is_mercenaries_mode == nil then\
\9\9modules.error_handler.report(\"game_handler.update_is_mercenaries\", \"No isMercenariesMode\");\
\9\9return;\
\9end\
\
\9this.game.is_mercenaries = is_mercenaries_mode;\
end\
\
function this.update_map_indoor_info()\
\9local map_manager = modules.singletons.map_manager;\
\9if map_manager == nil then\
\9\9modules.error_handler.report(\"game_handler.update_map_indoor_info\", \"No MapManager\");\
\9\9return;\
\9end\
\
\9this.game.is_house_benevientos_basement = false;\
\
\9local current_indoor_unit = get_current_indoor_unit_method:call(map_manager);\
\9if current_indoor_unit == nil then\
\9\9return;\
\9end\
\
\9local indoor_name = get_indoor_name_method:call(current_indoor_unit);\
\9if indoor_name == nil then\
\9\9modules.error_handler.report(\"game_handler.update_map_indoor_info\", \"No indoorName\");\
\9\9return;\
\9end\
\
\9local current_room_unit = get_current_room_unit_method:call(map_manager);\
\9if current_room_unit == nil then\
\9\9modules.error_handler.report(\"game_handler.update_map_indoor_info\", \"No currentRoomUnit\");\
\9\9return;\
\9end\
\
\9local floor_no = get_floor_no_method:call(current_room_unit);\
\9if floor_no == nil then\
\9\9modules.error_handler.report(\"game_handler.update_map_indoor_info\", \"No floorNo\");\
\9\9return;\
\9end\
\
\9this.game.is_house_benevientos_basement = indoor_name == \"Indoor2_3\" and floor_no < 0;\
end\
\
function this.update()\
\9this.update_is_cutscene();\
\9this.update_is_mercenaries();\
\9this.update_map_indoor_info();\
end\
\
function this.on_pause(is_paused_int)\
\9if is_paused_int == nil then\
\9\9modules.error_handler.report(\"game_handler.on_pause\", \"No IsPaused Int\");\
\9\9return;\
\9end\
\
\9local is_paused = (is_paused_int & 1) == 1;\
\
\9-- Pause\
\9if is_paused then\
\9\9this.game.is_paused = true;\
\9\9modules.time.remove_delay_timer(pause_off_timer);\
\9\9pause_off_timer = nil;\
\9\9return;\
\9end\
\
\9-- Game No Pause, State No Pause\
\9if not this.game.is_paused then\
\9\9modules.time.remove_delay_timer(pause_off_timer);\
\9\9pause_off_timer = nil;\
\9\9return;\
\9end\
\
\9-- Game No Pause, State Pause, Timer is On\
\9if pause_off_timer ~= nil then\
\9\9return;\
\9end\
\
\9-- Game No Pause, State Pause, Timer is Off\
\9pause_off_timer = modules.time.new_delay_timer(function()\
\9\9this.game.is_paused = false;\
\9\9pause_off_timer = nil;\
\9end,\
\9update_time_limit);\
end\
\
function this.init_module()\
\9modules.reframework_globals.sdk.hook(on_pause_method, function(args)\
\9\9local is_paused_int = modules.reframework_globals.sdk.to_int64(args[3]);\
\9\9\
\9\9this.on_pause(is_paused_int);\
\9end, function(retval)\
\9\9return retval;\
\9end);\
end\
\
return this;", '@'..".\\Health_Bars\\core\\game_handler.lua" ) )

package.preload[ "Health_Bars.core.player_handler" ] = assert( (loadstring or load)( "local this = {};\
\
local modules = require(\"Health_Bars.modules\");\
\
this.player = {};\
this.player.position = modules.reframework_globals.Vector3f.new(0, 0, 0);\
this.player.is_aiming = false;\
this.player.is_using_scope = false;\
this.player.aim_target_owner = nil;\
this.player.is_enable_damage = true;\
this.player.is_enable_use_item = true;\
\
local enemy_manager_type_def = modules.reframework_globals.sdk.find_type_definition(\"app.EnemyManager\");\
local get_aim_target_enemy_method = enemy_manager_type_def:get_method(\"get_aimTargetEnemy\");\
\
local weapon_gun_core_type_def = modules.reframework_globals.sdk.find_type_definition(\"app.WeaponGunCore\");\
local on_aim_start_method = weapon_gun_core_type_def:get_method(\"onAimStart\");\
local on_aim_end_method = weapon_gun_core_type_def:get_method(\"onAimEnd\");\
local update_scope_method = weapon_gun_core_type_def:get_method(\"updateScope\");\
\
local props_manager_type_def = modules.reframework_globals.sdk.find_type_definition(\"app.PropsManager\");\
local get_player_method = props_manager_type_def:get_method(\"get_Player\");\
\
local game_object_type_def = modules.reframework_globals.sdk.find_type_definition(\"via.GameObject\");\
local get_transform_method = game_object_type_def:get_method(\"get_Transform\");\
\
local transform_type_def = get_transform_method:get_return_type();\
local get_position_method = transform_type_def:get_method(\"get_Position\");\
\
local player_core_fps_type_def = modules.reframework_globals.sdk.find_type_definition(\"app.PlayerCoreFPS\");\
local character_status_fps_field = player_core_fps_type_def:get_field(\"CharacterStatus\");\
local late_update_fps_method = player_core_fps_type_def:get_method(\"lateUpdate\");\
local get_is_enable_damage_fps_method = player_core_fps_type_def:get_method(\"get_IsEnableDamage\");\
local set_is_enable_damage_fps_method = player_core_fps_type_def:get_method(\"set_IsEnableDamage\");\
\
local player_core_tps_type_def = modules.reframework_globals.sdk.find_type_definition(\"app.PlayerCoreTPS\");\
local character_status_tps_field = player_core_tps_type_def:get_field(\"CharacterStatus\");\
local late_update_tps_method = player_core_tps_type_def:get_method(\"lateUpdate\");\
local get_is_enable_damage_tps_method = player_core_tps_type_def:get_method(\"get_IsEnableDamage\");\
\
local player_status_type_def = modules.reframework_globals.sdk.find_type_definition(\"app.PlayerStatus\");\
local get_is_player_method = player_status_type_def:get_method(\"get_isPlayer\");\
local get_is_enable_use_item_method = player_status_type_def:get_method(\"get_isEnableUseItem\");\
\
function this.update_position()\
\9if modules.singletons.props_manager == nil then\
\9\9modules.error_handler.report(\"player.update_position\", \"No PropsManager\");\
\9\9return;\
\9end\
\
\9local player = get_player_method:call(modules.singletons.props_manager);\
\9if player == nil then\
\9\9modules.error_handler.report(\"player.update_position\", \"No Player\");\
\9\9return;\
\9end\
\
\9local player_transform = get_transform_method:call(player);\
\
\9if player_transform == nil then\
\9\9modules.error_handler.report(\"player.update_position\", \"No Transform\");\
\9\9return;\
\9end\
\
\9local position = get_position_method:call(player_transform);\
\9if position == nil then\
\9\9modules.error_handler.report(\"player.update_position\", \"No Position\");\
\9\9return;\
\9end\
\
\9this.player.position = position;\
end\
\
function this.update_aim_target()\
\9local cached_config = modules.config.current_config.settings;\
\
\9local enemy_manager = modules.singletons.enemy_manager;\
\
\9if enemy_manager == nil then\
\9\9modules.error_handler.report(\"player.update_aim_target\", \"No EnemyManager\");\
\9\9return;\
\9end\
\
\9local aim_target_game_object = get_aim_target_enemy_method:call(enemy_manager);\
\
\9if aim_target_game_object == nil then\
\9\9this.player.aim_target_owner = nil;\
\9\9return;\
\9end\
\
\9this.player.aim_target_owner = aim_target_game_object;\
\
\9if cached_config.reset_time_duration_on_aim_target_for_everyone then\
\9\9for enemy_core, enemy in pairs(modules.enemy_handler.enemy_list) do\
\9\9\9if modules.time.total_elapsed_script_seconds - enemy.last_reset_time < cached_config.time_duration then\
\9\9\9\9modules.enemy_handler.update_last_reset_time(enemy);\
\9\9\9end\
\
\9\9end\
\9end\
\9\
\9if cached_config.apply_time_duration_on_aim_target then\
\9\9modules.enemy_handler.update_last_reset_time(modules.enemy_handler.enemy_owner_list[aim_target_game_object]);\
\9end\
end\
\
function this.update()\
\9this.update_aim_target();\
end\
\
function this.on_aim_start(weapon_gun_core)\
\9local cached_config = modules.config.current_config.settings;\
\
\9this.player.is_aiming = true;\
\9this.player.is_using_scope = false;\
\
\9if cached_config.apply_time_duration_on_aiming then\
\9\9for enemy_core, enemy in pairs(modules.enemy_handler.enemy_list) do\
\9\9\9modules.enemy_handler.update_last_reset_time(enemy);\
\9\9end\
\9end\
end\
\
function this.on_aim_end(weapon_gun_core)\
\9this.player.is_aiming = false;\
\9this.player.is_using_scope = false;\
end\
\
function this.on_update_scope(weapon_gun_core)\
\9local cached_config = modules.config.current_config.settings;\
\
\9this.player.is_using_scope = true;\
\
\9if cached_config.apply_time_duration_on_using_scope then\
\9\9for enemy_core, enemy in pairs(modules.enemy_handler.enemy_list) do\
\9\9\9modules.enemy_handler.update_last_reset_time(enemy);\
\9\9end\
\9end\
end\
\
function this.on_late_update_fps(player_core_fps)\
    local character_status = character_status_fps_field:get_data(player_core_fps);\
    if character_status == nil then\
        modules.error_handler.report(\"player_handler.on_late_update_fps\", \"No Character Status\");\
        return;\
    end\
\
    local is_player = get_is_player_method:call(character_status);\
    if is_player == nil then\
        modules.error_handler.report(\"player_handler.on_late_update_fps\", \"No IsPlayer\");\
        return;\
    end\
\
    if not is_player then\
        return;\
    end\
\
\9local is_enable_damage = get_is_enable_damage_fps_method:call(player_core_fps);\
    if is_enable_damage == nil then\
        modules.error_handler.report(\"player_handler.on_late_update_fps\", \"No IsEnableDamage\");\
        return;\
    end\
\
\9local is_enable_use_item = get_is_enable_use_item_method:call(character_status);\
\9if is_enable_use_item == nil then\
\9\9modules.error_handler.report(\"player_handler.on_late_update_fps\", \"No IsEnableUseItem\");\
\9\9return;\
\9end\
\
    this.player.is_enable_damage = is_enable_damage;\
\9this.player.is_enable_use_item = is_enable_use_item;\
end\
\
function this.on_late_update_tps(player_core_tps)\
    local character_status = character_status_tps_field:get_data(player_core_tps);\
    if character_status == nil then\
        modules.error_handler.report(\"player_handler.on_late_update_tps\", \"No Character Status\");\
        return;\
    end\
\
    local is_player = get_is_player_method:call(character_status);\
    if is_player == nil then\
        modules.error_handler.report(\"player_handler.on_late_update_tps\", \"No IsPlayer\");\
        return;\
    end\
\
    if not is_player then\
        return;\
    end\
\
    local is_enable_damage = get_is_enable_damage_tps_method:call(player_core_tps);\
    if is_enable_damage == nil then\
        modules.error_handler.report(\"player_handler.on_late_update_tps\", \"No IsEnableDamage\");\
        return;\
    end\
\
    local is_enable_use_item = get_is_enable_use_item_method:call(character_status);\
\9if is_enable_use_item == nil then\
\9\9modules.error_handler.report(\"player_handler.on_late_update_tps\", \"No IsEnableUseItem\");\
\9\9return;\
\9end\
\
    this.player.is_enable_damage = is_enable_damage;\
\9this.player.is_enable_use_item = is_enable_use_item;\
end\
\
function this.on_set_is_enable_damage_fps(is_enable_damage)\
    this.player.is_enable_damage = is_enable_damage;\
end\
\
function this.init_module()\
\9modules.reframework_globals.sdk.hook(on_aim_start_method, function(args)\
\9\9local weapon_gun_core = modules.reframework_globals.sdk.to_managed_object(args[2]);\
\9\9\
\9\9this.on_aim_start(weapon_gun_core)\
\9end, function(retval)\
\9\9return retval;\
\9end);\
\
\9modules.reframework_globals.sdk.hook(on_aim_end_method, function(args)\
\9\9local weapon_gun_core = modules.reframework_globals.sdk.to_managed_object(args[2]);\
\9\9\
\9\9this.on_aim_end(weapon_gun_core)\
\9end, function(retval)\
\9\9return retval;\
\9end);\
\
\9modules.reframework_globals.sdk.hook(update_scope_method, function(args)\
        local weapon_gun_core = modules.reframework_globals.sdk.to_managed_object(args[2]);\
\9\9\
\9\9this.on_update_scope(weapon_gun_core)\
\9end, function(retval)\
\9\9return retval;\
\9end);\
\
\9modules.reframework_globals.sdk.hook(late_update_fps_method, function(args)\
        local player_core_fps = modules.reframework_globals.sdk.to_managed_object(args[2]);\
\
\9\9modules.throttle.throttle(this.on_late_update_fps, modules.config.current_config.settings.timer_delays.update_player_data_delay, player_core_fps);\
\9end, function(retval)\
\9\9return retval;\
    end);\
\
    modules.reframework_globals.sdk.hook(late_update_tps_method, function(args)\
        local player_core_tps = modules.reframework_globals.sdk.to_managed_object(args[2]);\
\
\9\9modules.throttle.throttle(this.on_late_update_tps, modules.config.current_config.settings.timer_delays.update_player_data_delay, player_core_tps);\
\9end, function(retval)\
\9\9return retval;\
    end);\
\
\9-- Works for TPS as well\
\9modules.reframework_globals.sdk.hook(set_is_enable_damage_fps_method, function(args)\
        local is_enable_damage = (modules.reframework_globals.sdk.to_int64(args[3]) & 1) == 1;\
\
        this.on_set_is_enable_damage_fps(is_enable_damage);\
\9end, function(retval)\
\9\9return retval;\
    end);\
end\
\
return this;", '@'..".\\Health_Bars\\core\\player_handler.lua" ) )

package.preload[ "Health_Bars.customization.customization_menu" ] = assert( (loadstring or load)( "local this = {};\
\
local modules = require(\"Health_Bars.modules\");\
\
this.font = nil;\
this.full_font_range = {0x1, 0xFFFF, 0};\
this.is_opened = false;\
\
this.window_flags = 0x10120;\
this.color_picker_flags = 327680;\
this.decimal_input_flags = 33;\
\
this.config_changed = false;\
\
this.fonts = {\9\"Arial\", \"Arial Black\", \"Bahnschrift\", \"Calibri\", \"Cambria\", \"Cambria Math\", \"Candara\",\
\9\9\9\9\"Comic Sans MS\", \"Consolas\", \"Constantia\", \"Corbel\", \"Courier New\", \"Ebrima\",\
\9\9\9\9\"Franklin Gothic Medium\", \"Gabriola\", \"Gadugi\", \"Georgia\", \"HoloLens MDL2 Assets\", \"Impact\",\
\9\9\9\9\"Ink Free\", \"Javanese Text\", \"Leelawadee UI\", \"Lucida Console\", \"Lucida Sans Unicode\",\
\9\9\9\9\"Malgun Gothic\", \"Marlett\", \"Microsoft Himalaya\", \"Microsoft JhengHei\", \"Microsoft New Tai Lue\",\
\9\9\9\9\"Microsoft PhagsPa\", \"Microsoft Sans Serif\", \"Microsoft Tai Le\", \"Microsoft YaHei\",\
\9\9\9\9\"Microsoft Yi Baiti\", \"MingLiU-ExtB\", \"Mongolian Baiti\", \"MS Gothic\", \"MV Boli\", \"Myanmar Text\",\
\9\9\9\9\"Nirmala UI\", \"Palatino Linotype\", \"Segoe MDL2 Assets\", \"Segoe Print\", \"Segoe Script\", \"Segoe UI\",\
\9\9\9\9\"Segoe UI Historic\", \"Segoe UI Emoji\", \"Segoe UI Symbol\", \"SimSun\", \"Sitka\", \"Sylfaen\", \"Symbol\",\
\9\9\9\9\"Tahoma\", \"Times New Roman\", \"Trebuchet MS\", \"Verdana\", \"Webdings\", \"Wingdings\", \"Yu Gothic\"\
};\
\
function this.reload_font(pop_push)\
\9local cached_config = modules.config.current_config;\
\9local cached_language = modules.language.current_language;\
\
\9local font_range = cached_language.unicode_glyph_ranges;\
\
\9if cached_language.font_name == \"\" then\
\9\9font_range = nil;\
\
\9elseif cached_language.unicode_glyph_ranges == nil\
\9\9or modules.utils.table.is_empty(cached_language.unicode_glyph_ranges)\
\9\9or #cached_language.unicode_glyph_ranges == 1\
\9\9or not modules.utils.number.is_odd(#cached_language.unicode_glyph_ranges)\
\9then\
\
\9\9\
\
\9\9font_range = this.full_font_range;\
\9end\
\
    local reframework_font_size = 16;\
\
\9if cached_config.menu_font.scale_with_reframework_font_size then\
\9\9reframework_font_size = modules.reframework_globals.imgui.get_default_font_size();\
\9end\
\9\
    local final_size = modules.utils.math.round(cached_config.menu_font.size_scale_modifier * reframework_font_size);\
\9\
\9this.font = modules.reframework_globals.imgui.load_font(cached_language.font_name, final_size, font_range);\
\
\9if pop_push then\
\9\9modules.reframework_globals.imgui.pop_font();\
\9\9modules.reframework_globals.imgui.push_font(this.font);\
\9end\
end\
\
\
function this.init()\
\9modules.bar_customization.init();\
\9modules.label_customization.init();\
\9modules.position_customization.init();\
end\
\
function this.draw()\
\9local cached_config = modules.config.current_config;\
\9local cached_language = modules.language.current_language.customization_menu;\
\
\9local window_position = modules.reframework_globals.Vector2f.new(cached_config.customization_menu.position.x, cached_config.customization_menu.position.y);\
\9local window_pivot = modules.reframework_globals.Vector2f.new(cached_config.customization_menu.pivot.x, cached_config.customization_menu.pivot.y);\
\9local window_size = modules.reframework_globals.Vector2f.new(cached_config.customization_menu.size.width, cached_config.customization_menu.size.height);\
\
\9modules.reframework_globals.imgui.set_next_window_pos(window_position, 1 << 3, window_pivot);\
\9modules.reframework_globals.imgui.set_next_window_size(window_size, 1 << 3);\
\
\9modules.reframework_globals.imgui.push_font(this.font);\
\
\9this.is_opened = modules.reframework_globals.imgui.begin_window(\
\9\9modules.utils.imgui.label(cached_language.mod_name .. \" v\" .. modules.config.current_config.version, \"window\"), this.is_opened, this.window_flags);\
\
\9if not this.is_opened then\
\9\9modules.reframework_globals.imgui.pop_font();\
\9\9modules.reframework_globals.imgui.end_window();\
\9\9return;\
\9end\
\
\9local changed = false;\
\9local config_changed = false;\
\9local enemy_filters_changed = false;\
\9local language_changed = false;\
\9local menu_font_changed = false;\
\9local window_changed = false;\
\9\
\9local index = 1;\
\9local language_index = 1;\
\
\9local new_window_position = modules.reframework_globals.imgui.get_window_pos();\
\9if window_position.x ~= new_window_position.x or window_position.y ~= new_window_position.y then\
\9\9window_changed = true;\
\
\9\9cached_config.customization_menu.position.x = new_window_position.x;\
\9\9cached_config.customization_menu.position.y = new_window_position.y;\
\9end\
\
\9local new_window_size = modules.reframework_globals.imgui.get_window_size();\
\9if window_size.x ~= new_window_size.x or window_size.y ~= new_window_size.y then\
\9\9window_changed = true;\
\
\9\9cached_config.customization_menu.size.width = new_window_size.x;\
\9\9cached_config.customization_menu.size.height = new_window_size.y;\
\9end\
\
\9if modules.reframework_globals.imgui.button(modules.utils.imgui.label(cached_language.reset_config, \"reset_config\")) then\
\9\9modules.config.reset();\
\9\9config_changed = true;\
\9end\
\
\9changed, cached_config.enabled = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.enabled, \"enabled\"), cached_config.enabled);\
\9config_changed = config_changed or changed;\
\
    if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.language, \"language\")) then\
        modules.reframework_globals.imgui.text(cached_language.menu_font_change_disclaimer);\
\
        changed, language_index = modules.reframework_globals.imgui.combo(\
            modules.utils.imgui.label(cached_language.language, \"language.language\"),\
            modules.utils.table.find_index(modules.language.language_names, cached_config.language),\
            modules.language.language_names);\
\
        config_changed = config_changed or changed;\
        language_changed = language_changed or changed;\
\
        modules.reframework_globals.imgui.tree_pop();\
    end\
\9\
\9if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.global_modifiers, \"global_modifiers\")) then\
\9\9changed, cached_config.global_modifiers.size_modifier = modules.reframework_globals.imgui.drag_float(modules.utils.imgui.label(cached_language.size_modifier, \"global_modifiers.size_modifier\"), cached_config.global_modifiers.size_modifier, 0.001, 0.001, 100, \"%.3f\");\
\9\9config_changed = config_changed or changed;\
\
\9\9changed, cached_config.global_modifiers.scale_size_modifier_with_resolution = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.scale_size_modifier_with_resolution, \"global_modifiers.scale_size_modifier_with_resolution\"),\
\9\9\9cached_config.global_modifiers.scale_size_modifier_with_resolution);\
\9\9config_changed = config_changed or changed;\
\
\9\9changed, cached_config.global_modifiers.position_modifier = modules.reframework_globals.imgui.drag_float(modules.utils.imgui.label(cached_language.position_modifier, \"global_modifiers.position_modifier\"), cached_config.global_modifiers.position_modifier, 0.001, 0.001, 100, \"%.3f\");\
\9\9config_changed = config_changed or changed;\
\
\9\9changed, cached_config.global_modifiers.scale_position_modifier_with_resolution = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.scale_position_modifier_with_resolution, \"global_modifiers.scale_position_modifier_with_resolution\"),\
\9\9\9cached_config.global_modifiers.scale_position_modifier_with_resolution);\
\9\9config_changed = config_changed or changed;\
\
\9\9modules.reframework_globals.imgui.tree_pop();\
\9end\
\
\9if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.menu_font, \"menu_font\")) then\
\9\9modules.reframework_globals.imgui.text(cached_language.menu_font_change_disclaimer);\
\
\9\9changed, cached_config.menu_font.size_scale_modifier = modules.reframework_globals.imgui.drag_float(modules.utils.imgui.label(cached_language.size_scale_modifier, \"menu_font.size_scale_modifier\"),\
\9\9\9cached_config.menu_font.size_scale_modifier, 0.01, 0.1, 100, \"%.2f\");\
\9\9config_changed = config_changed or changed;\
        menu_font_changed = menu_font_changed or changed;\
\
\9\9changed, cached_config.menu_font.scale_with_reframework_font_size = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.scale_with_reframework_font_size, \"menu_font.scale_with_reframework_font_size\"), cached_config.menu_font.scale_with_reframework_font_size);\
\9\9config_changed = config_changed or changed;\
\9\9menu_font_changed = menu_font_changed or changed;\
\
\9\9modules.reframework_globals.imgui.tree_pop();\
\9end\
\
\9if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.ui_font, \"ui_font\")) then\
\9\9modules.reframework_globals.imgui.text(cached_language.font_notice);\
\
\9\9if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.dynamic_ui, \"ui_font.dynamic_ui\")) then\
\9\9\9changed, index = modules.reframework_globals.imgui.combo(modules.utils.imgui.label(cached_language.family, \"ui_font.dynamic_ui.family\"),\
\9\9\9\9modules.utils.table.find_index(this.fonts, cached_config.ui_font.dynamic_ui.family), this.fonts);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9if changed then\
\9\9\9\9cached_config.ui_font.dynamic_ui.family = this.fonts[index];\
\9\9\9end\
\
\9\9\9changed, cached_config.ui_font.dynamic_ui.bold = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.bold, \"ui_font.dynamic_ui.bold\"),\
\9\9\9\9cached_config.ui_font.dynamic_ui.bold);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9changed, cached_config.ui_font.dynamic_ui.italic = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.italic, \"ui_font.dynamic_ui.italic\"),\
\9\9\9\9cached_config.ui_font.dynamic_ui.italic);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9changed, cached_config.ui_font.dynamic_ui.size_scale_modifier = modules.reframework_globals.imgui.drag_float(\
\9\9\9\9modules.utils.imgui.label(cached_language.size_scale_modifier, \"ui_font.dynamic_ui.size_scale_modifier\"), cached_config.ui_font.dynamic_ui.size_scale_modifier, 0.01, 0.1, 100, \"%.2f\");\
\9\9\9config_changed = config_changed or changed;\
\9\9\9\
\9\9\9changed, cached_config.ui_font.dynamic_ui.scale_with_reframework_font_size = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.scale_with_reframework_font_size, \"ui_font.dynamic_ui.scale_with_reframework_font_size\"), cached_config.ui_font.dynamic_ui.scale_with_reframework_font_size);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9modules.reframework_globals.imgui.tree_pop();\
\9\9end\
\
\9\9if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.boss_ui, \"ui_font.boss_ui\")) then\
\9\9\9changed, index = modules.reframework_globals.imgui.combo(modules.utils.imgui.label(cached_language.family, \"ui_font.boss_ui.family\"),\
\9\9\9\9modules.utils.table.find_index(this.fonts, cached_config.ui_font.boss_ui.family), this.fonts);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9if changed then\
\9\9\9\9cached_config.ui_font.boss_ui.family = this.fonts[index];\
\9\9\9end\
\
\9\9\9changed, cached_config.ui_font.boss_ui.bold = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.bold, \"ui_font.boss_ui.bold\"),\
\9\9\9\9cached_config.ui_font.boss_ui.bold);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9changed, cached_config.ui_font.boss_ui.italic = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.italic, \"ui_font.boss_ui.italic\"),\
\9\9\9\9cached_config.ui_font.boss_ui.italic);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9changed, cached_config.ui_font.boss_ui.size_scale_modifier = modules.reframework_globals.imgui.drag_float(\
\9\9\9\9modules.utils.imgui.label(cached_language.size_scale_modifier, \"ui_font.boss_ui.size_scale_modifier\"), cached_config.ui_font.boss_ui.size_scale_modifier, 0.01, 0.1, 100, \"%.2f\");\
\9\9\9config_changed = config_changed or changed;\
\9\9\9\
\9\9\9changed, cached_config.ui_font.boss_ui.scale_with_reframework_font_size = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.scale_with_reframework_font_size, \"ui_font.boss_ui.scale_with_reframework_font_size\"), cached_config.ui_font.boss_ui.scale_with_reframework_font_size);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9modules.reframework_globals.imgui.tree_pop();\
\9\9end\
\
\9\9modules.reframework_globals.imgui.tree_pop();\
\
\9end\
\
\9if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.settings, \"settings\")) then\
\9\9if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(modules.language.current_language.customization_menu.timer_delays, \"settings.timer_delays\")) then\
\
\9\9\9changed, cached_config.settings.timer_delays.update_singletons_delay = modules.reframework_globals.imgui.drag_float(\
\9\9\9\9modules.utils.imgui.label(modules.language.current_language.customization_menu.update_singletons_delay, \"settings.timer_delays.update_singletons_delay\"),\
\9\9\9\9cached_config.settings.timer_delays.update_singletons_delay, 0.001, 0, 5, \"%.3f\");\
\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9changed, cached_config.settings.timer_delays.update_window_size_delay = modules.reframework_globals.imgui.drag_float(\
\9\9\9\9modules.utils.imgui.label(modules.language.current_language.customization_menu.update_window_size_delay, \"settings.timer_delays.update_window_size_delay\"),\
\9\9\9\9cached_config.settings.timer_delays.update_window_size_delay, 0.001, 0, 5, \"%.3f\");\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9changed, cached_config.settings.timer_delays.update_game_data_delay = modules.reframework_globals.imgui.drag_float(\
\9\9\9\9modules.utils.imgui.label(modules.language.current_language.customization_menu.update_game_data_delay, \"settings.timer_delays.update_game_data_delay\"),\
\9\9\9\9cached_config.settings.timer_delays.update_game_data_delay, 0.001, 0, 5, \"%.3f\");\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9changed, cached_config.settings.timer_delays.update_player_data_delay = modules.reframework_globals.imgui.drag_float(\
\9\9\9\9modules.utils.imgui.label(modules.language.current_language.customization_menu.update_player_data_delay, \"settings.timer_delays.update_player_data_delay\"),\
\9\9\9\9cached_config.settings.timer_delays.update_player_data_delay, 0.001, 0, 5, \"%.3f\");\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9changed, cached_config.settings.timer_delays.update_enemy_data_delay = modules.reframework_globals.imgui.drag_float(\
\9\9\9\9modules.utils.imgui.label(modules.language.current_language.customization_menu.update_enemy_data_delay, \"settings.timer_delays.update_enemy_data_delay\"),\
\9\9\9\9cached_config.settings.timer_delays.update_enemy_data_delay, 0.001, 0, 5, \"%.3f\");\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9modules.reframework_globals.imgui.tree_pop();\
\9\9end\
\
\9\9modules.reframework_globals.imgui.new_line();\
\9\9modules.reframework_globals.imgui.begin_rect();\
\
\9\9changed, cached_config.settings.use_d2d_if_available = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.use_d2d_renderer_if_available, \"settings.use_d2d_if_available\"),\
\9\9\9cached_config.settings.use_d2d_if_available);\
\9\9config_changed = config_changed or changed;\
\
\9\9modules.reframework_globals.imgui.end_rect(5);\
\9\9modules.reframework_globals.imgui.new_line();\
\9\9modules.reframework_globals.imgui.begin_rect();\
\
\9\9changed, cached_config.settings.hide_if_no_update_function_is_being_called = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_if_no_update_function_is_being_called, \"settings.hide_if_no_update_function_is_being_called\"),\
\9\9\9cached_config.settings.hide_if_no_update_function_is_being_called);\
\9\9config_changed = config_changed or changed;\
\9\
\9\9modules.reframework_globals.imgui.end_rect(5);\
\9\9modules.reframework_globals.imgui.new_line();\
\9\9\
\9\9\
\9\9modules.reframework_globals.imgui.tree_pop();\
\9end\
\
\9if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.dynamic_ui, \"dynamic_ui\")) then\
\9\9changed, cached_config.dynamic_ui.visible = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.visible, \"dynamic_ui.visible\"),\
\9\9\9cached_config.dynamic_ui.visible);\
\9\9config_changed = config_changed or changed;\
\
\9\9if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.settings, \"dynamic_ui.settings\")) then\
\9\9\9modules.reframework_globals.imgui.begin_rect();\
\
\9\9\9changed, cached_config.dynamic_ui.settings.render_during_cutscenes = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.render_during_cutscenes, \"dynamic_ui.settings.render_during_cutscenes\"),\
\9\9\9\9cached_config.dynamic_ui.settings.render_during_cutscenes);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.render_when_game_timer_is_paused = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.render_when_game_timer_is_paused, \"dynamic_ui.settings.render_when_game_timer_is_paused\"),\
\9\9\9\9cached_config.dynamic_ui.settings.render_when_game_timer_is_paused);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.render_in_mercenaries = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.render_in_mercenaries, \"dynamic_ui.settings.render_in_mercenaries\"),\
\9\9\9\9cached_config.dynamic_ui.settings.render_in_mercenaries);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9modules.reframework_globals.imgui.end_rect(5);\
\9\9\9modules.reframework_globals.imgui.new_line();\
\9\9\9modules.reframework_globals.imgui.begin_rect();\
\
\9\9\9changed, cached_config.dynamic_ui.settings.render_in_house_benevientos_basement = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.render_in_house_benevientos_basement, \"dynamic_ui.settings.render_in_house_benevientos_basement\"),\
\9\9\9\9cached_config.dynamic_ui.settings.render_in_house_benevientos_basement);\
\9\9\9config_changed = config_changed or changed;\
\9\9\
\9\9\9modules.reframework_globals.imgui.end_rect(5);\
\9\9\9modules.reframework_globals.imgui.new_line();\
\9\9\9modules.reframework_globals.imgui.begin_rect();\
\
\9\9\9changed, cached_config.dynamic_ui.settings.render_aim_target_enemy = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.render_aim_target_enemy, \"dynamic_ui.settings.render_aim_target_enemy\"),\
\9\9\9\9cached_config.dynamic_ui.settings.render_aim_target_enemy);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.render_damaged_enemies = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.render_damaged_enemies, \"dynamic_ui.settings.render_damaged_enemies\"),\
\9\9\9\9cached_config.dynamic_ui.settings.render_damaged_enemies);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.render_everyone_else = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.render_everyone_else, \"dynamic_ui.settings.render_everyone_else\"),\
\9\9\9\9cached_config.dynamic_ui.settings.render_everyone_else);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9\
\9\9\9modules.reframework_globals.imgui.end_rect(5);\
\9\9\9modules.reframework_globals.imgui.new_line();\
\9\9\9modules.reframework_globals.imgui.begin_rect();\
\9\9\9\
\9\9\9changed, cached_config.dynamic_ui.settings.render_when_normal = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.render_when_normal, \"dynamic_ui.settings.render_when_normal\"),\
\9\9\9\9cached_config.dynamic_ui.settings.render_when_normal);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.render_when_aiming = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.render_when_aiming, \"dynamic_ui.settings.render_when_aiming\"),\
\9\9\9\9cached_config.dynamic_ui.settings.render_when_aiming);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.render_when_using_scope = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.render_when_using_scope, \"dynamic_ui.settings.render_when_using_scope\"),\
\9\9\9\9cached_config.dynamic_ui.settings.render_when_using_scope);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9modules.reframework_globals.imgui.end_rect(5);\
\9\9\9modules.reframework_globals.imgui.new_line();\
\9\9\9modules.reframework_globals.imgui.begin_rect();\
\
\9\9\9changed, cached_config.dynamic_ui.settings.hide_if_dead = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_if_dead, \"dynamic_ui.settings.hide_if_dead\"),\
\9\9\9\9cached_config.dynamic_ui.settings.hide_if_dead);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.hide_if_full_health = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_if_full_health, \"dynamic_ui.settings.hide_if_full_health\"),\
\9\9\9\9cached_config.dynamic_ui.settings.hide_if_full_health);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.hide_if_enemy_model_is_not_being_rendered = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_if_enemy_model_is_not_being_rendered, \"dynamic_ui.settings.hide_if_enemy_model_is_not_being_rendered\"),\
\9\9\9\9cached_config.dynamic_ui.settings.hide_if_enemy_model_is_not_being_rendered);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.hide_if_player_cant_take_damage = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_if_player_cant_take_damage, \"dynamic_ui.settings.hide_if_player_cant_take_damage\"),\
\9\9\9\9cached_config.dynamic_ui.settings.hide_if_player_cant_take_damage);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.hide_if_player_cant_use_items = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_if_player_cant_use_items, \"dynamic_ui.settings.hide_if_player_cant_use_items\"),\
\9\9\9\9cached_config.dynamic_ui.settings.hide_if_player_cant_use_items);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9modules.reframework_globals.imgui.end_rect(5);\
\9\9\9modules.reframework_globals.imgui.new_line();\
\9\9\9modules.reframework_globals.imgui.begin_rect();\
\
\9\9\9changed, cached_config.dynamic_ui.settings.hide_urias = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_urias, \"dynamic_ui.settings.hide_urias\"),\
\9\9\9\9cached_config.dynamic_ui.settings.hide_urias);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.hide_urias_drac = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_urias_drac, \"dynamic_ui.settings.hide_urias_drac\"),\
\9\9\9\9cached_config.dynamic_ui.settings.hide_urias_drac);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.hide_urias_strajer = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_urias_strajer, \"dynamic_ui.settings.hide_urias_strajer\"),\
\9\9\9\9cached_config.dynamic_ui.settings.hide_urias_strajer);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.hide_bela = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_bela, \"dynamic_ui.settings.hide_bela\"),\
\9\9\9\9cached_config.dynamic_ui.settings.hide_bela);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.hide_cassandra = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_cassandra, \"dynamic_ui.settings.hide_cassandra\"),\
\9\9\9\9cached_config.dynamic_ui.settings.hide_cassandra);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.hide_daniela = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_daniela, \"dynamic_ui.settings.hide_daniela\"),\
\9\9\9\9cached_config.dynamic_ui.settings.hide_daniela);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.hide_dimitrescu_chasing = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_dimitrescu_chasing, \"dynamic_ui.settings.hide_dimitrescu_chasing\"),\
\9\9\9\9cached_config.dynamic_ui.settings.hide_dimitrescu_chasing);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.hide_dimitrescu_boss = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_dimitrescu_boss, \"dynamic_ui.settings.hide_dimitrescu_boss\"),\
\9\9\9\9cached_config.dynamic_ui.settings.hide_dimitrescu_boss);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.hide_angie = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_angie, \"dynamic_ui.settings.hide_angie\"),\
\9\9\9\9cached_config.dynamic_ui.settings.hide_angie);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.hide_varcolac = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_varcolac, \"dynamic_ui.settings.hide_varcolac\"),\
\9\9\9\9cached_config.dynamic_ui.settings.hide_varcolac);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.hide_varcolac_alfa = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_varcolac_alfa, \"dynamic_ui.settings.hide_varcolac_alfa\"),\
\9\9\9\9cached_config.dynamic_ui.settings.hide_varcolac_alfa);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.hide_moreau = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_moreau, \"dynamic_ui.settings.hide_moreau\"),\
\9\9\9\9cached_config.dynamic_ui.settings.hide_moreau);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.hide_sturm = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_sturm, \"dynamic_ui.settings.hide_sturm\"),\
\9\9\9\9cached_config.dynamic_ui.settings.hide_sturm);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.hide_heisenberg = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_heisenberg, \"dynamic_ui.settings.hide_heisenberg\"),\
\9\9\9\9cached_config.dynamic_ui.settings.hide_heisenberg);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.hide_executioner = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_executioner, \"dynamic_ui.settings.hide_executioner\"),\
\9\9\9\9cached_config.dynamic_ui.settings.hide_executioner);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.hide_miranda = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_miranda, \"dynamic_ui.settings.hide_miranda\"),\
\9\9\9\9cached_config.dynamic_ui.settings.hide_miranda);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.hide_miranda_in_dlc = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_miranda_in_dlc, \"dynamic_ui.settings.hide_miranda_in_dlc\"),\
\9\9\9\9cached_config.dynamic_ui.settings.hide_miranda_in_dlc);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9modules.reframework_globals.imgui.end_rect(5);\
\9\9\9modules.reframework_globals.imgui.new_line();\
\9\9\9modules.reframework_globals.imgui.begin_rect();\
\
\9\9\9changed, cached_config.dynamic_ui.settings.hide_leonardo = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_leonardo, \"dynamic_ui.settings.hide_leonardo\"),\
\9\9\9\9cached_config.dynamic_ui.settings.hide_leonardo);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.hide_duke = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_duke, \"dynamic_ui.settings.hide_duke\"),\
\9\9\9\9cached_config.dynamic_ui.settings.hide_duke);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9modules.reframework_globals.imgui.new_line();\
\
\9\9\9changed, cached_config.dynamic_ui.settings.hide_blue_bird = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_blue_bird, \"dynamic_ui.settings.hide_blue_bird\"),\
\9\9\9\9cached_config.dynamic_ui.settings.hide_blue_bird);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.hide_pigs = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_pigs, \"dynamic_ui.settings.hide_pigs\"),\
\9\9\9\9cached_config.dynamic_ui.settings.hide_pigs);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.hide_chickens = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_chickens, \"dynamic_ui.settings.hide_chickens\"),\
\9\9\9\9cached_config.dynamic_ui.settings.hide_chickens);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.hide_goats = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_goats, \"dynamic_ui.settings.hide_goats\"),\
\9\9\9\9cached_config.dynamic_ui.settings.hide_goats);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.hide_fish = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_fish, \"dynamic_ui.settings.hide_fish\"),\
\9\9\9\9cached_config.dynamic_ui.settings.hide_fish);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.hide_catfish = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_catfish, \"dynamic_ui.settings.hide_catfish\"),\
\9\9\9\9cached_config.dynamic_ui.settings.hide_catfish);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9modules.reframework_globals.imgui.new_line();\
\
\9\9\9changed, cached_config.dynamic_ui.settings.hide_rose_copies = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_rose_copies, \"dynamic_ui.settings.hide_rose_copies\"),\
\9\9\9\9cached_config.dynamic_ui.settings.hide_rose_copies);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.hide_masked_duke = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_masked_duke, \"dynamic_ui.settings.hide_masked_duke\"),\
\9\9\9\9cached_config.dynamic_ui.settings.hide_masked_duke);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.hide_mia_dolls = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_mia_dolls, \"dynamic_ui.settings.hide_mia_dolls\"),\
\9\9\9\9cached_config.dynamic_ui.settings.hide_mia_dolls);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.hide_dolls = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_dolls, \"dynamic_ui.settings.hide_dolls\"),\
\9\9\9\9cached_config.dynamic_ui.settings.hide_dolls);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.hide_rose_illusion = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_rose_illusion, \"dynamic_ui.settings.hide_rose_illusion\"),\
\9\9\9\9cached_config.dynamic_ui.settings.hide_rose_illusion);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.hide_miranda_crows = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_miranda_crows, \"dynamic_ui.settings.hide_miranda_crows\"),\
\9\9\9\9cached_config.dynamic_ui.settings.hide_miranda_crows);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.hide_ethan_dlc = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_ethan_in_dlc, \"dynamic_ui.settings.hide_ethan_dlc\"),\
\9\9\9\9cached_config.dynamic_ui.settings.hide_ethan_dlc);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9modules.reframework_globals.imgui.end_rect(5);\
\9\9\9modules.reframework_globals.imgui.new_line();\
\9\9\9modules.reframework_globals.imgui.begin_rect();\
\
\9\9\9changed, cached_config.dynamic_ui.settings.opacity_falloff = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.opacity_falloff, \"dynamic_ui.settings.opacity_falloff\"),\
\9\9\9\9cached_config.dynamic_ui.settings.opacity_falloff);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.max_distance = modules.reframework_globals.imgui.drag_float(modules.utils.imgui.label(cached_language.max_distance, \"dynamic_ui.settings.max_distance\"),\
\9\9\9\9cached_config.dynamic_ui.settings.max_distance, 1, 0, 10000, \"%.0f\");\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.scope_opacity_falloff = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.opacity_Falloff_scope, \"dynamic_ui.settings.scope_opacity_falloff\"),\
\9\9\9\9cached_config.dynamic_ui.settings.scope_opacity_falloff);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.scope_max_distance = modules.reframework_globals.imgui.drag_float(modules.utils.imgui.label(cached_language.max_distance_scope, \"dynamic_ui.settings.scope_max_distance\"),\
\9\9\9\9cached_config.dynamic_ui.settings.scope_max_distance, 1, 0, 10000, \"%.0f\");\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9modules.reframework_globals.imgui.end_rect(5);\
\9\9\9modules.reframework_globals.imgui.new_line();\
\9\9\9modules.reframework_globals.imgui.begin_rect();\
\
\9\9\9changed, cached_config.dynamic_ui.settings.apply_time_duration_on_aiming = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.apply_time_duration_on_aiming, \"dynamic_ui.settings.apply_time_duration_on_aiming\"),\
\9\9\9\9cached_config.dynamic_ui.settings.apply_time_duration_on_aiming);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.apply_time_duration_on_aim_target = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.apply_time_duration_on_aim_target, \"dynamic_ui.settings.apply_time_duration_on_aim_target\"),\
\9\9\9\9cached_config.dynamic_ui.settings.apply_time_duration_on_aim_target);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.apply_time_duration_on_using_scope = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.apply_time_duration_on_using_scope, \"dynamic_ui.settings.apply_time_duration_on_using_scope\"),\
\9\9\9\9cached_config.dynamic_ui.settings.apply_time_duration_on_using_scope);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.apply_time_duration_on_damage_dealt = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.apply_time_duration_on_damage_dealt, \"dynamic_ui.settings.apply_time_duration_on_damage_dealt\"),\
\9\9\9\9cached_config.dynamic_ui.settings.apply_time_duration_on_damage_dealt);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.reset_time_duration_on_aim_target_for_everyone = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.reset_time_duration_on_aim_target_for_everyone, \"dynamic_ui.settings.reset_time_duration_on_aim_target_for_everyone\"),\
\9\9\9\9cached_config.dynamic_ui.settings.reset_time_duration_on_aim_target_for_everyone);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.reset_time_duration_on_damage_dealt_for_everyone = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.reset_time_duration_on_damage_dealt_for_everyone, \"dynamic_ui.settings.reset_time_duration_on_damage_dealt_for_everyone\"),\
\9\9\9\9cached_config.dynamic_ui.settings.reset_time_duration_on_damage_dealt_for_everyone);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9changed, cached_config.dynamic_ui.settings.time_duration = modules.reframework_globals.imgui.drag_float(modules.utils.imgui.label(cached_language.time_duration, \"dynamic_ui.settings.time_duration\"),\
\9\9\9\9cached_config.dynamic_ui.settings.time_duration, 0.1, 0, 1000, \"%.1f\");\
\
\9\9\9modules.reframework_globals.imgui.end_rect(5);\
\9\9\9modules.reframework_globals.imgui.new_line();\
\9\9\9\
\9\9\9modules.reframework_globals.imgui.tree_pop();\
\9\9end\
\
\9\9changed = modules.world_offset_customization.draw(\"dynamic_ui\", cached_config.dynamic_ui.world_offset);\
\9\9config_changed = config_changed or changed;\
\
\9\9changed = modules.offset_customization.draw(\"dynamic_ui\", cached_config.dynamic_ui.offset);\
\9\9config_changed = config_changed or changed;\
\
\9\9if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.health, \"dynamic_ui.health\")) then\
\9\9\9changed, cached_config.dynamic_ui.health.visible = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.visible, \"dynamic_ui.health.visible\"), cached_config.dynamic_ui.health.visible);\
            config_changed = config_changed or changed;\
\9\9\9\
            changed = modules.offset_customization.draw(\"dynamic_ui.health\", cached_config.dynamic_ui.health.offset);\
            config_changed = config_changed or changed;\
\9\9\9\
\9\9\9changed = modules.label_customization.draw(\"dynamic_ui.health.value_label\", cached_language.value_label, cached_config.dynamic_ui.health.value_label);\
            config_changed = config_changed or changed;\
\9\9\9\
\9\9\9changed = modules.label_customization.draw(\"dynamic_ui.health.percentage_label\", cached_language.percentage_label, cached_config.dynamic_ui.health.percentage_label);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9changed = modules.bar_customization.draw(\"dynamic_ui.health.bar\", cached_language.bar, cached_config.dynamic_ui.health.bar);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9modules.reframework_globals.imgui.tree_pop();\
\9\9end\
\9\9\
\9\9modules.reframework_globals.imgui.tree_pop();\
\9end\
\
\9if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.boss_ui, \"boss_ui\")) then\
\9\9changed, cached_config.boss_ui.visible = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.visible, \"boss_ui.visible\"),\
\9\9\9cached_config.boss_ui.visible);\
\9\9config_changed = config_changed or changed;\
\
\9\9if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.settings, \"boss_ui.settings\")) then\
\9\9\9modules.reframework_globals.imgui.begin_rect();\
\
\9\9\9changed, cached_config.boss_ui.settings.render_during_cutscenes = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.render_during_cutscenes, \"boss_ui.settings.render_during_cutscenes\"),\
\9\9\9\9cached_config.boss_ui.settings.render_during_cutscenes);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9changed, cached_config.boss_ui.settings.render_when_game_timer_is_paused = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.render_when_game_timer_is_paused, \"boss_ui.settings.render_when_game_timer_is_paused\"),\
\9\9\9\9cached_config.boss_ui.settings.render_when_game_timer_is_paused);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9changed, cached_config.boss_ui.settings.render_in_mercenaries = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.render_in_mercenaries, \"boss_ui.settings.render_in_mercenaries\"),\
\9\9\9\9cached_config.boss_ui.settings.render_in_mercenaries);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9modules.reframework_globals.imgui.end_rect(5);\
\9\9\9modules.reframework_globals.imgui.new_line();\
\9\9\9modules.reframework_globals.imgui.begin_rect();\
\
\9\9\9changed, cached_config.boss_ui.settings.render_in_house_benevientos_basement = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.render_in_house_benevientos_basement, \"boss_ui.settings.render_in_house_benevientos_basement\"),\
\9\9\9\9cached_config.boss_ui.settings.render_in_house_benevientos_basement);\
\9\9\9config_changed = config_changed or changed;\
\9\9\
\9\9\9modules.reframework_globals.imgui.end_rect(5);\
\9\9\9modules.reframework_globals.imgui.new_line();\
\9\9\9modules.reframework_globals.imgui.begin_rect();\
\9\9\9\
\9\9\9changed, cached_config.boss_ui.settings.render_when_normal = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.render_when_normal, \"boss_ui.settings.render_when_normal\"),\
\9\9\9\9cached_config.boss_ui.settings.render_when_normal);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9changed, cached_config.boss_ui.settings.render_when_aiming = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.render_when_aiming, \"boss_ui.settings.render_when_aiming\"),\
\9\9\9\9cached_config.boss_ui.settings.render_when_aiming);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9changed, cached_config.boss_ui.settings.render_when_using_scope = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.render_when_using_scope, \"boss_ui.settings.render_when_using_scope\"),\
\9\9\9\9cached_config.boss_ui.settings.render_when_using_scope);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9modules.reframework_globals.imgui.end_rect(5);\
\9\9\9modules.reframework_globals.imgui.new_line();\
\9\9\9modules.reframework_globals.imgui.begin_rect();\
\
\9\9\9changed, cached_config.boss_ui.settings.hide_if_dead = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_if_dead, \"boss_ui.settings.hide_if_dead\"),\
\9\9\9\9cached_config.boss_ui.settings.hide_if_dead);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9changed, cached_config.boss_ui.settings.hide_if_full_health = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_if_full_health, \"boss_ui.settings.hide_if_full_health\"),\
\9\9\9\9cached_config.boss_ui.settings.hide_if_full_health);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9changed, cached_config.boss_ui.settings.hide_if_enemy_model_is_not_being_rendered = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_if_enemy_model_is_not_being_rendered, \"boss_ui.settings.hide_if_enemy_model_is_not_being_rendered\"),\
\9\9\9\9cached_config.boss_ui.settings.hide_if_enemy_model_is_not_being_rendered);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9changed, cached_config.boss_ui.settings.hide_if_player_cant_take_damage = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_if_player_cant_take_damage, \"boss_ui.settings.hide_if_player_cant_take_damage\"),\
\9\9\9\9cached_config.boss_ui.settings.hide_if_player_cant_take_damage);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9changed, cached_config.boss_ui.settings.hide_if_player_cant_use_items = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_if_player_cant_use_items, \"boss_ui.settings.hide_if_player_cant_use_items\"),\
\9\9\9\9cached_config.boss_ui.settings.hide_if_player_cant_use_items);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9modules.reframework_globals.imgui.end_rect(5);\
\9\9\9modules.reframework_globals.imgui.new_line();\
\9\9\9modules.reframework_globals.imgui.begin_rect();\
\
\9\9\9changed, cached_config.boss_ui.settings.hide_urias = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_urias, \"boss_ui.settings.hide_urias\"),\
\9\9\9\9cached_config.boss_ui.settings.hide_urias);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.boss_ui.settings.hide_urias_drac = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_urias_drac, \"boss_ui.settings.hide_urias_drac\"),\
\9\9\9\9cached_config.boss_ui.settings.hide_urias_drac);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.boss_ui.settings.hide_urias_strajer = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_urias_strajer, \"boss_ui.settings.hide_urias_strajer\"),\
\9\9\9\9cached_config.boss_ui.settings.hide_urias_strajer);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.boss_ui.settings.hide_bela = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_bela, \"boss_ui.settings.hide_bela\"),\
\9\9\9\9cached_config.boss_ui.settings.hide_bela);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.boss_ui.settings.hide_bela_invincible = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_bela_invincible, \"boss_ui.settings.hide_bela_invincible\"),\
\9\9\9\9cached_config.boss_ui.settings.hide_bela_invincible);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.boss_ui.settings.hide_cassandra = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_cassandra, \"boss_ui.settings.hide_cassandra\"),\
\9\9\9\9cached_config.boss_ui.settings.hide_cassandra);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.boss_ui.settings.hide_cassandra_invincible = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_cassandra_invincible, \"boss_ui.settings.hide_cassandra_invincible\"),\
\9\9\9\9cached_config.boss_ui.settings.hide_cassandra_invincible);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.boss_ui.settings.hide_daniela = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_daniela, \"boss_ui.settings.hide_daniela\"),\
\9\9\9\9cached_config.boss_ui.settings.hide_daniela);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.boss_ui.settings.hide_daniela_invincible = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_daniela_invincible, \"boss_ui.settings.hide_daniela_invincible\"),\
\9\9\9\9cached_config.boss_ui.settings.hide_daniela_invincible);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.boss_ui.settings.hide_dimitrescu_chasing = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_dimitrescu_chasing, \"boss_ui.settings.hide_dimitrescu_chasing\"),\
\9\9\9\9cached_config.boss_ui.settings.hide_dimitrescu_chasing);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.boss_ui.settings.hide_dimitrescu_boss = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_dimitrescu_boss, \"boss_ui.settings.hide_dimitrescu_boss\"),\
\9\9\9\9cached_config.boss_ui.settings.hide_dimitrescu_boss);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.boss_ui.settings.hide_angie = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_angie, \"boss_ui.settings.hide_angie\"),\
\9\9\9\9cached_config.boss_ui.settings.hide_angie);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.boss_ui.settings.hide_varcolac = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_varcolac, \"boss_ui.settings.hide_varcolac\"),\
\9\9\9\9cached_config.boss_ui.settings.hide_varcolac);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.boss_ui.settings.hide_varcolac_alfa = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_varcolac_alfa, \"boss_ui.settings.hide_varcolac_alfa\"),\
\9\9\9\9cached_config.boss_ui.settings.hide_varcolac_alfa);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.boss_ui.settings.hide_moreau = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_moreau, \"boss_ui.settings.hide_moreau\"),\
\9\9\9\9cached_config.boss_ui.settings.hide_moreau);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.boss_ui.settings.hide_sturm = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_sturm, \"boss_ui.settings.hide_sturm\"),\
\9\9\9\9cached_config.boss_ui.settings.hide_sturm);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.boss_ui.settings.hide_heisenberg = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_heisenberg, \"boss_ui.settings.hide_heisenberg\"),\
\9\9\9\9cached_config.boss_ui.settings.hide_heisenberg);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.boss_ui.settings.hide_executioner = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_executioner, \"boss_ui.settings.hide_executioner\"),\
\9\9\9\9cached_config.boss_ui.settings.hide_executioner);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.boss_ui.settings.hide_miranda = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_miranda, \"boss_ui.settings.hide_miranda\"),\
\9\9\9\9cached_config.boss_ui.settings.hide_miranda);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9changed, cached_config.boss_ui.settings.hide_miranda_in_dlc = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.hide_miranda_in_dlc, \"boss_ui.settings.hide_miranda_in_dlc\"),\
\9\9\9\9cached_config.boss_ui.settings.hide_miranda_in_dlc);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9\9modules.reframework_globals.imgui.end_rect(5);\
\9\9\9modules.reframework_globals.imgui.new_line();\
\9\9\9\
\9\9\9modules.reframework_globals.imgui.tree_pop();\
\9\9end\
\
\9\9changed = modules.position_customization.draw(\"boss_ui\", cached_config.boss_ui.position);\
\9\9config_changed = config_changed or changed;\
\
\9\9changed = modules.spacing_customization.draw(\"boss_ui\", cached_config.boss_ui.spacing);\
\9\9config_changed = config_changed or changed;\
\
\9\9changed = modules.label_customization.draw(\"boss_ui.name_label\", modules.utils.imgui.label(cached_language.name_label, \"boss_ui.name_label\"), cached_config.boss_ui.name_label);\
\9\9config_changed = config_changed or changed;\
\
\9\9if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.health, \"boss_ui.health\")) then\
\9        changed, cached_config.boss_ui.health.visible = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.visible, \"boss_ui.health.visible\"), cached_config.boss_ui.health.visible);\
            config_changed = config_changed or changed;\
\9\9\9\
            changed = modules.offset_customization.draw(\"boss_ui\", cached_config.boss_ui.health.offset);\
            config_changed = config_changed or changed;\
\9\9\9\
\9\9\9changed = modules.label_customization.draw(\"boss_ui.health.value_label\", cached_language.value_label, cached_config.boss_ui.health.value_label);\
            config_changed = config_changed or changed;\
\9\9\9\
\9\9\9changed = modules.label_customization.draw(\"boss_ui.health.percentage_label\", cached_language.percentage_label, cached_config.boss_ui.health.percentage_label);\
\9\9\9config_changed = config_changed or changed;\
\9\9\9\
\9\9\9changed = modules.bar_customization.draw(\"boss_ui.health.bar\", cached_language.bar, cached_config.boss_ui.health.bar);\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9modules.reframework_globals.imgui.tree_pop();\
\9\9end\
\9\9\
\9\9modules.reframework_globals.imgui.tree_pop();\
\9end\
\
\
\9changed = this.draw_debug();\
\9config_changed = config_changed or changed;\
\9\
\9modules.reframework_globals.imgui.end_window();\
\9modules.reframework_globals.imgui.pop_font();\
\
\9if language_changed then\
\9\9cached_config.language = modules.language.language_names[language_index];\
\9\9modules.language.update(language_index);\
\9\9this.init();\
\
\9\9this.reload_font();\
\9end\
\
\9if menu_font_changed then\
\9\9this.reload_font();\
\9end\
\
\9if enemy_filters_changed then\
\9\9for enemy_core, enemy in pairs(modules.enemy_handler.enemy_list) do\
\9\9\9modules.enemy_handler.update_is_filtered_out(enemy);\
\9\9end\
\9end\
\
\9if config_changed or language_changed or window_changed then\
\9\9modules.config.save();\
\9end\
end\
\
function this.draw_debug()\
    local cached_config = modules.config.current_config.debug;\
\9local cached_language = modules.language.current_language.customization_menu;\
\
\9local changed = false;\
\9local config_changed = false;\
\
\9if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.debug, \"debug\")) then\
\9\9\
\9\9modules.reframework_globals.imgui.text_colored(string.format(\"%s:\", cached_language.current_time), 0xFFAAAA66);\
\9\9modules.reframework_globals.imgui.same_line();\
\9\9modules.reframework_globals.imgui.text(string.format(\"%.3fs\", modules.time.total_elapsed_script_seconds));\
\
\9\9if modules.error_handler.is_empty then\
\9\9\9modules.reframework_globals.imgui.text(cached_language.everything_seems_to_be_ok);\
\9\9else\
\9\9\9for error_key, error in pairs(modules.error_handler.list) do\
\
\9\9\9\9modules.reframework_globals.imgui.button(modules.utils.imgui.label(string.format(\"%.3fs\", error.time), \"debug.list.list_entry_\" .. tostring(error)));\
\9\9\9\9modules.reframework_globals.imgui.same_line();\
\9\9\9\9modules.reframework_globals.imgui.text_colored(error_key, 0xFFAA66AA);\
\9\9\9\9modules.reframework_globals.imgui.same_line();\
\9\9\9\9modules.reframework_globals.imgui.text(error.message);\
\9\9\9end\
\9\9end\
\
\9\9if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.history, \"debug.history\")) then\
\
\9\9\9changed, cached_config.history_size = modules.reframework_globals.imgui.drag_int(\
\9\9\9\9modules.utils.imgui.label(cached_language.history_size, \"debug.history.history_size\"), cached_config.history_size, 1, 0, 1024);\
\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9if changed then\
\9\9\9\9modules.error_handler.history = {};\
\9\9\9end\
\
\9\9\9for index, error in pairs(modules.error_handler.history) do\
\9\9\9\9modules.reframework_globals.imgui.text_colored(index, 0xFF66AA66);\
\9\9\9\9modules.reframework_globals.imgui.same_line();\
\9\9\9\9modules.reframework_globals.imgui.button(modules.utils.imgui.label(string.format(\"%.3fs\", error.time), \"debug.history.history_entry_\" .. tostring(error)));\
\9\9\9\9modules.reframework_globals.imgui.same_line();\
\9\9\9\9modules.reframework_globals.imgui.text_colored(error.key, 0xFFAA66AA);\
\9\9\9\9modules.reframework_globals.imgui.same_line();\
\9\9\9\9modules.reframework_globals.imgui.text(error.message);\
\9\9\9end\
\
\
\9\9\9modules.reframework_globals.imgui.tree_pop();\
\9\9end\
\
\9\9modules.reframework_globals.imgui.tree_pop();\
\9end\
\
\9return config_changed;\
end\
\
function this.init_module()\
\9this.init();\
\9this.reload_font();\
end\
\
return this;", '@'..".\\Health_Bars\\customization\\customization_menu.lua" ) )

package.preload[ "Health_Bars.customization.customizations.bar_customization" ] = assert( (loadstring or load)( "local this = {};\
\
local modules = require(\"Health_Bars.modules\");\
\
local outline_styles = {};\
local displayed_outline_styles = {};\
\
local fill_directions = {};\
local displayed_fill_directions = {};\
\
function this.init()\
\9local cached_default_language = modules.language.default_language.customization_menu;\
\9local cached_current_language = modules.language.current_language.customization_menu;\
\
\9outline_styles = {\
\9\9cached_default_language.inside,\
\9\9cached_default_language.center,\
\9\9cached_default_language.outside\
\9};\
\
\9displayed_outline_styles = {\
\9\9cached_current_language.inside,\
\9\9cached_current_language.center,\
\9\9cached_current_language.outside\
\9};\
\
\9fill_directions = {\
\9\9cached_default_language.left_to_right,\
\9\9cached_default_language.right_to_left,\
\9\9cached_default_language.top_to_bottom,\
\9\9cached_default_language.bottom_to_top\
\9};\
\
\9displayed_fill_directions = {\
\9\9cached_current_language.left_to_right,\
\9\9cached_current_language.right_to_left,\
\9\9cached_current_language.top_to_bottom,\
\9\9cached_current_language.bottom_to_top\
\9};\
end\
\
function this.draw(id, bar_name, bar)\
\9local cached_language = modules.language.current_language.customization_menu;\
\
\9local bar_changed = false;\
\9local changed = false;\
    local index = 1;\
\
\
\9if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(bar_name, id)) then\
\9\9changed, bar.visible = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.visible, id, \"visible\"), bar.visible);\
        bar_changed = bar_changed or changed;\
\
        if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.settings, id, \"settings\")) then\
            local fill_direction_index = modules.utils.table.find_index(fill_directions, bar.settings.fill_direction);\
            changed, fill_direction_index = modules.reframework_globals.imgui.combo(modules.utils.imgui.label(cached_language.fill_direction, id, \"settings.fill_direction\"), fill_direction_index, displayed_fill_directions);\
            bar_changed = bar_changed or changed;\
\
            if changed then\
                bar.settings.fill_direction = fill_directions[fill_direction_index];\
            end\
\
            changed, bar.settings.inverted = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.inverted, id, \"settings.inverted\"), bar.settings.inverted);\
            bar_changed = bar_changed or changed;\
\
            modules.reframework_globals.imgui.tree_pop();\
        end\
\9\9\
\9\9changed = modules.offset_customization.draw(id, bar.offset);\
\9\9bar_changed = bar_changed or changed;\
\
\9\9if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.size, id, \"size\")) then\
\9\9\9changed, bar.size.width = modules.reframework_globals.imgui.drag_float(modules.utils.imgui.label(cached_language.width, id, \"size.width\"),\
\9\9\9\9bar.size.width, 0.1, 0, modules.screen.width, \"%.1f\");\
\9\9\9bar_changed = bar_changed or changed;\
\
\9\9\9changed, bar.size.height = modules.reframework_globals.imgui.drag_float(modules.utils.imgui.label(cached_language.height, id, \"size.height\"),\
\9\9\9\9bar.size.height, 0.1, 0, modules.screen.height, \"%.1f\");\
\9\9\9bar_changed = bar_changed or changed;\
\
\9\9\9modules.reframework_globals.imgui.tree_pop();\
\9\9end\
\
\9\9if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.outline, id, \"outline\")) then\
\9\9\9changed, bar.outline.visible = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.visible, id, \"outline.visible\")\
\9\9\9\9, bar.outline.visible);\
\9\9\9bar_changed = bar_changed or changed;\
\
\9\9\9changed, bar.outline.thickness = modules.reframework_globals.imgui.drag_float(modules.utils.imgui.label(cached_language.thickness, id, \"outline.thickness\"),\
\9\9\9\9bar.outline.thickness, 0.1, 0, modules.screen.width, \"%.1f\");\
\9\9\9bar_changed = bar_changed or changed;\
\
\9\9\9changed, bar.outline.offset = modules.reframework_globals.imgui.drag_float(modules.utils.imgui.label(cached_language.offset, id, \"outline.offset\"),\
\9\9\9\9bar.outline.offset, 0.1, -modules.screen.height, modules.screen.height, \"%.1f\");\
\9\9\9bar_changed = bar_changed or changed;\
\
\9\9\9changed, index = modules.reframework_globals.imgui.combo(modules.utils.imgui.label(cached_language.style, id, \"outline.style\"),\
\9\9\9\9modules.utils.table.find_index(outline_styles, bar.outline.style),\
\9\9\9\9displayed_outline_styles);\
\9\9\9bar_changed = bar_changed or changed;\
\
\9\9\9if changed then\
\9\9\9\9bar.outline.style = outline_styles[index];\
\9\9\9end\
\
\9\9\9modules.reframework_globals.imgui.tree_pop();\
\9\9end\
\
        if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.colors, id, \"colors\")) then\
            changed, bar.colors.foreground = modules.color_customization.draw(id .. \".colors.foreground\", cached_language.foreground, bar.colors.foreground);\
            bar_changed = bar_changed or changed;\
\
            changed, bar.colors.background = modules.color_customization.draw(id .. \".colors.background\", cached_language.background, bar.colors.background);\
            bar_changed = bar_changed or changed;\
\
            changed, bar.colors.outline = modules.color_customization.draw(id .. \".colors.outline\", cached_language.outline, bar.colors.outline);\
            bar_changed = bar_changed or changed;\
\
            modules.reframework_globals.imgui.tree_pop();\
        end\
\9\
\
\9\9bar_changed = bar_changed or changed;\
\
\9\9modules.reframework_globals.imgui.tree_pop();\
\9end\
\
\9return bar_changed;\
end\
\
function this.init_module()\
end\
\
return this;\
", '@'..".\\Health_Bars\\customization\\customizations\\bar_customization.lua" ) )

package.preload[ "Health_Bars.customization.customizations.color_customization" ] = assert( (loadstring or load)( "local this = {};\
\
local modules = require(\"Health_Bars.modules\");\
\
function this.draw(id, color_label, color)\
\9local color_changed = false;\
    local changed = false;\
\
\9if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(color_label, id)) then\
\9\9changed, color = modules.reframework_globals.imgui.color_picker_argb(modules.utils.imgui.label(\"\", id, \"color\"),  color, modules.customization_menu.color_picker_flags);\
\9\9color_changed = color_changed or changed;\
\
\9\9modules.reframework_globals.imgui.tree_pop();\
\9end\
\
\9return color_changed, color;\
end\
\
function this.init_module()\
end\
\
return this;", '@'..".\\Health_Bars\\customization\\customizations\\color_customization.lua" ) )

package.preload[ "Health_Bars.customization.customizations.label_customization" ] = assert( (loadstring or load)( "local this = {};\
\
local modules = require(\"Health_Bars.modules\");\
\
local include_names = {};\
\
this.alignments = {};\
local displayed_alignments = {};\
\
function this.init()\
    local cached_default_language = modules.language.default_language.customization_menu;\
\9local cached_current_language = modules.language.current_language.customization_menu;\
\
\9this.alignments = {\
\9\9cached_default_language.top_left,\
\9\9cached_default_language.top_middle,\
\9\9cached_default_language.top_right,\
\9\9cached_default_language.middle_left,\
\9\9cached_default_language.center,\
\9\9cached_default_language.middle_right,\
\9\9cached_default_language.bottom_left,\
\9\9cached_default_language.bottom_middle,\
\9\9cached_default_language.bottom_right\
\9};\
\
\9displayed_alignments = {\
\9\9cached_current_language.top_left,\
\9\9cached_current_language.top_middle,\
\9\9cached_current_language.top_right,\
\9\9cached_current_language.middle_left,\
\9\9cached_current_language.center,\
\9\9cached_current_language.middle_right,\
\9\9cached_current_language.bottom_left,\
\9\9cached_current_language.bottom_middle,\
\9\9cached_current_language.bottom_right\
    };\
\
\9include_names = {\
\9\9[\"current_value\"] = cached_current_language.current_value,\
\9\9[\"max_value\"] = cached_current_language.max_value\
\9};\
end\
\
function this.draw(id, label_name, label)\
\9local cached_language = modules.language.current_language.customization_menu;\
\
\9local label_changed = false;\
\9local changed = false;\
\
\9if modules.reframework_globals.imgui.tree_node(label_name) then\
\9\9changed, label.visible = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.visible, id, \"visible\"), label.visible);\
\9\9label_changed = label_changed or changed;\
\
\9\9if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.settings, id, \"settings\")) then\
\9\9\9local alignment_index = modules.utils.table.find_index(this.alignments, label.settings.alignment);\
\9\9\9changed, alignment_index = modules.reframework_globals.imgui.combo(modules.utils.imgui.label(cached_language.alignment, id, \"settings.alignment\"), alignment_index, displayed_alignments);\
\9\9\9label_changed = label_changed or changed;\
\
\9\9\9if changed then\
\9\9\9\9label.settings.alignment = this.alignments[alignment_index];\
\9\9\9end\
\
\9\9\9modules.reframework_globals.imgui.tree_pop();\
\9\9end\
\
\
\9\9if label.include ~= nil then\
\9\9\9if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.include, id, \"include\")) then\
\9\9\9\9for include_name, include in pairs(label.include) do\
\9\9\9\9\9changed, label.include[include_name] = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(include_names[include_name], id, include_names[include_name]), include);\
\9\9\9\9\9label_changed = label_changed or changed;\
\9\9\9\9end\
\
\9\9\9\9modules.reframework_globals.imgui.tree_pop();\
\9\9\9end\
\9\9end\
\9\9\
\
\9\9changed = modules.offset_customization.draw(id, label.offset);\
        label_changed = label_changed or changed;\
\9\9\
\9\9changed, label.color = modules.color_customization.draw(id .. \".color\", cached_language.color, label.color);\
\9\9label_changed = label_changed or changed;\
\
\9\9if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.shadow, id, \"shadow\")) then\
\9\9\9changed, label.shadow.visible = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(cached_language.visible, id, \"shadow.visible\"), label.shadow.visible);\
\9\9\9label_changed = label_changed or changed;\
\
\9\9\9changed = modules.offset_customization.draw(id .. \".shadow\", label.shadow.offset);\
            label_changed = label_changed or changed;\
\9\9\9\
\9\9\9changed, label.shadow.color = modules.color_customization.draw(id .. \".shadow.color\", cached_language.color, label.shadow.color);\
            label_changed = label_changed or changed;\
\
\9\9\9modules.reframework_globals.imgui.tree_pop();\
\9\9end\
\
\9\9modules.reframework_globals.imgui.tree_pop();\
\9end\
\
\9return label_changed;\
end\
\
function this.init_module()\
end\
\
return this;", '@'..".\\Health_Bars\\customization\\customizations\\label_customization.lua" ) )

package.preload[ "Health_Bars.customization.customizations.offset_customization" ] = assert( (loadstring or load)( "local this = {};\
\
local modules = require(\"Health_Bars.modules\");\
\
function this.draw(id, offset)\
\9local cached_language = modules.language.current_language.customization_menu;\
\
\9local offset_changed = false;\
\9local changed = false;\
\
\9if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.offset, id, \"offset\")) then\
\9\9changed, offset.x = modules.reframework_globals.imgui.drag_float(modules.utils.imgui.label(cached_language.x, id, \"offset.x\"),\
\9\9\9offset.x, 0.1, -modules.screen.width, modules.screen.width, \"%.1f\");\
\9\9offset_changed = offset_changed or changed;\
\
        changed, offset.y = modules.reframework_globals.imgui.drag_float(modules.utils.imgui.label(cached_language.y, id, \"offset.y\"),\
\9\9\9offset.y, 0.1, -modules.screen.height, modules.screen.height, \"%.1f\");\
\9\9offset_changed = offset_changed or changed;\
\
\9\9modules.reframework_globals.imgui.tree_pop();\
\9end\
\
\9return offset_changed;\
end\
\
function this.init_module()\
end\
\
return this;", '@'..".\\Health_Bars\\customization\\customizations\\offset_customization.lua" ) )

package.preload[ "Health_Bars.customization.customizations.position_customization" ] = assert( (loadstring or load)( "local this = {};\
\
local modules = require(\"Health_Bars.modules\");\
\
this.anchors = {};\
local displayed_anchors = {};\
\
function this.init()\
\9local cached_default_language = modules.language.default_language.customization_menu;\
\9local cached_current_language = modules.language.current_language.customization_menu;\
\
\9this.anchors = {\
\9\9cached_default_language.top_left,\
\9\9cached_default_language.top_middle,\
\9\9cached_default_language.top_right,\
\9\9cached_default_language.middle_left,\
\9\9cached_default_language.center,\
\9\9cached_default_language.middle_right,\
\9\9cached_default_language.bottom_left,\
\9\9cached_default_language.bottom_middle,\
\9\9cached_default_language.bottom_right\
\9};\
\
\9displayed_anchors = {\
\9\9cached_current_language.top_left,\
\9\9cached_current_language.top_middle,\
\9\9cached_current_language.top_right,\
\9\9cached_current_language.middle_left,\
\9\9cached_current_language.center,\
\9\9cached_current_language.middle_right,\
\9\9cached_current_language.bottom_left,\
\9\9cached_current_language.bottom_middle,\
\9\9cached_current_language.bottom_right\
    };\
end\
\
function this.draw(id, position)\
\9local cached_language = modules.language.current_language.customization_menu;\
\
\9local position_changed = false;\
\9local changed = false;\
\
\9if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.position, \"position\")) then\
\9\9changed, position.x = modules.reframework_globals.imgui.drag_float(modules.utils.imgui.label(cached_language.x, id, \"position.x\"),\
\9\9\9position.x, 0.1, -modules.screen.width, modules.screen.width, \"%.1f\");\
\9\9position_changed = position_changed or changed;\
\
        changed, position.y = modules.reframework_globals.imgui.drag_float(modules.utils.imgui.label(cached_language.y, id, \"position.y\"),\
\9\9\9position.y, 0.1, -modules.screen.height, modules.screen.height, \"%.1f\");\
\9\9position_changed = position_changed or changed;\
\
\9\9local anchor_index = modules.utils.table.find_index(this.anchors, position.anchor);\
\9\9changed, anchor_index = modules.reframework_globals.imgui.combo(modules.utils.imgui.label(cached_language.anchor, id, \"position.anchor\"), anchor_index, displayed_anchors);\
\9\9position_changed = position_changed or changed;\
\
\9\9if changed then\
\9\9\9position.anchor = this.anchors[anchor_index];\
\9\9end\
\
\9\9modules.reframework_globals.imgui.tree_pop();\
\9end\
\
\9return position_changed;\
end\
\
function this.init_module()\
end\
\
return this;", '@'..".\\Health_Bars\\customization\\customizations\\position_customization.lua" ) )

package.preload[ "Health_Bars.customization.customizations.spacing_customization" ] = assert( (loadstring or load)( "local this = {};\
\
local modules = require(\"Health_Bars.modules\");\
\
function this.draw(id, spacing)\
\9local cached_language = modules.language.current_language.customization_menu;\
\
\9local spacing_changed = false;\
\9local changed = false;\
\
\9if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.spacing, id, \"spacing\")) then\
\9\9changed, spacing.x = modules.reframework_globals.imgui.drag_float(modules.utils.imgui.label(cached_language.x, id, \"spacing.x\"),\
\9\9\9spacing.x, 0.1, -modules.screen.width, modules.screen.width, \"%.1f\");\
\9\9spacing_changed = spacing_changed or changed;\
\
        changed, spacing.y = modules.reframework_globals.imgui.drag_float(modules.utils.imgui.label(cached_language.y, id, \"spacing.y\"),\
\9\9\9spacing.y, 0.1, -modules.screen.height, modules.screen.height, \"%.1f\");\
\9\9spacing_changed = spacing_changed or changed;\
\
\9\9modules.reframework_globals.imgui.tree_pop();\
\9end\
\
\9return spacing_changed;\
end\
\
function this.init_module()\
end\
\
return this;", '@'..".\\Health_Bars\\customization\\customizations\\spacing_customization.lua" ) )

package.preload[ "Health_Bars.customization.customizations.world_offset_customization" ] = assert( (loadstring or load)( "local this = {};\
\
local modules = require(\"Health_Bars.modules\");\
\
function this.draw(id, offset)\
\9local cached_language = modules.language.current_language.customization_menu;\
\
\9local offset_changed = false;\
\9local changed = false;\
\
\9if modules.reframework_globals.imgui.tree_node(modules.utils.imgui.label(cached_language.world_offset, id, \"world_offset\")) then\
\9\9changed, offset.x = modules.reframework_globals.imgui.drag_float(modules.utils.imgui.label(cached_language.x, id, \"world_offset.x\"),\
\9\9\9offset.x, 0.001, -modules.screen.width, modules.screen.width, \"%.3f\");\
\9\9offset_changed = offset_changed or changed;\
\
        changed, offset.y = modules.reframework_globals.imgui.drag_float(modules.utils.imgui.label(cached_language.y, id, \"world_offset.y\"),\
\9\9\9offset.y, 0.001, -modules.screen.width, modules.screen.width, \"%.3f\");\
\9\9offset_changed = offset_changed or changed;\
\
\9\9changed, offset.z = modules.reframework_globals.imgui.drag_float(modules.utils.imgui.label(cached_language.z, id, \"world_offset.z\"),\
\9\9\9offset.z, 0.001, -modules.screen.width, modules.screen.width, \"%.3f\");\
\9\9offset_changed = offset_changed or changed;\
\
\9\9modules.reframework_globals.imgui.tree_pop();\
\9end\
\
\9return offset_changed;\
end\
\
function this.init_module()\
end\
\
return this;", '@'..".\\Health_Bars\\customization\\customizations\\world_offset_customization.lua" ) )

package.preload[ "Health_Bars.customization_menu" ] = assert( (loadstring or load)( "local this = {};\
\
local utils;\
local config;\
local language;\
local label_customization;\
local bar_customization;\
local time;\
local enemy_handler;\
local error_handler;\
\
local sdk = sdk;\
local tostring = tostring;\
local pairs = pairs;\
local ipairs = ipairs;\
local tonumber = tonumber;\
local require = require;\
local pcall = pcall;\
local table = table;\
local string = string;\
local Vector3f = Vector3f;\
local d2d = d2d;\
local math = math;\
local json = json;\
local log = log;\
local fs = fs;\
local next = next;\
local type = type;\
local setmetatable = setmetatable;\
local getmetatable = getmetatable;\
local assert = assert;\
local select = select;\
local coroutine = coroutine;\
local utf8 = utf8;\
local re = re;\
local imgui = imgui;\
local draw = draw;\
local Vector2f = Vector2f;\
local reframework = reframework;\
local os = os;\
\
this.font = nil;\
this.full_font_range = {0x1, 0xFFFF, 0};\
this.is_opened = false;\
\
this.window_position = Vector2f.new(480, 200);\
this.window_pivot = Vector2f.new(0, 0);\
this.window_size = Vector2f.new(650, 700);\
this.window_flags = 0x10120;\
this.color_picker_flags = 327680;\
this.decimal_input_flags = 33;\
\
this.config_changed = false;\
\
this.fonts = {\9\"Arial\", \"Arial Black\", \"Bahnschrift\", \"Calibri\", \"Cambria\", \"Cambria Math\", \"Candara\",\
\9\9\9\9\"Comic Sans MS\", \"Consolas\", \"Constantia\", \"Corbel\", \"Courier New\", \"Ebrima\",\
\9\9\9\9\"Franklin Gothic Medium\", \"Gabriola\", \"Gadugi\", \"Georgia\", \"HoloLens MDL2 Assets\", \"Impact\",\
\9\9\9\9\"Ink Free\", \"Javanese Text\", \"Leelawadee UI\", \"Lucida Console\", \"Lucida Sans Unicode\",\
\9\9\9\9\"Malgun Gothic\", \"Marlett\", \"Microsoft Himalaya\", \"Microsoft JhengHei\", \"Microsoft New Tai Lue\",\
\9\9\9\9\"Microsoft PhagsPa\", \"Microsoft Sans Serif\", \"Microsoft Tai Le\", \"Microsoft YaHei\",\
\9\9\9\9\"Microsoft Yi Baiti\", \"MingLiU-ExtB\", \"Mongolian Baiti\", \"MS Gothic\", \"MV Boli\", \"Myanmar Text\",\
\9\9\9\9\"Nirmala UI\", \"Palatino Linotype\", \"Segoe MDL2 Assets\", \"Segoe Print\", \"Segoe Script\", \"Segoe UI\",\
\9\9\9\9\"Segoe UI Historic\", \"Segoe UI Emoji\", \"Segoe UI Symbol\", \"SimSun\", \"Sitka\", \"Sylfaen\", \"Symbol\",\
\9\9\9\9\"Tahoma\", \"Times New Roman\", \"Trebuchet MS\", \"Verdana\", \"Webdings\", \"Wingdings\", \"Yu Gothic\"\
};\
\
function this.reload_font(pop_push)\
\9local cached_language = language.current_language;\
\
\9local font_range = cached_language.unicode_glyph_ranges;\
\
\9if cached_language.font_name == \"\" then\
\9\9font_range = nil;\
\
\9elseif cached_language.unicode_glyph_ranges == nil\
\9or utils.table.is_empty(cached_language.unicode_glyph_ranges)\
\9or #cached_language.unicode_glyph_ranges == 1\
\9or not utils.number.is_odd(#cached_language.unicode_glyph_ranges)\
\9 then\
\
\9\9font_range = this.full_font_range;\
\9end\
\
\9this.font = imgui.load_font(cached_language.font_name,\
\9\9config.current_config.menu_font.size, font_range);\
\
\9if pop_push then\
\9\9imgui.pop_font();\
\9\9imgui.push_font(this.font);\
\9end\
end\
\
function this.init()\
\9label_customization.init();\
\9bar_customization.init();\
end\
\
function this.draw()\
\9local cached_config = config.current_config;\
\9local cached_language = language.current_language.customization_menu;\
\
\9local window_position = Vector2f.new(config.current_config.customization_menu.position.x, config.current_config.customization_menu.position.y);\
\9local window_pivot = Vector2f.new(config.current_config.customization_menu.pivot.x, config.current_config.customization_menu.pivot.y);\
\9local window_size = Vector2f.new(config.current_config.customization_menu.size.width, config.current_config.customization_menu.size.height);\
\
\9imgui.set_next_window_pos(window_position, 1 << 3, window_pivot);\
\9imgui.set_next_window_size(window_size, 1 << 3);\
\
\9imgui.push_font(this.font);\
\
\9this.is_opened = imgui.begin_window(\
\9\9cached_language.mod_name .. \" v\" .. config.current_config.version, this.is_opened, this.window_flags);\
\
\9if not this.is_opened then\
\9\9imgui.pop_font();\
\9\9imgui.end_window();\
\9\9return;\
\9end\
\
\9local changed = false;\
\9local config_changed = false;\
\9local enemy_filters_changed = false;\
\9local timer_delays_changed = false;\
\9local language_changed = false;\
\9local menu_font_changed = false;\
\9local window_changed = false;\
\9\
\9local index = 1;\
\9local language_index = 1;\
\
\9local new_window_position = imgui.get_window_pos();\
\9if window_position.x ~= new_window_position.x or window_position.y ~= new_window_position.y then\
\9\9window_changed = window_changed or true;\
\
\9\9config.current_config.customization_menu.position.x = new_window_position.x;\
\9\9config.current_config.customization_menu.position.y = new_window_position.y;\
\9end\
\
\9local new_window_size = imgui.get_window_size();\
\9if window_size.x ~= new_window_size.x or window_size.y ~= new_window_size.y then\
\9\9window_changed = window_changed or true;\
\
\9\9config.current_config.customization_menu.size.width = new_window_size.x;\
\9\9config.current_config.customization_menu.size.height = new_window_size.y;\
\9end\
\
\9if imgui.button(cached_language.reset_config) then\
\9\9config.reset();\
\9\9config_changed = true;\
\9end\
\
\9changed, cached_config.enabled = imgui.checkbox(cached_language.enabled, cached_config.enabled);\
\9config_changed = config_changed or changed;\
\
\9if imgui.tree_node(cached_language.language) then\
\9\9imgui.text(cached_language.menu_font_change_disclaimer);\
\
\9\9changed, language_index = imgui.combo(cached_language.language,\
\9\9\9utils.table.find_index(language.language_names, cached_config.language), language.language_names);\
\
\9\9config_changed = config_changed or changed;\
\9\9language_changed = language_changed or changed;\
\
\9\9imgui.tree_pop();\
\9end\
\
\9if imgui.tree_node(language.current_language.customization_menu.menu_font) then\
\9\9imgui.text(cached_language.menu_font_change_disclaimer);\
\
\9\9local new_value = cached_config.menu_font.size;\
\9\9changed, new_value = imgui.input_text(\" \", cached_config.menu_font.size, this.decimal_input_flags);\
\9\9new_value = tonumber(new_value);\
\
\9\9if new_value ~= nil then\
\9\9\9if new_value < 5 then\
\9\9\9\9new_value = 5;\
\9\9\9elseif new_value > 100 then\
\9\9\9\9new_value = 100;\
\9\9\9end\
\
\9\9\9cached_config.menu_font.size = math.floor(new_value);\
\9\9end\
\
\9\9config_changed = config_changed or changed;\
\9\9this.menu_font_changed = this.menu_font_changed or changed;\
\
\9\9imgui.same_line();\
\
\9\9changed = imgui.button(\"-\");\
\9\9config_changed = config_changed or changed;\
\
\9\9imgui.same_line();\
\
\9\9if changed then\
\9\9\9cached_config.menu_font.size = cached_config.menu_font.size - 1;\
\
\9\9\9if cached_config.menu_font.size < 5 then\
\9\9\9\9cached_config.menu_font.size = 5;\
\9\9\9else\
\9\9\9\9this.menu_font_changed = this.menu_font_changed or changed;\
\9\9\9end\
\9\9end\
\
\9\9changed = imgui.button(\"+\");\
\9\9config_changed = config_changed or changed;\
\
\9\9imgui.same_line();\
\
\9\9if changed then\
\9\9\9cached_config.menu_font.size = cached_config.menu_font.size + 1;\
\
\9\9\9if cached_config.menu_font.size > 100 then\
\9\9\9\9cached_config.menu_font.size = 100;\
\9\9\9else\
\9\9\9\9this.menu_font_changed = this.menu_font_changed or changed;\
\9\9\9end\
\9\9end\
\
\9\9imgui.text(language.current_language.customization_menu.size);\
\
\9\9if imgui.button(language.current_language.customization_menu.apply) then\
\9\9\9menu_font_changed = true;\
\9\9end\
\
\9\9imgui.tree_pop();\
\9end\
\
\9if imgui.tree_node(cached_language.ui_font) then\
\9\9imgui.text(cached_language.font_notice);\
\9\9\
\9\9changed, index = imgui.combo(cached_language.family,\
\9\9\9utils.table.find_index(this.fonts, cached_config.ui_font.family), this.fonts);\
\9\9config_changed = config_changed or changed;\
\
\9\9if changed then\
\9\9\9cached_config.ui_font.family = this.fonts[index];\
\9\9end\
\
\9\9changed, cached_config.ui_font.size = imgui.slider_int(cached_language.size,\
\9\9\9cached_config.ui_font.size, 1, 100);\
\9\9config_changed = config_changed or changed;\
\
\9\9changed, cached_config.ui_font.bold = imgui.checkbox(cached_language.bold,\
\9\9\9cached_config.ui_font.bold);\
\9\9config_changed = config_changed or changed;\
\
\9\9changed, cached_config.ui_font.italic = imgui.checkbox(cached_language.italic,\
\9\9\9cached_config.ui_font.italic);\
\9\9config_changed = config_changed or changed;\
\
\9\9imgui.tree_pop();\
\
\9end\
\
\9if imgui.tree_node(cached_language.settings) then\
\9\9if imgui.tree_node(language.current_language.customization_menu.timer_delays) then\
\
\9\9\9changed, cached_config.settings.timer_delays.update_singletons_delay = imgui.drag_float(\
\9\9\9\9language.current_language.customization_menu.update_singletons_delay,\
\9\9\9\9cached_config.settings.timer_delays.update_singletons_delay, 0.001, 0, 5, \"%.3f\");\
\9\9\9\
\9\9\9config_changed = config_changed or changed;\
\9\9\9timer_delays_changed = timer_delays_changed or changed;\
\
\9\9\9changed, cached_config.settings.timer_delays.update_window_size_delay = imgui.drag_float(\
\9\9\9\9language.current_language.customization_menu.update_window_size_delay,\
\9\9\9\9cached_config.settings.timer_delays.update_window_size_delay, 0.001, 0, 5, \"%.3f\");\
\9\9\9\
\9\9\9config_changed = config_changed or changed;\
\9\9\9timer_delays_changed = timer_delays_changed or changed;\
\9\9\9\
\9\9\9changed, cached_config.settings.timer_delays.update_game_data_delay = imgui.drag_float(\
\9\9\9\9language.current_language.customization_menu.update_game_data_delay,\
\9\9\9\9cached_config.settings.timer_delays.update_game_data_delay, 0.001, 0, 5, \"%.3f\");\
\9\9\9\
\9\9\9config_changed = config_changed or changed;\
\9\9\9timer_delays_changed = timer_delays_changed or changed;\
\
\9\9\9changed, cached_config.settings.timer_delays.update_player_data_delay = imgui.drag_float(\
\9\9\9\9language.current_language.customization_menu.update_player_data_delay,\
\9\9\9\9cached_config.settings.timer_delays.update_player_data_delay, 0.001, 0, 5, \"%.3f\");\
\9\9\9\
\9\9\9config_changed = config_changed or changed;\
\9\9\9timer_delays_changed = timer_delays_changed or changed;\
\
\9\9\9changed, cached_config.settings.timer_delays.update_enemy_data_delay = imgui.drag_float(\
\9\9\9\9language.current_language.customization_menu.update_enemy_data_delay,\
\9\9\9\9cached_config.settings.timer_delays.update_enemy_data_delay, 0.001, 0, 5, \"%.3f\");\
\9\9\9\
\9\9\9config_changed = config_changed or changed;\
\9\9\9timer_delays_changed = timer_delays_changed or changed;\
\
\9\9\9imgui.tree_pop();\
\9\9end\
\
\9\9imgui.new_line();\
\9\9imgui.begin_rect()\
\
\9\9changed, cached_config.settings.use_d2d_if_available = imgui.checkbox(cached_language.use_d2d_renderer_if_available,\
\9\9\9cached_config.settings.use_d2d_if_available);\
\9\9config_changed = config_changed or changed;\
\
\9\9imgui.end_rect(5);\
\9\9imgui.new_line();\
\9\9imgui.begin_rect()\
\
\9\9changed, cached_config.settings.render_during_cutscenes = imgui.checkbox(cached_language.render_during_cutscenes,\
\9\9\9cached_config.settings.render_during_cutscenes);\
\9\9config_changed = config_changed or changed;\
\
\9\9changed, cached_config.settings.render_when_game_timer_is_paused = imgui.checkbox(cached_language.render_when_game_timer_is_paused,\
\9\9\9cached_config.settings.render_when_game_timer_is_paused);\
\9\9config_changed = config_changed or changed;\
\
\9\9changed, cached_config.settings.render_in_mercenaries = imgui.checkbox(cached_language.render_in_mercenaries,\
\9\9\9cached_config.settings.render_in_mercenaries);\
\9\9config_changed = config_changed or changed;\
\9\
\9\9imgui.end_rect(5);\
\9\9imgui.new_line();\
\9\9imgui.begin_rect();\
\
\9\9changed, cached_config.settings.render_aim_target_enemy = imgui.checkbox(cached_language.render_aim_target_enemy,\
\9\9\9cached_config.settings.render_aim_target_enemy);\
\9\9config_changed = config_changed or changed;\
\
\9\9changed, cached_config.settings.render_damaged_enemies = imgui.checkbox(cached_language.render_damaged_enemies,\
\9\9\9cached_config.settings.render_damaged_enemies);\
\9\9config_changed = config_changed or changed;\
\
\9\9changed, cached_config.settings.render_everyone_else = imgui.checkbox(cached_language.render_everyone_else,\
\9\9\9cached_config.settings.render_everyone_else);\
\9\9config_changed = config_changed or changed;\
\9\9\
\9\9imgui.end_rect(5);\
\9\9imgui.new_line();\
\9\9imgui.begin_rect()\
\9\9\
\9\9changed, cached_config.settings.render_when_normal = imgui.checkbox(cached_language.render_when_normal,\
\9\9\9cached_config.settings.render_when_normal);\
\9\9config_changed = config_changed or changed;\
\
\9\9changed, cached_config.settings.render_when_aiming = imgui.checkbox(cached_language.render_when_aiming,\
\9\9\9cached_config.settings.render_when_aiming);\
\9\9config_changed = config_changed or changed;\
\
\9\9changed, cached_config.settings.render_when_using_scope = imgui.checkbox(cached_language.render_when_using_scope,\
\9\9\9cached_config.settings.render_when_using_scope);\
\9\9config_changed = config_changed or changed;\
\
\9\9imgui.end_rect(5);\
\9\9imgui.new_line();\
\9\9imgui.begin_rect()\
\
\9\9changed, cached_config.settings.hide_if_dead = imgui.checkbox(cached_language.hide_if_dead,\
\9\9\9cached_config.settings.hide_if_dead);\
\9\9config_changed = config_changed or changed;\
\
\9\9changed, cached_config.settings.hide_if_full_health = imgui.checkbox(cached_language.hide_if_full_health,\
\9\9\9cached_config.settings.hide_if_full_health);\
\9\9config_changed = config_changed or changed;\
\
\9\9changed, cached_config.settings.hide_if_enemy_model_is_not_being_rendered = imgui.checkbox(cached_language.hide_if_enemy_model_is_not_being_rendered,\
\9\9\9cached_config.settings.hide_if_enemy_model_is_not_being_rendered);\
\9\9config_changed = config_changed or changed;\
\
\9\9changed, cached_config.settings.hide_if_no_update_function_is_being_called = imgui.checkbox(cached_language.hide_if_no_update_function_is_being_called,\
\9\9\9cached_config.settings.hide_if_no_update_function_is_being_called);\
\9\9config_changed = config_changed or changed;\
\
\9\9imgui.end_rect(5);\
\9\9imgui.new_line();\
\9\9imgui.begin_rect();\
\
\9\9changed, cached_config.settings.hide_leonardo = imgui.checkbox(cached_language.hide_leonardo,\
\9\9\9cached_config.settings.hide_leonardo);\
\9\9config_changed = config_changed or changed;\
\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9changed, cached_config.settings.hide_duke = imgui.checkbox(cached_language.hide_duke,\
\9\9\9cached_config.settings.hide_duke);\
\9\9config_changed = config_changed or changed;\
\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9imgui.new_line();\
\
\9\9changed, cached_config.settings.hide_blue_bird = imgui.checkbox(cached_language.hide_blue_bird,\
\9\9\9cached_config.settings.hide_blue_bird);\
\9\9config_changed = config_changed or changed;\
\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9changed, cached_config.settings.hide_pigs = imgui.checkbox(cached_language.hide_pigs,\
\9\9\9cached_config.settings.hide_pigs);\
\9\9config_changed = config_changed or changed;\
\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9changed, cached_config.settings.hide_chickens = imgui.checkbox(cached_language.hide_chickens,\
\9\9\9cached_config.settings.hide_chickens);\
\9\9config_changed = config_changed or changed;\
\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9changed, cached_config.settings.hide_goats = imgui.checkbox(cached_language.hide_goats,\
\9\9\9cached_config.settings.hide_goats);\
\9\9config_changed = config_changed or changed;\
\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9changed, cached_config.settings.hide_fish = imgui.checkbox(cached_language.hide_fish,\
\9\9\9cached_config.settings.hide_fish);\
\9\9config_changed = config_changed or changed;\
\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9changed, cached_config.settings.hide_catfish = imgui.checkbox(cached_language.hide_catfish,\
\9\9\9cached_config.settings.hide_catfish);\
\9\9config_changed = config_changed or changed;\
\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9imgui.new_line();\
\
\9\9changed, cached_config.settings.hide_rose_copies = imgui.checkbox(cached_language.hide_rose_copies,\
\9\9\9cached_config.settings.hide_rose_copies);\
\9\9config_changed = config_changed or changed;\
\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9changed, cached_config.settings.hide_masked_duke = imgui.checkbox(cached_language.hide_masked_duke,\
\9\9\9cached_config.settings.hide_masked_duke);\
\9\9config_changed = config_changed or changed;\
\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9changed, cached_config.settings.hide_mia_dolls = imgui.checkbox(cached_language.hide_mia_dolls,\
\9\9\9cached_config.settings.hide_mia_dolls);\
\9\9config_changed = config_changed or changed;\
\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9changed, cached_config.settings.hide_dolls = imgui.checkbox(cached_language.hide_dolls,\
\9\9\9cached_config.settings.hide_dolls);\
\9\9config_changed = config_changed or changed;\
\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9changed, cached_config.settings.hide_rose_illusion = imgui.checkbox(cached_language.hide_rose_illusion,\
\9\9\9cached_config.settings.hide_rose_illusion);\
\9\9config_changed = config_changed or changed;\
\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9changed, cached_config.settings.hide_miranda_crows = imgui.checkbox(cached_language.hide_miranda_crows,\
\9\9\9cached_config.settings.hide_miranda_crows);\
\9\9config_changed = config_changed or changed;\
\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9changed, cached_config.settings.hide_ethan_dlc = imgui.checkbox(cached_language.hide_ethan_in_dlc,\
\9\9\9cached_config.settings.hide_ethan_dlc);\
\9\9config_changed = config_changed or changed;\
\9\9enemy_filters_changed = enemy_filters_changed or changed;\
\
\9\9imgui.end_rect(5);\
\9\9imgui.new_line();\
\9\9imgui.begin_rect()\
\
\9\9changed, cached_config.settings.opacity_falloff = imgui.checkbox(cached_language.opacity_falloff,\
\9\9\9cached_config.settings.opacity_falloff);\
\9\9config_changed = config_changed or changed;\
\
\9\9changed, cached_config.settings.max_distance = imgui.drag_float(cached_language.max_distance,\
\9\9\9cached_config.settings.max_distance, 1, 0, 10000, \"%.0f\");\
\9\9config_changed = config_changed or changed;\
\
\9\9changed, cached_config.settings.scope_opacity_falloff = imgui.checkbox(cached_language.opacity_Falloff_scope,\
\9\9\9cached_config.settings.scope_opacity_falloff);\
\9\9config_changed = config_changed or changed;\
\
\9\9changed, cached_config.settings.scope_max_distance = imgui.drag_float(cached_language.max_distance_scope,\
\9\9\9cached_config.settings.scope_max_distance, 1, 0, 10000, \"%.0f\");\
\9\9config_changed = config_changed or changed;\
\
\9\9imgui.end_rect(5);\
\9\9imgui.new_line();\
\9\9imgui.begin_rect()\
\
\9\9changed, cached_config.settings.apply_time_duration_on_aiming = imgui.checkbox(cached_language.apply_time_duration_on_aiming,\
\9\9\9cached_config.settings.apply_time_duration_on_aiming);\
\9\9config_changed = config_changed or changed;\
\
\9\9changed, cached_config.settings.apply_time_duration_on_aim_target = imgui.checkbox(cached_language.apply_time_duration_on_aim_target,\
\9\9\9cached_config.settings.apply_time_duration_on_aim_target);\
\9\9config_changed = config_changed or changed;\
\
\9\9changed, cached_config.settings.apply_time_duration_on_using_scope = imgui.checkbox(cached_language.apply_time_duration_on_using_scope,\
\9\9\9cached_config.settings.apply_time_duration_on_using_scope);\
\9\9config_changed = config_changed or changed;\
\
\9\9changed, cached_config.settings.apply_time_duration_on_damage_dealt = imgui.checkbox(cached_language.apply_time_duration_on_damage_dealt,\
\9\9\9cached_config.settings.apply_time_duration_on_damage_dealt);\
\9\9config_changed = config_changed or changed;\
\
\9\9changed, cached_config.settings.reset_time_duration_on_aim_target_for_everyone = imgui.checkbox(cached_language.reset_time_duration_on_aim_target_for_everyone,\
\9\9\9cached_config.settings.reset_time_duration_on_aim_target_for_everyone);\
\9\9config_changed = config_changed or changed;\
\
\9\9changed, cached_config.settings.reset_time_duration_on_damage_dealt_for_everyone = imgui.checkbox(cached_language.reset_time_duration_on_damage_dealt_for_everyone,\
\9\9\9cached_config.settings.reset_time_duration_on_damage_dealt_for_everyone);\
\9\9config_changed = config_changed or changed;\
\
\9\9changed, cached_config.settings.time_duration = imgui.drag_float(cached_language.time_duration,\
\9\9\9cached_config.settings.time_duration, 0.1, 0, 1000, \"%.1f\");\
\
\9\9imgui.end_rect(5);\
\9\9imgui.new_line();\
\9\9\
\9\9imgui.tree_pop();\
\9end\
\
\9if imgui.tree_node(cached_language.world_offset) then\
\9\9changed, cached_config.world_offset.x = imgui.drag_float(cached_language.x,\
\9\9\9cached_config.world_offset.x, 0.01, -10, 10, \"%.2f\");\
\
\9\9config_changed = config_changed or changed;\
\
\9\9changed, cached_config.world_offset.y = imgui.drag_float(cached_language.y,\
\9\9\9cached_config.world_offset.y, 0.01, -10, 10, \"%.2f\");\
\
\9\9config_changed = config_changed or changed;\
\
\9\9changed, cached_config.world_offset.z = imgui.drag_float(cached_language.z,\
\9\9\9\9cached_config.world_offset.z, 0.01, -10, 10, \"%.2f\");\
\
\9\9config_changed = config_changed or changed;\
\
\9\9imgui.tree_pop();\
\9end\
\
\9changed = label_customization.draw(cached_language.health_value_label, cached_config.health_value_label);\
\9config_changed = config_changed or changed;\
\9\
\9changed = bar_customization.draw(cached_language.health_bar, cached_config.health_bar);\
\9config_changed = config_changed or changed;\
\
\9changed = this.draw_debug();\
\9config_changed = config_changed or changed;\
\9\
\9imgui.end_window();\
\9imgui.pop_font();\
\
\9if timer_delays_changed then\
\9\9time.init_global_timers();\
\9end\
\
\9if language_changed then\
\9\9cached_config.language = language.language_names[language_index];\
\9\9language.update(language_index);\
\9\9this.init();\
\
\9\9this.reload_font();\
\9end\
\
\9if menu_font_changed then\
\9\9this.reload_font();\
\9end\
\
\9if enemy_filters_changed then\
\9\9for enemy_core, enemy in pairs(enemy_handler.enemy_list) do\
\9\9\9enemy_handler.update_is_filtered_out(enemy);\
\9\9end\
\9end\
\
\9if config_changed or language_changed or window_changed then\
\9\9config.save();\
\9end\
end\
\
function this.draw_debug()\
\9local cached_config = config.current_config.debug;\
\
\9local changed = false;\
\9local config_changed = false;\
\
\9if imgui.tree_node(language.current_language.customization_menu.debug) then\
\9\9\
\9\9imgui.text_colored(string.format(\"%s:\", language.current_language.customization_menu.current_time), 0xFFAAAA66);\
\9\9imgui.same_line();\
\9\9imgui.text(string.format(\"%.3fs\", time.total_elapsed_script_seconds));\
\
\9\9if error_handler.is_empty then\
\9\9\9imgui.text(language.current_language.customization_menu.everything_seems_to_be_ok);\
\9\9else\
\9\9\9for error_key, error in pairs(error_handler.list) do\
\
\9\9\9\9imgui.button(string.format(\"%.3fs\", error.time));\
\9\9\9\9imgui.same_line();\
\9\9\9\9imgui.text_colored(error_key, 0xFFAA66AA);\
\9\9\9\9imgui.same_line();\
\9\9\9\9imgui.text(error.message);\
\9\9\9end\
\9\9end\
\
\9\9if imgui.tree_node(language.current_language.customization_menu.history) then\
\
\9\9\9changed, cached_config.history_size = imgui.drag_int(\
\9\9\9\9language.current_language.customization_menu.history_size, cached_config.history_size, 1, 0, 1024);\
\
\9\9\9config_changed = config_changed or changed;\
\
\9\9\9if changed then\
\9\9\9\9error_handler.history = {};\
\9\9\9end\
\
\9\9\9for index, error in pairs(error_handler.history) do\
\9\9\9\9imgui.text_colored(index, 0xFF66AA66);\
\9\9\9\9imgui.same_line();\
\9\9\9\9imgui.button(string.format(\"%.3fs\", error.time));\
\9\9\9\9imgui.same_line();\
\9\9\9\9imgui.text_colored(error.key, 0xFFAA66AA);\
\9\9\9\9imgui.same_line();\
\9\9\9\9imgui.text(error.message);\
\9\9\9end\
\
\
\9\9\9imgui.tree_pop();\
\9\9end\
\
\9\9imgui.tree_pop();\
\9end\
\
\9return config_changed;\
end\
\
function this.init_module()\
\9utils = require(\"Health_Bars.utils\");\
\9config = require(\"Health_Bars.config\");\
\9language = require(\"Health_Bars.language\");\
\9label_customization = require(\"Health_Bars.label_customization\");\
\9bar_customization = require(\"Health_Bars.bar_customization\");\
\9time = require(\"Health_Bars.time\");\
\9enemy_handler = require(\"Health_Bars.enemy_handler\");\
\9error_handler = require(\"Health_Bars.error_handler\");\
\
\9this.init();\
\9this.reload_font();\
end\
\
return this;", '@'..".\\Health_Bars\\customization_menu.lua" ) )

package.preload[ "Health_Bars.drawing" ] = assert( (loadstring or load)( "local this = {};\
\
local config;\
local utils;\
\
local sdk = sdk;\
local tostring = tostring;\
local pairs = pairs;\
local ipairs = ipairs;\
local tonumber = tonumber;\
local require = require;\
local pcall = pcall;\
local table = table;\
local string = string;\
local Vector3f = Vector3f;\
local d2d = d2d;\
local math = math;\
local json = json;\
local log = log;\
local fs = fs;\
local next = next;\
local type = type;\
local setmetatable = setmetatable;\
local getmetatable = getmetatable;\
local assert = assert;\
local select = select;\
local coroutine = coroutine;\
local utf8 = utf8;\
local re = re;\
local imgui = imgui;\
local draw = draw;\
local Vector2f = Vector2f;\
local reframework = reframework;\
local os = os;\
\
this.font = nil;\
\
function this.init_font()\
\9local cached_config = config.current_config.ui_font;\
\9this.font = d2d.Font.new(cached_config.family, cached_config.size, cached_config.bold, cached_config.italic);\
end\
\
function this.argb_color_to_abgr_color(argb_color)\
\9local alpha = (argb_color >> 24) & 0xFF;\
\9local red = (argb_color >> 16) & 0xFF;\
\9local green = (argb_color >> 8) & 0xFF;\
\9local blue = argb_color & 0xFF;\
\
\9local abgr_color = 0x1000000 * alpha + 0x10000 * blue + 0x100 * green + red;\
\
\9return abgr_color;\
end\
\
function this.color_to_argb(color)\
\9local alpha = (color >> 24) & 0xFF;\
\9local red = (color >> 16) & 0xFF;\
\9local green = (color >> 8) & 0xFF;\
\9local blue = color & 0xFF;\
\
\9return alpha, red, green, blue;\
end\
\
function this.argb_to_color(alpha, red, green, blue)\
\9return 0x1000000 * alpha + 0x10000 * red + 0x100 * green + blue;\
end\
\
function this.scale_color_opacity(color, scale)\
\9local alpha, red, green, blue = this.color_to_argb(color);\
\9local new_alpha = math.floor(alpha * scale);\
\9if new_alpha < 0 then\
\9\9new_alpha = 0;\
\9end\
\9if new_alpha > 255 then\
\9\9new_alpha = 255;\
\9end\
\
\9return this.argb_to_color(new_alpha, red, green, blue);\
end\
\
function this.scale_label_opacity(label, scale)\
\9if label == nil or scale == nil or not label.visibility then\
\9\9return;\
\9end\
\
\9label.color = this.scale_color_opacity(label.color, scale);\
\9label.shadow.color = this.scale_color_opacity(label.shadow.color, scale);\
end\
\
function this.scale_bar_opacity(bar, scale)\
\9if bar == nil or scale == nil or not bar.visibility then\
\9\9return;\
\9end\
\
\9bar.colors.foreground = this.scale_color_opacity(bar.colors.foreground, scale);\
\9bar.colors.background = this.scale_color_opacity(bar.colors.background, scale);\
end\
\
function this.draw_label(label, position, opacity_scale, ...)\
\9if label == nil or not label.visibility then\
\9\9return;\
\9end\
\
\9local text = string.format(label.text_format, table.unpack({...}));\
\
\9if text == \"\" then\
\9\9return;\
\9end\
\
\9local position_x = position.x + label.offset.x;\
\9local position_y = position.y + label.offset.y;\
\
\9local use_d2d = d2d ~= nil and config.current_config.settings.use_d2d_if_available;\
\
\9if label.shadow.visibility then\
\9\9local new_shadow_color = label.shadow.color;\
\
\9\9if opacity_scale < 1 then\
\9\9\9new_shadow_color = this.scale_color_opacity(new_shadow_color, opacity_scale);\
\9\9end\
\
\9\9if use_d2d then\
\9\9\9d2d.text(this.font, text, position_x + label.shadow.offset.x, position_y + label.shadow.offset.y, new_shadow_color);\
\9\9else\
\9\9\9new_shadow_color = this.argb_color_to_abgr_color(new_shadow_color);\
\9\9\9draw.text(text, position_x + label.shadow.offset.x, position_y + label.shadow.offset.y, new_shadow_color);\
\9\9end\
\9end\
\
\9local new_color = label.color;\
\9if opacity_scale < 1 then\
\9\9new_color = this.scale_color_opacity(new_color, opacity_scale);\
\9end\
\
\9if use_d2d then\
\9\9d2d.text(this.font, text, position_x, position_y, new_color);\
\9else\
\9\9new_color = this.argb_color_to_abgr_color(new_color);\
\9\9draw.text(text, position_x, position_y, new_color);\
\9end\
end\
\
function this.draw_bar(bar, position, opacity_scale, percentage)\
\9if bar == nil or not bar.visibility then\
\9\9return;\
\9end\
\
\9if percentage > 1 then\
\9\9percentage = 1;\
\9end\
\
\9if percentage < 0 then\
\9\9percentage = 0;\
\9end\
\
\9local outline_visibility = bar.outline.visibility;\
\9local style = bar.outline.style; -- Inside/Center/Outside\
\9local fill_direction = bar.settings.fill_direction; -- Left to Right/Right to Left/Top to Bottom/Bottom to Top\
\
\9local outline_thickness = bar.outline.thickness;\
\9if not outline_visibility then\
\9\9outline_thickness = 0;\
\9end\
\
\9local half_outline_thickness = outline_thickness / 2;\
\
\9local outline_offset = bar.outline.offset;\
\
\9if outline_thickness == 0 then\
\9\9outline_offset = 0;\
\9end\
\9local half_outline_offset = outline_offset / 2;\
\
\9local outline_position_x = 0;\
\9local outline_position_y = 0;\
\
\9local outline_width = 0;\
\9local outline_height = 0;\
\
\9local position_x = 0;\
\9local position_y = 0;\
\
\9local width = 0;\
\9local height = 0;\
\
\9local foreground_width = 0;\
\9local foreground_height = 0;\
\
\9local background_width = 0;\
\9local background_height = 0;\
\
\9local foreground_shift_x = 0;\
\9local foreground_shift_y = 0;\
\
\9local background_shift_x = 0;\
\9local background_shift_y = 0;\
\
\9if style == \"Inside\" then\
\9\9outline_position_x = position.x + bar.offset.x + half_outline_thickness;\
\9\9outline_position_y = position.y + bar.offset.y + half_outline_thickness;\
\
\9\9outline_width = bar.size.width - outline_thickness;\
\9\9outline_height = bar.size.height - outline_thickness;\
\
\9\9position_x = outline_position_x + half_outline_thickness + outline_offset;\
\9\9position_y = outline_position_y + half_outline_thickness + outline_offset;\
\
\9\9width = outline_width - outline_thickness - outline_offset - outline_offset;\
\9\9height = outline_height - outline_thickness - outline_offset - outline_offset;\
\
\9elseif style == \"Center\" then\
\9\9outline_position_x = position.x + bar.offset.x - half_outline_offset;\
\9\9outline_position_y = position.y + bar.offset.y - half_outline_offset;\
\
\9\9outline_width = bar.size.width + outline_offset;\
\9\9outline_height = bar.size.height + outline_offset;\
\
\9\9position_x = outline_position_x + half_outline_thickness + outline_offset;\
\9\9position_y = outline_position_y + half_outline_thickness + outline_offset;\
\
\9\9width = outline_width - outline_thickness - outline_offset - outline_offset;\
\9\9height = outline_height - outline_thickness - outline_offset - outline_offset;\
\
\9else -- Outside\
\9\9position_x = position.x + bar.offset.x;\
\9\9position_y = position.y + bar.offset.y;\
\
\9\9width = bar.size.width;\
\9\9height = bar.size.height;\
\
\9\9outline_position_x = position_x - half_outline_thickness - outline_offset;\
\9\9outline_position_y = position_y - half_outline_thickness - outline_offset;\
\
\9\9outline_width = width + outline_thickness + outline_offset + outline_offset;\
\9\9outline_height = height + outline_thickness + outline_offset + outline_offset;\
\9end\
\
\9if fill_direction == \"Right to Left\" then\
\9\9foreground_width = width * percentage;\
\9\9foreground_height = height;\
\
\9\9background_width = width - foreground_width;\
\9\9background_height = height;\
\
\9\9foreground_shift_x = background_width;\
\
\9elseif fill_direction == \"Top to Bottom\" then\
\9\9foreground_width = width;\
\9\9foreground_height = height * percentage;\
\
\9\9background_width = width;\
\9\9background_height = height - foreground_height;\
\
\9\9background_shift_y = foreground_height;\
\
\9elseif fill_direction == \"Bottom to Top\" then\
\9\9foreground_width = width;\
\9\9foreground_height = height * percentage;\
\
\9\9background_width = width;\
\9\9background_height = height - foreground_height;\
\
\9\9foreground_shift_y = background_height;\
\
\9else -- Left to Right\
\9\9foreground_width = width * percentage;\
\9\9foreground_height = height;\
\
\9\9background_width = width - foreground_width;\
\9\9background_height = height;\
\
\9\9background_shift_x = foreground_width;\
\9end\
\
\9local foreground_color = bar.colors.foreground;\
\9local background_color = bar.colors.background;\
\9local outline_color = bar.colors.outline;\
\
\9if opacity_scale < 1 then\
\9\9foreground_color = this.scale_color_opacity(foreground_color, opacity_scale);\
\9\9background_color = this.scale_color_opacity(background_color, opacity_scale);\
\9\9outline_color = this.scale_color_opacity(outline_color, opacity_scale);\
\9end\
\
\9local use_d2d = d2d ~= nil and config.current_config.settings.use_d2d_if_available;\
\
\9-- background\
\9if background_width ~= 0 then\
\9\9if use_d2d then\
\9\9\9d2d.fill_rect(position_x + background_shift_x, position_y + background_shift_y, background_width, background_height, background_color);\
\9\9else\
\9\9\9background_color = this.argb_color_to_abgr_color(background_color);\
\9\9\9draw.filled_rect(position_x + background_shift_x, position_y + background_shift_y, background_width, background_height, background_color)\
\9\9end\
\9end\
\
\9-- foreground\
\9if foreground_width ~= 0 then\
\9\9if use_d2d then\
\9\9\9d2d.fill_rect(position_x + foreground_shift_x, position_y + foreground_shift_y, foreground_width, foreground_height, foreground_color);\
\9\9else\
\9\9\9foreground_color = this.argb_color_to_abgr_color(foreground_color);\
\9\9\9draw.filled_rect(position_x + foreground_shift_x, position_y + foreground_shift_y, foreground_width, foreground_height, foreground_color)\
\9\9end\
\9end\
\
\9-- outline\
\9if outline_thickness ~= 0 then\
\9\9if use_d2d then\
\9\9\9d2d.outline_rect(outline_position_x, outline_position_y, outline_width, outline_height, outline_thickness, outline_color);\
\9\9else\
\9\9\9outline_color = this.argb_color_to_abgr_color(outline_color);\
\9\9\9draw.outline_rect(outline_position_x, outline_position_y, outline_width, outline_height, outline_color);\
\9\9end\
\9end\
end\
\
function this.init_module()\
\9config = require(\"Health_Bars.config\");\
\9utils = require(\"Health_Bars.utils\");\
end\
\
return this;\
", '@'..".\\Health_Bars\\drawing.lua" ) )

package.preload[ "Health_Bars.enemy_handler" ] = assert( (loadstring or load)( "local this = {};\
\
local utils;\
local singletons;\
local config;\
local drawing;\
local customization_menu;\
local player_handler;\
local game_handler;\
local time;\
local error_handler;\
\
local sdk = sdk;\
local tostring = tostring;\
local pairs = pairs;\
local ipairs = ipairs;\
local tonumber = tonumber;\
local require = require;\
local pcall = pcall;\
local table = table;\
local string = string;\
local Vector3f = Vector3f;\
local d2d = d2d;\
local math = math;\
local json = json;\
local log = log;\
local fs = fs;\
local next = next;\
local type = type;\
local setmetatable = setmetatable;\
local getmetatable = getmetatable;\
local assert = assert;\
local select = select;\
local coroutine = coroutine;\
local utf8 = utf8;\
local re = re;\
local imgui = imgui;\
local draw = draw;\
local Vector2f = Vector2f;\
local reframework = reframework;\
local os = os;\
\
this.enemy_list = {};\
this.enemy_owner_list = {};\
this.update_time_limit = 0.5;\
\
local lowest_position = Vector3f.new(0, -1000000, 0);\
\
local executioner_enemy_core = nil;\
\
local enemy_core_type_def = sdk.find_type_definition(\"app.EnemyCore\");\
local enemy_core_update_method = enemy_core_type_def:get_method(\"update\");\
local enemy_core_on_damage_method = enemy_core_type_def:get_method(\"onDamage\"); -- Possible alternative: app.CharacterCore.sendAttackHitResult()\
local enemy_core_on_die_method = enemy_core_type_def:get_method(\"onDie\");\
local enemy_core_destroy_method = enemy_core_type_def:get_method(\"destroy\");\
local enemy_core_get_owner_method = enemy_core_type_def:get_method(\"get_owner\");\
local enemy_core_on_warp_method = enemy_core_type_def:get_method(\"onWarp\");\
local enemy_core_restart_method = enemy_core_type_def:get_method(\"restart\");\
local enemy_core_damage_controller_field = enemy_core_type_def:get_field(\"DamageController\");\
local enemy_core_character_status_field = enemy_core_type_def:get_field(\"CharacterStatus\");\
\
\
local damage_controller_type_def = enemy_core_damage_controller_field:get_type();\
local get_health_method = damage_controller_type_def:get_method(\"get_health\");\
local get_max_health_method = damage_controller_type_def:get_method(\"get_maxHealth\");\
\
local enemy_status_type_def = sdk.find_type_definition(\"app.EnemyStatus\");\
local get_is_visible_method = enemy_status_type_def:get_method(\"get_isVisible\");\
\
local game_object_type_def = sdk.find_type_definition(\"via.GameObject\");\
local get_transform_method = game_object_type_def:get_method(\"get_Transform\");\
\
local transform_type_def = get_transform_method:get_return_type();\
local get_joint_by_name_method = transform_type_def:get_method(\"getJointByName\");\
\
local joint_type_def = get_joint_by_name_method:get_return_type();\
local get_position_method = joint_type_def:get_method(\"get_Position\");\
\
\
-- DLC\
\
-- Executioner Boss\
local em_1600_core_type_def = sdk.find_type_definition(\"app.Em1600.Em1600Core\");\
local em_1600_core_on_core_damage_method;\
local em_1600_core_on_core_die_method;\
local core_list_field;\
local core_list_type_def;\
local core_list_get_count_method;\
local core_list_get_item_method;\
\
local em_1600_core_controller_type_def = sdk.find_type_definition(\"app.Em1600.Em1600CoreController\");\
local em_1600_core_controller_update_core_method;\
local em_1600_core_controller_is_permit_open_core_field;\
local em_1600_core_controller_is_dead_field;\
local em_1600_core_controller_damage_controller_field;\
\
em_1600_core_on_core_damage_method = em_1600_core_type_def:get_method(\"onCoreDamage\");\
em_1600_core_on_core_die_method = em_1600_core_type_def:get_method(\"onCoreDie\");\
\
core_list_field = em_1600_core_type_def:get_field(\"CoreList\");\
\
core_list_type_def = core_list_field:get_type();\
core_list_get_count_method = core_list_type_def:get_method(\"get_Count\");\
core_list_get_item_method = core_list_type_def:get_method(\"get_Item\");\
\
em_1600_core_controller_update_core_method = em_1600_core_controller_type_def:get_method(\"updateCore\");\
em_1600_core_controller_is_permit_open_core_field = em_1600_core_controller_type_def:get_field(\"<isPermitOpenCore>k__BackingField\");\
em_1600_core_controller_is_dead_field = em_1600_core_controller_type_def:get_field(\"<isDead>k__BackingField\");\
em_1600_core_controller_damage_controller_field = em_1600_core_controller_type_def:get_field(\"DamageController\");\
\
function this.get_vital_state_name(index)\
\9for state_name, state_index in pairs(this.vital_states) do\
\9\9if state_index == index then\
\9\9\9return state_name;\
\9\9end\
\9end\
\
\9return \"None\";\
end\
\
function this.new(enemy_core)\
\9local enemy = {};\
\9enemy.enemy_core = enemy_core;\
\
\9enemy.health = -1;\
\9enemy.max_health = -100;\
\9enemy.health_percentage = 0;\
\9enemy.is_dead = false;\
\
\9enemy.is_visible = false;\
\9enemy.is_filtered_out = false;\
\
\9enemy.position = lowest_position;\
\9enemy.distance = 0;\
\
\9enemy.last_reset_time = 0;\
\9enemy.last_update_time = 0;\
\
\9enemy.owner = nil;\
\
\9enemy.type = enemy.enemy_core:get_type_definition():get_name();\
\
\9enemy.is_duke = enemy.type == \"Em4070Core\"; -- works normally\
\9\
\9enemy.is_giant_sentinel = enemy.type == \"Em1060Core\"; -- works normally\
\9enemy.is_leonardo = enemy.type == \"Em1360Core\";\
\9enemy.is_dimitrescu_boss = enemy.type == \"Em1230Core\";\
\9enemy.is_angie = enemy.type == \"Em1370Core\";\
\9enemy.is_baby = enemy.type == \"Em1380Core\";\
\9enemy.is_mutated_moreau = enemy.type == \"Em1301Core\"; -- no coordinates\
\9enemy.is_moreau_boss = enemy.type == \"Em1302Core\";\
\9enemy.is_sturm = enemy.type == \"Em1040Core\"; -- works normally\
\9enemy.is_heisenberg_boss = enemy.type == \"Em1310Core\";\
\9enemy.is_miranda_boss = enemy.type == \"Em1320Core\";\
\
\9enemy.is_blue_bird = enemy.type == \"Em3000Core\";\
\9enemy.is_pig = enemy.type == \"Em3020Core\";\
\9enemy.is_chicken = enemy.type == \"Em3070Core\";\
\9enemy.is_goat = enemy.type == \"Em3080Core\";\
\9enemy.is_fish = enemy.type == \"Em3090Core\";\
\9enemy.is_catfish = enemy.type == \"Em3100Core\";\
\
\9enemy.is_k = enemy.type == \"Em4470Core\";\
\9enemy.is_rose_copy = enemy.type == \"Em4440Core\";\
\9enemy.is_masked_duke = enemy.type == \"Em4450Core\";\
\9enemy.is_executioner = enemy.type == \"Em1600Core\";\
\9enemy.is_mia_doll = enemy.type == \"Em1400Core\";\
\9enemy.is_doll = enemy.type == \"Em1390Core\";\
\9enemy.is_eveline = enemy.type == \"Em1800Core\";\
\9enemy.is_eveline_doll = enemy.type == \"Em1810Core\";\
\9enemy.is_miranda_crow = enemy.type == \"Em3002Core\";\
\9enemy.is_rose_illusion = enemy.type == \"Em4490Core\";\
\9enemy.is_miranda_boss_dlc = enemy.type == \"Em1900Core\";\
\9enemy.is_ethan_dlc = enemy.type == \"Em4460Core\";\
\
\9enemy.is_aways_visible =\
\9\9   enemy.is_dimitrescu_boss\
\9\9-- or enemy.is_angie\
\9\9-- or enemy.is_baby\
\9\9-- or enemy.is_mutated_moreau\
\9\9or enemy.is_moreau_boss\
\9\9or enemy.is_heisenberg_boss\
\9\9or enemy.is_miranda_boss\
\9\9\
\9\9or enemy.is_blue_bird\
\9\9or enemy.is_pig\
\9\9or enemy.is_chicken\
\9\9or enemy.is_goat\
\9\9or enemy.is_fish\
\9\9or enemy.is_catfish\
\
\9\9or enemy.is_k\
\9\9or enemy.is_rose_copy\
\9\9or enemy.is_masked_duke\
\9\9or enemy.is_executioner\
\9\9or enemy.is_mia_doll\
\9\9or enemy.is_doll\
\9\9or enemy.is_eveline\
\9\9or enemy.is_miranda_crow\
\9\9or enemy.is_rose_illusion\
\9\9or enemy.is_miranda_boss_dlc\
\9\9or enemy.is_ethan_dlc;\
\
\9this.update_health(enemy);\
\
\9if enemy.health == -1 or enemy.max_health == -1 then\
\9\9return nil;\
\9end\
\
\9this.update_owner(enemy);\
\9this.update_head_joint(enemy);\
\9this.update_position(enemy);\
\9this.update_is_visible(enemy);\
\9this.update_is_filtered_out(enemy);\
\
\9this.enemy_list[enemy_core] = enemy;\
\9\
\9return enemy;\
end\
\
function this.get_enemy(enemy_core)\
\9local enemy = this.enemy_list[enemy_core];\
\9if enemy == nil then\
\9\9enemy = this.new(enemy_core);\
\9end\
\9\
\9return enemy;\
end\
\
function this.get_enemy_null(enemy_core, create_if_not_found)\
\9if create_if_not_found == nil then\
\9\9create_if_not_found = true;\
\9end\
\
\9local enemy = this.enemy_list[enemy_core];\
\9if enemy == nil and create_if_not_found then\
\9\9enemy = this.new(enemy_core);\
\9end\
\
\9return enemy;\
end\
\
function this.update_health(enemy)\
\9if enemy == nil then\
\9\9error_handler.report(\"enemy.update_health\", \"No Enemy\");\
\9\9return;\
\9end\
\
\9if enemy.is_executioner then\
\9\9local is_core = this.update_core_health_executioner(enemy);\
\9\9\
\9\9if is_core then\
\9\9\9return;\
\9\9end\
\9end\
\
\9local damage_controller = enemy_core_damage_controller_field:get_data(enemy.enemy_core);\
\
\9if damage_controller == nil then\
\9\9error_handler.report(\"enemy.update_health\", \"No EnemyDamageController\");\
\9\9return;\
\9end\
\
\9local health = get_health_method:call(damage_controller);\
\9local max_health = get_max_health_method:call(damage_controller);\
\
\9if health == nil then\
\9\9error_handler.report(\"enemy.update_health\", \"No Health\");\
\9else\
\9\9enemy.health = utils.math.round(health);\
\9end\
\
\9if max_health == nil then\
\9\9error_handler.report(\"enemy.update_health\", \"No MaxHealth\");\
\9else\
\9\9enemy.max_health = utils.math.round(max_health);\
\9end\
\
\9if enemy.max_health == 0 then\
\9\9enemy.health_percentage = 0;\
\9else\
\9\9enemy.health_percentage = enemy.health / enemy.max_health;\
\9end\
end\
\
function this.update_core_health_executioner(enemy)\
\9local is_core = false;\
\
\9local core_list = core_list_field:get_data(enemy.enemy_core);\
\
\9if core_list == nil then\
\9\9error_handler.report(\"enemy.update_core_health_executioner\", \"No Core List\");\
\9\9return is_core;\
\9end\
\
\9local core_list_count = core_list_get_count_method:call(core_list);\
\
\9if core_list == nil then\
\9\9error_handler.report(\"enemy.update_core_health_executioner\", \"No Core List Count\");\
\9\9return is_core;\
\9end\
\
\9if core_list_count == 0 then\
\9\9return is_core;\
\9end\
\
\9for i = 0, core_list_count - 1 do\
\9\9local core = core_list_get_item_method:call(core_list, i);\
\
\9\9if core == nil then\
\9\9\9error_handler.report(\"enemy.update_core_health_executioner\", string.format(\"No Core No. %d\", i));\
\9\9\9goto continue;\
\9\9end\
\9\9\
\9\9local is_permit_open_core = em_1600_core_controller_is_permit_open_core_field:get_data(core);\
\9\9\
\9\9if is_permit_open_core == nil then\
\9\9\9error_handler.report(\"enemy.update_core_health_executioner\", string.format(\"No Core No. %d -> is_permit_open_core\", i));\
\9\9\9goto continue;\
\9\9end\
\
\9\9if not is_permit_open_core then\
\9\9\9goto continue;\
\9\9end\
\
\9\9local is_dead = em_1600_core_controller_is_dead_field:get_data(core);\
\9\9\
\9\9if is_dead == nil then\
\9\9\9error_handler.report(\"enemy.update_core_health_executioner\", string.format(\"No Core No. %d -> is_dead\", i));\
\9\9\9goto continue;\
\9\9end\
\
\9\9if is_dead then\
\9\9\9goto continue;\
\9\9end\
\
\9\9local damage_controller = em_1600_core_controller_damage_controller_field:get_data(core);\
\
\9\9if damage_controller == nil then\
\9\9\9error_handler.report(\"enemy.update_core_health_executioner\", string.format(\"No Core No. %d -> Damage Controller\", i));\
\9\9\9goto continue;\
\9\9end\
\
\9\9local health = get_health_method:call(damage_controller);\
\9\9local max_health = get_max_health_method:call(damage_controller);\
\
\9\9if health == nil then\
\9\9\9error_handler.report(\"enemy.update_core_health_executioner\", string.format(\"No Core No. %d -> Health\", i));\
\9\9else\
\9\9\9enemy.health = utils.math.round(health);\
\9\9end\
\
\9\9if max_health == nil then\
\9\9\9error_handler.report(\"enemy.update_core_health_executioner\", string.format(\"No Core No. %d -> Max Health\", i));\
\9\9else\
\9\9\9enemy.max_health = utils.math.round(max_health);\
\9\9end\
\
\9\9if enemy.max_health == 0 then\
\9\9\9enemy.health_percentage = 0;\
\9\9else\
\9\9\9enemy.health_percentage = enemy.health / enemy.max_health;\
\9\9end\
\
\9\9is_core = true;\
\9\9break;\
\
\9\9::continue::\
\9end\
\
\9return is_core;\
end\
\
function this.update_is_visible(enemy)\
\9if enemy == nil then\
\9\9error_handler.report(\"enemy.is_visible\", \"No Enemy\");\
\9\9return;\
\9end\
\
\9local character_status = enemy_core_character_status_field:get_data(enemy.enemy_core);\
\
\9if character_status == nil then\
\9\9error_handler.report(\"enemy.is_visible\", \"No EnemyCharacterStatus\");\
\9\9return;\
\9end\
\
\9local is_visible = get_is_visible_method:call(character_status);\
\
\9if is_visible == nil then\
\9\9error_handler.report(\"enemy.is_visible\", \"No IsVisible\");\
\9\9return;\
\9end\
\
\9enemy.is_visible = is_visible;\
end\
\
function this.update_is_filtered_out(enemy)\
\9local cached_config = config.current_config.settings;\
\
\9enemy.is_filtered_out =\
\9\9   (cached_config.hide_leonardo and enemy.is_leonardo)\
\9\9or (cached_config.hide_duke and enemy.is_duke)\
\9\9or (cached_config.hide_blue_bird and enemy.is_blue_bird)\
\9\9or (cached_config.hide_pigs and enemy.is_pig)\
\9\9or (cached_config.hide_chickens and enemy.is_chicken)\
\9\9or (cached_config.hide_goats and enemy.is_goat)\
\9\9or (cached_config.hide_fish and enemy.is_fish)\
\9\9or (cached_config.hide_catfish and enemy.is_catfish)\
\9\9or (cached_config.hide_rose_copies and enemy.is_rose_copies)\
\9\9or (cached_config.hide_masked_duke and enemy.is_masked_duke)\
\9\9or (cached_config.hide_mia_dolls and enemy.is_mia_doll)\
\9\9or (cached_config.hide_dolls and enemy.is_doll)\
\9\9or (cached_config.hide_rose_illusion and enemy.is_rose_illusion)\
\9\9or (cached_config.hide_miranda_crows and enemy.is_miranda_crow)\
\9\9or (cached_config.hide_ethan_dlc and enemy.is_ethan_dlc);\
end\
\
function this.update_last_reset_time(enemy)\
\9if enemy == nil then\
\9\9error_handler.report(\"enemy.update_last_reset_time\", \"No Enemy\");\
\9\9return;\
\9end\
\9\
\9enemy.last_reset_time = time.total_elapsed_script_seconds;\
end\
\
function this.update_all_positions()\
\9for enemy_core, enemy in pairs(this.enemy_list) do\
\9\9this.update_head_joint(enemy);\
\9\9this.update_position(enemy);\
\9end\
end\
\
function this.update_position(enemy)\
\9if enemy.head_joint == nil then\
\9\9error_handler.report(\"enemy_handler.update_position\", \"No Head Joint\");\
\9\9return;\
\9end\
\
\9local head_joint_position = get_position_method:call(enemy.head_joint);\
\9if head_joint_position == nil then\
\9\9error_handler.report(\"enemy_handler.update_position\", \"No Head Joint Position\");\
\9\9return;\
\9end\
\
\9enemy.position = head_joint_position;\
\9enemy.distance = (player_handler.player.position - head_joint_position):length();\
end\
\
function this.update_all_periodics()\
\9for enemy_core, enemy in pairs(this.enemy_list) do\
\9\9if config.current_config.settings.hide_if_no_update_function_is_being_called and time.total_elapsed_script_seconds - enemy.last_update_time > this.update_time_limit then\
\9\9\9this.enemy_list[enemy_core] = nil;\
\
\9\9\9for enemy_owner, enemy_in_enemy_owner_list in pairs(this.enemy_owner_list) do\
\9\9\9\9if this.enemy_owner_list[enemy_owner] == enemy_core\9then\
\9\9\9\9\9this.enemy_owner_list[enemy_owner] = nil;\
\9\9\9\9end\
\9\9\9end\
\
\9\9\9goto continue;\
\9\9end\
\
\9\9this.update_is_visible(enemy);\
\9\9::continue::\
\9end\
end\
\
function this.update_head_joint(enemy)\
\9if enemy.owner == nil then\
\9\9error_handler.report(\"enemy_handler.update_head_joint\", \"No GameObject\");\
\9\9return;\
\9end\
\
\9local enemy_transform = get_transform_method:call(enemy.owner);\
\9if enemy_transform == nil then\
\9\9error_handler.report(\"enemy_handler.update_head_joint\", \"No Transform\");\
\9\9return;\
\9end\
\
\9local joint = get_joint_by_name_method:call(enemy_transform, \"Head_Human\")\
\9or get_joint_by_name_method:call(enemy_transform, \"HumanHead\")\
\9or get_joint_by_name_method:call(enemy_transform, \"Head\")\
\9or get_joint_by_name_method:call(enemy_transform, \"head\")\
\9or get_joint_by_name_method:call(enemy_transform, \"root\");\
\
\9if joint == nil then\
\9\9error_handler.report(\"enemy_handler.update_head_joint\", \"No Head Joint\");\
\9\9return;\
\9end\
\
\9enemy.head_joint = joint;\
end\
\
function this.update_owner(enemy)\
\9if enemy == nil then\
\9\9error_handler.report(\"enemy.update_owner\", \"No Enemy\");\
\9\9return;\
\9end\
\
\9local owner = enemy_core_get_owner_method:call(enemy.enemy_core);\
\
\9if owner == nil then\
\9\9error_handler.report(\"enemy.update_owner\", \"No Enemy Owner\");\
\9\9return;\
\9end\
\
\9enemy.owner = owner;\
\
\9this.enemy_owner_list[owner] = enemy;\
end\
\
function this.draw_enemies()\
\9local cached_config = config.current_config;\
\
\9if not cached_config.settings.render_during_cutscenes and game_handler.game.is_cutscene_playing then\
\9\9return;\
\9end\
\
\9if not cached_config.settings.render_when_game_timer_is_paused and game_handler.game.is_paused then\
\9\9return;\
\9end\
\
\9if not cached_config.settings.render_in_mercenaries and game_handler.game.is_mercenaries then\
\9\9return;\
\9end\
\
\9if not player_handler.player.is_aiming then\
\9\9if not cached_config.settings.render_when_normal then\
\9\9\9return;\
\9\9end\
\9elseif not player_handler.player.is_using_scope then\
\9\9if not cached_config.settings.render_when_aiming then\
\9\9\9return;\
\9\9end\
\9else\
\9\9if not cached_config.settings.render_when_using_scope then\
\9\9\9return;\
\9\9end\
\9end\
\
\9local max_distance = 0;\
\9if player_handler.player.is_using_scope then\
\9\9max_distance = cached_config.settings.scope_max_distance;\
\9else\
\9\9max_distance = cached_config.settings.max_distance;\
\9end\
\
\9for enemy_core, enemy in pairs(this.enemy_list) do\
\9\9if enemy.is_filtered_out then\
\9\9\9goto continue;\
\9\9end\
\
\9\9local position = enemy.position;\
\9\9local distance = enemy.distance;\
\9\9\
\9\9if max_distance ~= 0 and distance > max_distance then\
\9\9\9goto continue;\
\9\9end\
\
\9\9local is_time_duration_on = false;\
\9\9\
\9\9if cached_config.settings.apply_time_duration_on_aiming\
\9\9or cached_config.settings.apply_time_duration_on_aim_target\
\9\9or cached_config.settings.apply_time_duration_on_using_scope\
\9\9or cached_config.settings.apply_time_duration_on_damage_dealt then\
\9\9\9if cached_config.settings.time_duration ~= 0 then\
\9\9\9\9if time.total_elapsed_script_seconds - enemy.last_reset_time > cached_config.settings.time_duration then\
\9\9\9\9\9goto continue;\
\9\9\9\9else\
\9\9\9\9\9is_time_duration_on = true;\
\9\9\9\9end\
\9\9\9end\
\9\9end\
\
\9\9if not cached_config.settings.render_aim_target_enemy and enemy.owner == player_handler.player.aim_target_owner and not is_time_duration_on then\
\9\9\9goto continue;\
\9\9end\
\
\9\9if not cached_config.settings.render_damaged_enemies and not utils.number.is_equal(enemy.health, enemy.max_health) and not is_time_duration_on then\
\9\9\9if enemy.owner == player_handler.player.aim_target_owner then\
\9\9\9\9if not cached_config.settings.render_aim_target_enemy then\
\9\9\9\9\9goto continue;\
\9\9\9\9end\
\9\9\9else\
\9\9\9\9goto continue;\
\9\9\9end\
\9\9end\
\
\9\9if not cached_config.settings.render_everyone_else and enemy.owner ~= player_handler.player.aim_target_owner and utils.number.is_equal(enemy.health, enemy.max_health) and not is_time_duration_on then\
\9\9\9goto continue;\
\9\9end\
\
\9\9if cached_config.settings.hide_if_dead and enemy.is_dead then\
\9\9\9goto continue;\
\9\9end\
\
\9\9if cached_config.settings.hide_if_full_health and utils.number.is_equal(enemy.health, enemy.max_health) then\
\9\9\9goto continue;\
\9\9end\
\
\9\9if cached_config.settings.hide_if_enemy_model_is_not_being_rendered and not enemy.is_visible\
\9\9and not enemy.is_aways_visible then\
\9\9\9goto continue;\
\9\9end\
\
\9\9local world_offset = Vector3f.new(cached_config.world_offset.x, cached_config.world_offset.y, cached_config.world_offset.z);\
\
\9\9local position_on_screen = draw.world_to_screen(position + world_offset);\
\9\9if position_on_screen == nil then\
\9\9\9goto continue;\
\9\9end\
\
\9\9local opacity_scale = 1;\
\9\9if player_handler.player.is_using_scope then\
\9\9\9if cached_config.settings.scope_opacity_falloff and max_distance ~= 0 then\
\9\9\9\9opacity_scale = 1 - (distance / max_distance);\
\9\9\9end\
\9\9else\
\9\9\9if cached_config.settings.opacity_falloff and max_distance ~= 0 then\
\9\9\9\9opacity_scale = 1 - (distance / max_distance);\
\9\9\9end\
\9\9end\
\
\9\9local health_value_text = \"\";\
\
\9\9local health_value_label = cached_config.health_value_label;\
\9\9local health_value_include = health_value_label.include;\
\9\9local right_alignment_shift = health_value_label.settings.right_alignment_shift;\
\
\9\9if health_value_include.current_value then\
\9\9\9health_value_text = string.format(\"%.0f\", enemy.health);\
\
\9\9\9if health_value_include.max_value then\
\9\9\9\9health_value_text = string.format(\"%s/%.0f\", health_value_text, enemy.max_health);\
\9\9\9end\
\9\9elseif health_value_include.max_value then\
\9\9\9health_value_text = string.format(\"%.0f\", enemy.max_health);\
\9\9end\
\
\9\9if right_alignment_shift ~= 0 then\
\9\9\9local right_aligment_format = string.format(\"%%%ds\", right_alignment_shift);\
\9\9\9health_value_text = string.format(right_aligment_format, health_value_text);\
\9\9end\
\
\9\9drawing.draw_bar(cached_config.health_bar, position_on_screen, opacity_scale, enemy.health_percentage);\
\9\9drawing.draw_label(health_value_label, position_on_screen, opacity_scale, health_value_text);\
\9\9\
\9\9::continue::\
\9end\
end\
\
function this.on_update(enemy_core)\
\9if enemy_core == nil then\
\9\9error_handler.report(\"enemy.on_enemy_update\", \"No EnemyCore\");\
\9\9return;\
\9end\
\
\9local damage_controller = enemy_core_damage_controller_field:get_data(enemy_core);\
\9if damage_controller == nil then\
\9\9return nil;\
\9end\
\
\9local enemy = this.get_enemy(enemy_core);\
\
\9if enemy == nil then\
\9\9return;\
\9end\
\
\9enemy.last_update_time = time.total_elapsed_script_seconds;\
end\
\
function this.on_damage(attacked_enemy_core)\
\9local cached_config = config.current_config.settings;\
\
\9if attacked_enemy_core == nil then\
\9\9error_handler.report(\"enemy.on_damage\", \"No EnemyCore\");\
\9\9return;\
\9end\
\
\9local attacked_enemy = this.get_enemy(attacked_enemy_core);\
\
\9if attacked_enemy == nil then\
\9\9return;\
\9end\
\
\9this.update_health(attacked_enemy);\
\
\9if cached_config.reset_time_duration_on_damage_dealt_for_everyone then\
\9\9for enemy_core, enemy in pairs(this.enemy_list) do\
\9\9\9if time.total_elapsed_script_seconds - enemy.last_reset_time < cached_config.time_duration then\
\9\9\9\9this.update_last_reset_time(enemy);\
\9\9\9end\
\9\9end\
\9end\
\9\
\9if cached_config.apply_time_duration_on_damage_dealt then\
\9\9this.update_last_reset_time(attacked_enemy);\
\9end\
end\
\
function this.on_die(enemy_core)\
\9if enemy_core == nil then\
\9\9error_handler.report(\"enemy.on_die\", \"No EnemyCore\");\
\9\9return;\
\9end\
\
\9local enemy = this.get_enemy(enemy_core);\
\
\9if enemy == nil then\
\9\9return;\
\9end\
\
\9this.update_health(enemy);\
\9enemy.is_dead = true;\
end\
\
function this.on_core_damage_executioner(attacked_enemy_core)\
\9local cached_config = config.current_config.settings;\
\
\9if attacked_enemy_core == nil then\
\9\9error_handler.report(\"enemy.on_core_damage_executioner\", \"No EnemyCore\");\
\9\9return;\
\9end\
\
\9local attacked_enemy = this.get_enemy(attacked_enemy_core);\
\
\9if attacked_enemy == nil then\
\9\9return;\
\9end\
\
\9this.update_health(attacked_enemy);\
\
\9if cached_config.reset_time_duration_on_damage_dealt_for_everyone then\
\9\9for enemy_core, enemy in pairs(this.enemy_list) do\
\9\9\9if time.total_elapsed_script_seconds - enemy.last_reset_time < cached_config.time_duration then\
\9\9\9\9this.update_last_reset_time(enemy);\
\9\9\9end\
\9\9end\
\9end\
\9\
\9if cached_config.apply_time_duration_on_damage_dealt then\
\9\9this.update_last_reset_time(attacked_enemy);\
\9end\
end\
\
function this.on_post_core_die_executioner(enemy_core)\
\9if enemy_core == nil then\
\9\9error_handler.report(\"enemy.on_post_core_die_executioner\", \"No EnemyCore\");\
\9\9return;\
\9end\
\
\9local enemy = this.get_enemy(enemy_core);\
\
\9if enemy == nil then\
\9\9return;\
\9end\
\
\9this.update_health(enemy);\
end\
\
function this.on_update_core_executioner(core_controller)\
\9if core_controller == nil then\
\9\9error_handler.report(\"enemy.on_open_core_executioner\", \"No CoreController\");\
\9\9return;\
\9end\
\
\9local core_controller_owner = core_controller:get_owner();\
\
\9if core_controller_owner == nil then\
\9\9error_handler.report(\"enemy.on_open_core_executioner\", \"No CoreControllerOwner\");\
\9\9return;\
\9end\
\
\9local attacked_enemy_core = this.enemy_owner_list[core_controller_owner];\
\
\9if attacked_enemy_core == nil then\
\9\9error_handler.report(\"enemy.on_open_core_executioner\", \"No Attacked EnemyCore\");\
\9\9return;\
\9end\
\
\9this.update_health(attacked_enemy_core);\
end\
\
function this.on_warp(enemy_core)\
\9if enemy_core == nil then\
\9\9error_handler.report(\"enemy.on_warp\", \"No Enemy core\");\
\9\9return;\
\9end\
\
\9local enemy = this.get_enemy_null(enemy_core, false);\
\
\9if enemy == nil then\
\9\9return;\
\9end\
\
\9this.update_health(enemy);\
\
\9enemy.is_dead = utils.number.is_equal(enemy.health, 0);\
end\
\
function this.on_restart(enemy_core)\
\9if enemy_core == nil then\
\9\9error_handler.report(\"enemy.on_restart\", \"No Enemy core\");\
\9\9return;\
\9end\
\
\9local enemy = this.get_enemy(enemy_core);\
\
\9if enemy == nil then\
\9\9return;\
\9end\
\
\9this.update_health(enemy);\
\9enemy.is_dead = utils.number.is_equal(enemy.health, 0);\
end\
\
function this.on_destroy(enemy_core)\
\9if enemy_core == nil then\
\9\9error_handler.report(\"enemy.on_destroy\", \"No EnemyCore\");\
\9\9return;\
\9end\
\
\9this.enemy_list[enemy_core] = nil;\
\
\9for enemy_owner, enemy in pairs(this.enemy_owner_list) do\
\9\9if this.enemy_owner_list[enemy_owner] == enemy_core\9then\
\9\9\9this.enemy_owner_list[enemy_owner] = nil;\
\9\9end\
\9end\
end\
\
function this.init_module()\
\9utils = require(\"Health_Bars.utils\");\
\9config = require(\"Health_Bars.config\");\
\9singletons = require(\"Health_Bars.singletons\");\
\9drawing = require(\"Health_Bars.drawing\");\
\9customization_menu = require(\"Health_Bars.customization_menu\");\
\9player_handler = require(\"Health_Bars.player_handler\");\
\9game_handler = require(\"Health_Bars.game_handler\");\
\9time = require(\"Health_Bars.time\");\
\9error_handler = require(\"Health_Bars.error_handler\");\
\
\9sdk.hook(enemy_core_update_method, function(args)\
\9\9\
\9\9local enemy_core = sdk.to_managed_object(args[2]);\
\9\9this.on_update(enemy_core);\
\
\9end, function(retval)\
\9\9return retval;\
\9end);\
\
\9sdk.hook(enemy_core_on_damage_method, function(args)\
\
\9\9local enemy_core = sdk.to_managed_object(args[2]);\
\9\9this.on_damage(enemy_core);\
\
\9end, function(retval)\
\9\9return retval;\
\9end);\
\
\9sdk.hook(enemy_core_on_die_method, function(args)\
\
\9\9local enemy_core = sdk.to_managed_object(args[2]);\
\9\9this.on_die(enemy_core);\
\
\9end, function(retval)\
\9\9return retval;\
\9end);\
\
\9sdk.hook(enemy_core_on_warp_method, function(args)\
\
\9\9local enemy_core = sdk.to_managed_object(args[2]);\
\9\9this.on_warp(enemy_core);\
\
\9end, function(retval)\
\9\9return retval;\
\9end);\
\
\9sdk.hook(enemy_core_restart_method, function(args)\
\
\9\9local enemy_core = sdk.to_managed_object(args[2]);\
\9\9this.on_restart(enemy_core);\
\
\9end, function(retval)\
\9\9return retval;\
\9end);\
\
\9sdk.hook(enemy_core_destroy_method, function(args)\
\
\9\9local enemy_core = sdk.to_managed_object(args[2]);\
\9\9this.on_destroy(enemy_core);\
\
\9end, function(retval)\
\9\9return retval;\
\9end);\
\
\9-- DLC\
\
\9sdk.hook(em_1600_core_on_core_damage_method, function(args)\
\
\9\9local enemy_core = sdk.to_managed_object(args[2]);\
\9\9this.on_core_damage_executioner(enemy_core);\
\
\9end, function(retval)\
\9\9return retval;\
\9end);\
\
\9sdk.hook(em_1600_core_on_core_die_method, function(args)\
\
\9\9local enemy_core = sdk.to_managed_object(args[2]);\
\9\9executioner_enemy_core = enemy_core;\
\
\9end, function(retval)\
\
\9\9this.on_post_core_die_executioner(executioner_enemy_core);\
\9\9return retval;\
\
\9end);\
\
\9sdk.hook(em_1600_core_controller_update_core_method, function(args)\
\
\9\9local core_controller = sdk.to_managed_object(args[2]);\
\9\9this.on_update_core_executioner(core_controller);\
\
\9end, function(retval)\
\9\9return retval;\
\9end);\
end\
\
return this;", '@'..".\\Health_Bars\\enemy_handler.lua" ) )

package.preload[ "Health_Bars.error_handler" ] = assert( (loadstring or load)( "local this = {};\
\
local time;\
local utils;\
local config;\
\
local sdk = sdk;\
local tostring = tostring;\
local pairs = pairs;\
local ipairs = ipairs;\
local tonumber = tonumber;\
local require = require;\
local pcall = pcall;\
local table = table;\
local string = string;\
local Vector3f = Vector3f;\
local d2d = d2d;\
local math = math;\
local json = json;\
local log = log;\
local fs = fs;\
local next = next;\
local type = type;\
local setmetatable = setmetatable;\
local getmetatable = getmetatable;\
local assert = assert;\
local select = select;\
local coroutine = coroutine;\
local utf8 = utf8;\
local re = re;\
local imgui = imgui;\
local draw = draw;\
local Vector2f = Vector2f;\
local reframework = reframework;\
local os = os;\
local ValueType = ValueType;\
local package = package;\
\
this.list = {};\
this.is_empty = true;\
\
this.history = {};\
\
function this.report(error_key, error_message)\
\9if error_key == nil or error_key == \"\"\
\9or error_message == nil or error_message == \"\" then\
\9\9return;\
\9end\
\
\9local error_time = time.total_elapsed_script_seconds;\
\
\9if utils.number.is_equal(error_time, 0) then\
\9\9return;\
\9end\
\
\9local error = {\
\9\9key = error_key,\
\9\9time = error_time,\
\9\9message = error_message\
\9};\
\
\9this.list[error_key] = error;\
\9this.is_empty = false;\
\
\9this.add_to_history(error_key, error);\
end\
\
function this.add_to_history(error_key, error)\
\9this.clear_history();\
\
\9table.insert(this.history, error);\
end\
\
function this.clear_history()\
\9local history_size = config.current_config.debug.history_size;\
\
\9while #this.history >= history_size do\
\9\9table.remove(this.history, 1);\
\9end\
end\
\
function this.init_module()\
\9time = require(\"Health_Bars.time\");\
\9utils = require(\"Health_Bars.utils\");\
\9config = require(\"Health_Bars.config\");\
end\
\
return this;", '@'..".\\Health_Bars\\error_handler.lua" ) )

package.preload[ "Health_Bars.game_handler" ] = assert( (loadstring or load)( "local this = {};\
\
local singletons;\
local customization_menu;\
local time;\
local enemy_handler;\
local error_handler;\
\
local sdk = sdk;\
local tostring = tostring;\
local pairs = pairs;\
local ipairs = ipairs;\
local tonumber = tonumber;\
local require = require;\
local pcall = pcall;\
local table = table;\
local string = string;\
local Vector3f = Vector3f;\
local d2d = d2d;\
local math = math;\
local json = json;\
local log = log;\
local fs = fs;\
local next = next;\
local type = type;\
local setmetatable = setmetatable;\
local getmetatable = getmetatable;\
local assert = assert;\
local select = select;\
local coroutine = coroutine;\
local utf8 = utf8;\
local re = re;\
local imgui = imgui;\
local draw = draw;\
local Vector2f = Vector2f;\
local reframework = reframework;\
local os = os;\
\
this.game = {};\
this.game.is_cutscene_playing = false;\
this.game.is_paused = false;\
this.game.is_mercenaries = false;\
\
local pause_off_timer = nil;\
local cutscene_off_timer = nil;\
\
local content_timer_type_def = sdk.find_type_definition(\"app.ContentTimer\");\
local on_pause_method = content_timer_type_def:get_method(\"onPause\");\
\
local event_system_app_type_def = sdk.find_type_definition(\"app.EventSystemApp\");\
local is_running_event_method = event_system_app_type_def:get_method(\"isRunningEvent(System.Boolean)\");\
\
function this.update_is_cutscene()\
\9local event_system_app = singletons.event_system_app;\
\
\9if event_system_app == nil then\
\9\9error_handler.report(\"game_handler.update_is_cutscene\", \"No EventSystemApp\");\
        return;\
    end\
\
\9local is_player_event_playing = is_running_event_method:call(event_system_app, true);\
\9local is_event_playing = is_running_event_method:call(event_system_app, false);\
\
\9if is_player_event_playing == nil then\
\9\9error_handler.report(\"game_handler.update_is_cutscene\",  \"No IsPlayerEventPlaying\");\
\9\9is_player_event_playing = false;\
\9end\
\
\9if is_event_playing == nil then\
\9\9error_handler.report(\"game_handler.update_is_cutscene\", \"No IsEventPlaying\");\
\9\9is_event_playing = false;\
\9end\
\
\9local is_cutscene_playing = is_player_event_playing or is_event_playing;\
\
\9-- Cutscene\
\9if is_cutscene_playing then\
\9\9this.game.is_cutscene_playing = true;\
\9\9time.remove_delay_timer(cutscene_off_timer);\
\9\9cutscene_off_timer = nil;\
\9\9return;\
\9end\
\
\9-- Game No Cutscene, State No Cutscene\
\9if not this.game.is_cutscene_playing then\
\9\9time.remove_delay_timer(cutscene_off_timer);\
\9\9cutscene_off_timer = nil;\
\9\9return;\
\9end\
\
\9-- Game No Cutscene, State Cutscene, Timer is On\
\9if cutscene_off_timer ~= nil then\
\9\9return;\
\9end\
\
\9-- Game No Cutscene, State Cutscene, Timer is Off\
\9cutscene_off_timer = time.new_delay_timer(function()\
\9\9this.game.is_cutscene_playing = false;\
\9\9cutscene_off_timer = nil;\
\9end,\
\0091.2 * enemy_handler.update_time_limit);\
end\
\
function this.update_is_mercenaries()\
\9this.game.is_mercenaries = singletons.rogue_enemy_health_holder ~= nil;\
end\
\
function this.update()\
\9this.update_is_cutscene();\
\9this.update_is_mercenaries();\
end\
\
function this.on_pause(is_paused_int)\
\9if is_paused_int == nil then\
\9\9error_handler.report(\"game_handler.on_pause\", \"No IsPaused Int\");\
\9\9return;\
\9end\
\
\9local is_paused = (is_paused_int & 1) == 1;\
\
\9-- Pause\
\9if is_paused then\
\9\9this.game.is_paused = true;\
\9\9time.remove_delay_timer(pause_off_timer);\
\9\9pause_off_timer = nil;\
\9\9return;\
\9end\
\
\9-- Game No Pause, State No Pause\
\9if not this.game.is_paused then\
\9\9time.remove_delay_timer(pause_off_timer);\
\9\9pause_off_timer = nil;\
\9\9return;\
\9end\
\
\9-- Game No Pause, State Pause, Timer is On\
\9if pause_off_timer ~= nil then\
\9\9return;\
\9end\
\
\9-- Game No Pause, State Pause, Timer is Off\
\9pause_off_timer = time.new_delay_timer(function()\
\9\9this.game.is_paused = false;\
\9\9pause_off_timer = nil;\
\9end,\
\0091.2 * enemy_handler.update_time_limit);\
end\
\
function this.init_module()\
\9singletons = require(\"Health_Bars.singletons\");\
\9customization_menu = require(\"Health_Bars.customization_menu\");\
\9time = require(\"Health_Bars.time\");\
\9enemy_handler = require(\"Health_Bars.enemy_handler\");\
\9error_handler = require(\"Health_Bars.error_handler\");\
\
\9sdk.hook(on_pause_method, function(args)\
\
\9\9local is_paused_int = sdk.to_int64(args[3]);\
\9\9this.on_pause(is_paused_int);\
\
\9end, function(retval)\
\9\9return retval;\
\9end);\
end\
\
return this;", '@'..".\\Health_Bars\\game_handler.lua" ) )

package.preload[ "Health_Bars.helpers.drawing" ] = assert( (loadstring or load)( "local this = {};\
\
local modules = require(\"Health_Bars.modules\");\
\
this.dynamic_font = nil;\
\
function this.create_font(ui_font_config)\
\9local reframework_font_size = 16;\
\
    if ui_font_config.scale_with_reframework_font_size then\
        reframework_font_size = modules.reframework_globals.imgui.get_default_font_size();\
    end\
\
\9local final_size = modules.utils.math.round(ui_font_config.size_scale_modifier * reframework_font_size);\
\
\9return modules.reframework_globals.d2d.Font.new(ui_font_config.family, final_size, ui_font_config.bold, ui_font_config.italic);\
end\
\
function this.init_font()\
\9local cached_config = modules.config.current_config.ui_font;\
\
\9this.dynamic_ui_font = this.create_font(cached_config.dynamic_ui);\
\9this.boss_ui_font = this.create_font(cached_config.boss_ui);\
end\
\
function this.argb_color_to_abgr_color(argb_color)\
\9local alpha = (argb_color >> 24) & 0xFF;\
\9local red = (argb_color >> 16) & 0xFF;\
\9local green = (argb_color >> 8) & 0xFF;\
\9local blue = argb_color & 0xFF;\
\
\9local abgr_color = 0x1000000 * alpha + 0x10000 * blue + 0x100 * green + red;\
\
\9return abgr_color;\
end\
\
function this.color_to_argb(color)\
\9local alpha = (color >> 24) & 0xFF;\
\9local red = (color >> 16) & 0xFF;\
\9local green = (color >> 8) & 0xFF;\
\9local blue = color & 0xFF;\
\
\9return alpha, red, green, blue;\
end\
\
function this.argb_to_color(alpha, red, green, blue)\
\9return 0x1000000 * alpha + 0x10000 * red + 0x100 * green + blue;\
end\
\
function this.scale_color_opacity(color, scale)\
\9local alpha, red, green, blue = this.color_to_argb(color);\
\9local new_alpha = math.floor(alpha * scale);\
\9if new_alpha < 0 then\
\9\9new_alpha = 0;\
\9end\
\9if new_alpha > 255 then\
\9\9new_alpha = 255;\
\9end\
\
\9return this.argb_to_color(new_alpha, red, green, blue);\
end\
\
function this.get_alignment_shifts(text, alignment, use_boss_ui_font)\
\9local cached_default_language = modules.language.default_language.customization_menu;\
\
\9if alignment == cached_default_language.top_left or alignment == nil then\
\9\9return 0, 0;\
\9end\
\
\9local width, height;\
\
\9local use_d2d = modules.reframework_globals.d2d ~= nil and modules.config.current_config.settings.use_d2d_if_available;\
\
\9local font;\
\
\9if use_boss_ui_font then\
\9\9font = this.boss_ui_font;\
\9else\
\9\9font = this.dynamic_ui_font;\
\9end\
\
    if use_d2d and font ~= nil then\
        width, height = modules.reframework_globals.d2d.Font.measure(font, text);\
    else\
        local text_size = modules.reframework_globals.imgui.calc_text_size(text);\
        width = text_size.x;\
        height = text_size.y;\
    end\
\
\9if alignment == cached_default_language.top_middle then\
\9\9return -width / 2, 0;\
\9elseif alignment == cached_default_language.top_right then\
\9\9return -width, 0;\
\9elseif alignment == cached_default_language.middle_left then\
\9\9return 0, -height / 2;\
\9elseif alignment == cached_default_language.center then\
\9\9return -width / 2, -height / 2;\
\9elseif alignment == cached_default_language.middle_right then\
\9\9return -width, -height / 2;\
\9elseif alignment == cached_default_language.bottom_left then\
\9\9return 0, -height;\
\9elseif alignment == cached_default_language.bottom_middle then\
\9\9return -width / 2, -height;\
\9elseif alignment == cached_default_language.bottom_right then\
\9\9return -width, -height;\
\9end\
\
\9return 0, 0;\
end\
\
function this.draw_label(label, position, opacity_scale, use_boss_ui_font, ...)\
\9if label == nil or not label.visible then\
\9\9return;\
\9end\
\
\9local text = string.format(\"%s\", table.unpack({...}));\
\
    if text == \"\" then\
        return;\
    end\
\
\9local font;\
\
\9if use_boss_ui_font then\
\9\9font = this.boss_ui_font;\
\9else\
\9\9font = this.dynamic_ui_font;\
\9end\
\
\9local alignment_x, alignment_y = this.get_alignment_shifts(text, label.settings.alignment, use_boss_ui_font);\
\
\9local scaled_label_offset_x, scaled_label_offset_y = modules.utils.misc.scale_position(label.offset.x, label.offset.y);\
\
\9local position_x = position.x + scaled_label_offset_x + alignment_x;\
\9local position_y = position.y + scaled_label_offset_y + alignment_y;\
\
\9local use_d2d = modules.reframework_globals.d2d ~= nil and modules.config.current_config.settings.use_d2d_if_available;\
\
\9if label.shadow.visible then\
\9\9local new_shadow_color = label.shadow.color;\
\
\9\9if opacity_scale < 1 then\
\9\9\9new_shadow_color = this.scale_color_opacity(new_shadow_color, opacity_scale);\
\9\9end\
\
\9\9if use_d2d then\
\9\9\9modules.reframework_globals.d2d.text(font, text, position_x + label.shadow.offset.x, position_y + label.shadow.offset.y, new_shadow_color);\
\9\9else\
\9\9\9new_shadow_color = this.argb_color_to_abgr_color(new_shadow_color);\
\9\9\9modules.reframework_globals.draw.text(text, position_x + label.shadow.offset.x, position_y + label.shadow.offset.y, new_shadow_color);\
\9\9end\
\9end\
\
\9local new_color = label.color;\
    if opacity_scale < 1 then\
        new_color = this.scale_color_opacity(new_color, opacity_scale);\
    end\
\9\
\9if use_d2d then\
\9\9modules.reframework_globals.d2d.text(font, text, position_x, position_y, new_color);\
\9else\
\9\9new_color = this.argb_color_to_abgr_color(new_color);\
\9\9modules.reframework_globals.draw.text(text, position_x, position_y, new_color);\
\9end\
end\
\
function this.draw_bar(bar, position, opacity_scale, percentage)\
\9local cached_default_language = modules.language.default_language.customization_menu;\
\
\9if bar == nil or not bar.visible then\
\9\9return;\
\9end\
\
\9if percentage > 1 then\
\9\9percentage = 1;\
\9end\
\
\9if percentage < 0 then\
\9\9percentage = 0;\
\9end\
\
\9-- Apply inverted setting if enabled\
\9if bar.settings.inverted then\
\9\9percentage = 1 - percentage;\
\9end\
\
\9local outline_visible = bar.outline.visible;\
\9local style = bar.outline.style; -- Inside/Center/Outside\
\9local fill_direction = bar.settings.fill_direction; -- Left to Right/Right to Left/Top to Bottom/Bottom to Top\
\9local colors = bar.colors;\
\
\9-- Scale outline dimensions using resolution-aware scaling\
\9local scaled_outline_thickness, scaled_outline_offset = modules.utils.misc.scale_size(bar.outline.thickness, bar.outline.offset);\
\
\9-- Scale bar size using resolution-aware scaling\
\9local scaled_bar_width, scaled_bar_height = modules.utils.misc.scale_size(bar.size.width, bar.size.height);\
\
\9local outline_thickness = scaled_outline_thickness;\
\9if not outline_visible then\
\9\9outline_thickness = 0;\
\9end\
\
\9local half_outline_thickness = outline_thickness / 2;\
\
\9local outline_offset = scaled_outline_offset;\
\
\9if outline_thickness == 0 then\
\9\9outline_offset = 0;\
\9end\
\9local half_outline_offset = outline_offset / 2;\
\
\9local outline_position_x = 0;\
\9local outline_position_y = 0;\
\
\9local outline_width = 0;\
\9local outline_height = 0;\
\
\9local position_x = 0;\
\9local position_y = 0;\
\
\9local width = 0;\
\9local height = 0;\
\
\9local foreground_width = 0;\
\9local foreground_height = 0;\
\
\9local background_width = 0;\
\9local background_height = 0;\
\
\9local foreground_shift_x = 0;\
\9local foreground_shift_y = 0;\
\
\9local background_shift_x = 0;\
\9local background_shift_y = 0;\
\
\9if style == modules.language.default_language.customization_menu.inside then\
\9\9outline_position_x = position.x + half_outline_thickness;\
\9\9outline_position_y = position.y + half_outline_thickness;\
\
\9\9outline_width = scaled_bar_width - outline_thickness;\
\9\9outline_height = scaled_bar_height - outline_thickness;\
\
\9\9position_x = outline_position_x + half_outline_thickness + outline_offset;\
\9\9position_y = outline_position_y + half_outline_thickness + outline_offset;\
\
\9\9width = outline_width - outline_thickness - outline_offset - outline_offset;\
\9\9height = outline_height - outline_thickness - outline_offset - outline_offset;\
\
\9elseif style == modules.language.default_language.customization_menu.center then\
\9\9outline_position_x = position.x - half_outline_offset;\
\9\9outline_position_y = position.y - half_outline_offset;\
\
\9\9outline_width = scaled_bar_width + outline_offset;\
\9\9outline_height = scaled_bar_height + outline_offset;\
\
\9\9position_x = outline_position_x + half_outline_thickness + outline_offset;\
\9\9position_y = outline_position_y + half_outline_thickness + outline_offset;\
\
\9\9width = outline_width - outline_thickness - outline_offset - outline_offset;\
\9\9height = outline_height - outline_thickness - outline_offset - outline_offset;\
\
\9else -- Outside\
\9\9position_x = position.x;\
\9\9position_y = position.y;\
\
\9\9width = scaled_bar_width;\
\9\9height = scaled_bar_height;\
\
\9\9outline_position_x = position_x - half_outline_thickness - outline_offset;\
\9\9outline_position_y = position_y - half_outline_thickness - outline_offset;\
\
\9\9outline_width = width + outline_thickness + outline_offset + outline_offset;\
\9\9outline_height = height + outline_thickness + outline_offset + outline_offset;\
\9end\
\
\9if fill_direction == cached_default_language.right_to_left then\
\9\9foreground_width = width * percentage;\
\9\9foreground_height = height;\
\
\9\9background_width = width - foreground_width;\
\9\9background_height = height;\
\
\9\9foreground_shift_x = background_width;\
\
\9elseif fill_direction == cached_default_language.top_to_bottom then\
\9\9foreground_width = width;\
\9\9foreground_height = height * percentage;\
\
\9\9background_width = width;\
\9\9background_height = height - foreground_height;\
\
\9\9background_shift_y = foreground_height;\
\
\9elseif fill_direction == cached_default_language.bottom_to_top then\
\9\9foreground_width = width;\
\9\9foreground_height = height * percentage;\
\
\9\9background_width = width;\
\9\9background_height = height - foreground_height;\
\
\9\9foreground_shift_y = background_height;\
\
\9else -- Left to Right\
\9\9foreground_width = width * percentage;\
\9\9foreground_height = height;\
\
\9\9background_width = width - foreground_width;\
\9\9background_height = height;\
\
\9\9background_shift_x = foreground_width;\
\9end;\
\9\
\9local foreground_color = colors.foreground;\
\9local background_color = colors.background;\
\9local outline_color = colors.outline;\
\
\9if opacity_scale < 1 then\
\9\9foreground_color = this.scale_color_opacity(foreground_color, opacity_scale);\
\9\9background_color = this.scale_color_opacity(background_color, opacity_scale);\
\9\9outline_color = this.scale_color_opacity(outline_color, opacity_scale);\
\9end\
\
\9local use_d2d = modules.reframework_globals.d2d ~= nil and modules.config.current_config.settings.use_d2d_if_available;\
\
\9-- background\
\9if background_width ~= 0 then\
\9\9if use_d2d then\
\9\9\9modules.reframework_globals.d2d.fill_rect(position_x + background_shift_x, position_y + background_shift_y, background_width, background_height, background_color);\
\9\9else\
\9\9\9background_color = this.argb_color_to_abgr_color(background_color);\
\9\9\9modules.reframework_globals.draw.filled_rect(position_x + background_shift_x, position_y + background_shift_y, background_width, background_height, background_color)\
\9\9end\
\9end\
\
\9-- foreground\
\9if foreground_width ~= 0 then\
\9\9if use_d2d then\
\9\9\9modules.reframework_globals.d2d.fill_rect(position_x + foreground_shift_x, position_y + foreground_shift_y, foreground_width, foreground_height, foreground_color);\
\9\9else\
\9\9\9foreground_color = this.argb_color_to_abgr_color(foreground_color);\
\9\9\9modules.reframework_globals.draw.filled_rect(position_x + foreground_shift_x, position_y + foreground_shift_y, foreground_width, foreground_height, foreground_color)\
\9\9end\
\9end\
\
\9-- outline\
\9if outline_thickness ~= 0 then\
\9\9if use_d2d then\
\9\9\9modules.reframework_globals.d2d.outline_rect(outline_position_x, outline_position_y, outline_width, outline_height, outline_thickness, outline_color);\
\9\9else\
\9\9\9outline_color = this.argb_color_to_abgr_color(outline_color);\
\9\9\9modules.reframework_globals.draw.outline_rect(outline_position_x, outline_position_y, outline_width, outline_height, outline_color);\
\9\9end\
\9end\
end\
\
function this.init_module()\
end\
\
return this;\
", '@'..".\\Health_Bars\\helpers\\drawing.lua" ) )

package.preload[ "Health_Bars.helpers.error_handler" ] = assert( (loadstring or load)( "local this = {};\
\
local modules = require(\"Health_Bars.modules\");\
\
this.list = {};\
this.is_empty = true;\
\
this.history = {};\
\
function this.report(error_key, error_message)\
\9if error_key == nil or error_key == \"\"\
\9or error_message == nil or error_message == \"\" then\
\9\9return;\
\9end\
\
\9local error_time = modules.time.total_elapsed_script_seconds;\
\
\9if modules.utils.number.is_equal(error_time, 0) then\
\9\9return;\
\9end\
\
\9local error = {\
\9\9key = error_key,\
\9\9time = error_time,\
\9\9message = error_message\
\9};\
\
\9this.list[error_key] = error;\
\9this.is_empty = false;\
\
\9this.add_to_history(error_key, error);\
end\
\
function this.add_to_history(error_key, error)\
\9this.clear_history();\
\
\9table.insert(this.history, error);\
end\
\
function this.clear_history()\
\9local history_size = modules.config.current_config.debug.history_size;\
\
\9while #this.history >= history_size do\
\9\9table.remove(this.history, 1);\
\9end\
end\
\
function this.init_module()\
end\
\
return this;", '@'..".\\Health_Bars\\helpers\\error_handler.lua" ) )

package.preload[ "Health_Bars.helpers.log" ] = assert( (loadstring or load)( "local this = {};\
\
local modules = require(\"Health_Bars.modules\");\
\
function this.info(text)\
    modules.reframework_globals.log.info(\"[\" .. tostring(modules.language.default_language.customization_menu.mod_name) ..\"] \" .. tostring(text));\
end\
\
function this.warn(text)\
    modules.reframework_globals.log.warn(\"[\" .. tostring(modules.language.default_language.customization_menu.mod_name) ..\"] \" .. tostring(text));\
end\
\
function this.debug(text)\
    modules.reframework_globals.log.debug(\"[\" .. tostring(modules.language.default_language.customization_menu.mod_name) ..\"] \" .. tostring(text));\
end\
\
function this.error(text)\
    modules.reframework_globals.log.error(\"[\" .. tostring(modules.language.default_language.customization_menu.mod_name) ..\"] \" .. tostring(text));\
end\
\
function this.init_module()\
end\
\
return this;", '@'..".\\Health_Bars\\helpers\\log.lua" ) )

package.preload[ "Health_Bars.helpers.screen" ] = assert( (loadstring or load)( "local this = {};\
\
local modules = require(\"Health_Bars.modules\");\
\
this.width = 1920;\
this.height = 1080;\
this.auto_scale_modifier = 1;\
\
local scene_view;\
local scene_view_type = modules.reframework_globals.sdk.find_type_definition(\"via.SceneView\");\
local get_size_method = scene_view_type:get_method(\"get_Size\");\
\
local size_type = get_size_method:get_return_type();\
local width_field = size_type:get_field(\"w\");\
local height_field = size_type:get_field(\"h\");\
\
function this.update_window_size()\
\9local width;\
\9local height;\
\
    width, height = this.get_game_window_size();\
\9\
\9if width ~= nil then\
\9\9this.width = width;\
\9end\
\
\9if height ~= nil then\
\9\9this.height = height;\
\9\9this.auto_scale_modifier = this.height / 1080;\
\9end\
end\
\
function this.get_game_window_size()\
    if scene_view == nil then\
        if modules.singletons.scene_manager == nil then\
            return;\
        end\
\
        scene_view = modules.reframework_globals.sdk.call_native_func(modules.singletons.scene_manager,\
            modules.reframework_globals.sdk.find_type_definition(\"via.SceneManager\"), \"get_MainView\");\
\
        if scene_view == nil then\
            return;\
        end\
    end\
\
    local size = get_size_method:call(scene_view);\
    if size == nil then\
        return;\
    end\
\
    local screen_width = width_field:get_data(size);\
    if screen_width == nil then\
        return;\
    end\
\
    local screen_height = height_field:get_data(size);\
    if screen_height == nil then\
        return;\
    end\
\
    return screen_width, screen_height;\
end\
\
function this.init_module()\
end\
\
return this;\
", '@'..".\\Health_Bars\\helpers\\screen.lua" ) )

package.preload[ "Health_Bars.helpers.singletons" ] = assert( (loadstring or load)( "local this = {};\
\
local modules = require(\"Health_Bars.modules\");\
\
local scene_manager_name = \"via.SceneManager\";\
local enemy_manager_name = \"app.EnemyManager\";\
local event_system_app_name = \"app.EventSystemApp\";\
local props_manager_name = \"app.PropsManager\";\
local map_manager_name = \"app.MapManager\";\
\
this.scene_manager = nil;\
this.enemy_manager = nil;\
this.event_system_app = nil;\
this.props_manager = nil;\
this.map_manager = nil;\
\
function this.update()\
\9this.update_scene_manager();\
    this.update_enemy_manager();\
    this.update_event_system_app();\
    this.update_props_manager();\
\9this.update_map_manager();\
end\
\
function this.update_scene_manager()\
\9this.scene_manager = modules.reframework_globals.sdk.get_native_singleton(scene_manager_name);\
    if this.scene_manager == nil then\
        modules.error_handler.report(\"singletons.update_scene_manager\", \"No SceneManager\");\
    end\
\9\
\9return this.scene_manager;\
end\
\
function this.update_enemy_manager()\
\9this.enemy_manager = modules.reframework_globals.sdk.get_managed_singleton(enemy_manager_name);\
\9if this.enemy_manager == nil then\
\9\9modules.error_handler.report(\"singletons.update_enemy_manager\", \"No EnemyManager\");\
\9end\
\
\9return this.enemy_manager;\
end\
\
function this.update_event_system_app()\
\9this.event_system_app = modules.reframework_globals.sdk.get_managed_singleton(event_system_app_name);\
\9if this.event_system_app == nil then\
\9\9modules.error_handler.report(\"singletons.update_event_system_app\",\"No EventSystemApp\");\
\9end\
\
\9return this.event_system_app;\
end\
\
function this.update_props_manager()\
\9this.props_manager = modules.reframework_globals.sdk.get_managed_singleton(props_manager_name);\
\9if this.props_manager == nil then\
\9\9modules.error_handler.report(\"singletons.update_props_manager\", \"No Props Manager\");\
\9end\
\
\9return this.props_manager;\
end\
\
function this.update_map_manager()\
\9this.map_manager = modules.reframework_globals.sdk.get_managed_singleton(map_manager_name);\
\9if this.map_manager == nil then\
\9\9modules.error_handler.report(\"singletons.update_map_manager\", \"No MapManager\");\
\9end\
\
\9return this.map_manager;\
end\
\
function this.init_module()\
\9this.update();\
end\
\
return this;\
", '@'..".\\Health_Bars\\helpers\\singletons.lua" ) )

package.preload[ "Health_Bars.helpers.throttle" ] = assert( (loadstring or load)( "local this = {};\
\
local modules = require(\"Health_Bars.modules\");\
\
-- Registry: callback -> { delay, last_execution_time }\
local throttle_registry = {};\
\
--- Throttles a callback execution.\
--- If enough time has passed since the last execution for this callback, executes immediately.\
--- Otherwise, the call and its arguments are silently dropped.\
--- @param callback function The function to throttle.\
--- @param delay number The minimum time in seconds between executions.\
--- @param ... any Arguments to pass to the callback when executed.\
function this.throttle(callback, delay, ...)\
\9if callback == nil or delay == nil then\
\9\9return\
\9end\
\
\9local entry = throttle_registry[callback];\
\
\9if entry == nil then\
\9\9-- First call for this callback: always execute\
\9\9entry = {\
\9\9\9delay = delay,\
\9\9\9last_execution_time = 0,\
\9\9};\
\9\9throttle_registry[callback] = entry;\
\9end\
\
\9-- Update delay (user can change it at runtime)\
\9entry.delay = delay;\
\
\9local now = modules.time.total_elapsed_script_seconds;\
\9local elapsed = now - entry.last_execution_time;\
\
\9if elapsed > entry.delay then\
\9\9entry.last_execution_time = now;\
\9\9callback(...);\
\9end\
end\
\
--- Removes a throttle entry for a callback.\
--- @param callback function The callback to remove.\
function this.remove(callback)\
\9if callback ~= nil then\
\9\9throttle_registry[callback] = nil;\
\9end\
end\
\
--- Initializes the module.\
function this.init_module()\
end\
\
return this;\
", '@'..".\\Health_Bars\\helpers\\throttle.lua" ) )

package.preload[ "Health_Bars.helpers.time" ] = assert( (loadstring or load)( "local this = {};\
\
local modules = require(\"Health_Bars.modules\");\
\
this.total_elapsed_script_seconds = 0;\
\
this.timer_list = {};\
this.delay_timer_list = {};\
\
function this.new_timer(callback, cooldown_seconds, start_offset_seconds)\
\9start_offset_seconds = start_offset_seconds or modules.utils.math.random();\
\
\9if callback == nil or cooldown_seconds == nil then\
\9\9return;\
\9end\
\
\9local timer = {};\
\9timer.callback = callback;\
\9timer.cooldown = cooldown_seconds;\
\
\9timer.last_trigger_time = this.total_elapsed_script_seconds + start_offset_seconds;\
\
\9this.timer_list[callback] =  timer;\
end\
\
function this.new_delay_timer(callback, delay_seconds)\
\9if callback == nil or delay_seconds == nil then\
\9\9return;\
\9end\
\
\9local delay_timer = {};\
\9delay_timer.callback = callback;\
\9delay_timer.delay = delay_seconds;\
\
\9delay_timer.init_time = this.total_elapsed_script_seconds;\
\
\9this.delay_timer_list[callback] = delay_timer;\
\
\9return delay_timer;\
end\
\
function this.remove_delay_timer(delay_timer)\
\9if delay_timer == nil then\
\9\9return;\
\9end\
\
\9this.delay_timer_list[delay_timer.callback] = nil;\
end\
\
function this.update_timers()\
\9this.update_script_time();\
\
\9for callback, timer in pairs(this.timer_list) do\
\9\9if this.total_elapsed_script_seconds - timer.last_trigger_time > timer.cooldown then\
\9\9\9timer.last_trigger_time = this.total_elapsed_script_seconds;\
\9\9\9callback();\
\9\9end\
\9end\
\
\9local remove_list = {};\
\
\9for callback, delay_timer in pairs(this.delay_timer_list) do\
\9\9if this.total_elapsed_script_seconds - delay_timer.init_time > delay_timer.delay then\
\9\9\9callback();\
\9\9\9table.insert(remove_list, callback);\
\9\9end\
\9end\
\
\9for i, callback in ipairs(remove_list) do\
\9\9this.delay_timer_list[callback] = nil;\
\9end\
end\
\
function this.update_script_time()\
\9this.total_elapsed_script_seconds = os.clock();\
end\
\
function this.init_module()\
end\
\
return this;", '@'..".\\Health_Bars\\helpers\\time.lua" ) )

package.preload[ "Health_Bars.helpers.utils" ] = assert( (loadstring or load)( "local this = {};\
\
local modules = require(\"Health_Bars.modules\");\
\
local table_tostring;\
local deep_copy;\
local merge;\
local is_empty;\
local unicode_map;\
local unicode_relative_position;\
local unicode_chars;\
local epsilon = 0.000001;\
\
this.table = {};\
this.type = {};\
this.number = {};\
this.string = {};\
this.vec2 = {};\
this.vec3 = {};\
this.vec4 = {};\
this.math = {};\
this.unicode = {};\
this.sdk = {};\
this.imgui = {};\
this.misc = {};\
\
this.constants = {};\
this.constants.uninitialized_int = -420;\
this.constants.uninitialized_string = \"Uninitialized\";\
this.constants.epsilon = epsilon;\
\
function this.table.tostring(table_)\
\9if type(table_) == \"number\" or type(table_) == \"boolean\" or type(table_) == \"string\" then\
\9\9return tostring(table_);\
\9end\
\
\9if is_empty(table_) then\
\9\9return \"{}\"; \
\9end\
\
\9local cache = {};\
\9local stack = {};\
\9local output = {};\
    local depth = 1;\
    local output_str = \"{\\n\";\
\
    while true do\
        local size = 0;\
        for k,v in pairs(table_) do\
            size = size + 1;\
        end\
\
        local cur_index = 1;\
        for k,v in pairs(table_) do\
            if cache[table_] == nil or cur_index >= cache[table_] then\
\
                if string.find(output_str, \"}\", output_str:len()) then\
                    output_str = output_str .. \",\\n\";\
                elseif not string.find(output_str, \"\\n\", output_str:len()) then\
                    output_str = output_str .. \"\\n\";\
                end\
\
                -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings\
                table.insert(output,output_str);\
                output_str = \"\";\
\
                local key;\
                if type(k) == \"number\" or type(k) == \"boolean\" then\
                    key = \"[\" .. tostring(k) .. \"]\";\
                else\
                    key = \"['\" .. tostring(k) .. \"']\";\
                end\
\
                if type(v) == \"number\" or type(v) == \"boolean\" then\
                    output_str = output_str .. string.rep('\\t', depth) .. key .. \" = \" .. tostring(v);\
                elseif type(v) == \"table\" then\
                    output_str = output_str .. string.rep('\\t', depth) .. key .. \" = {\\n\";\
                    table.insert(stack, table_);\
                    table.insert(stack, v);\
                    cache[table_] = cur_index + 1;\
                    break;\
                else\
                    output_str = output_str .. string.rep('\\t', depth) .. key .. \" = '\" .. tostring(v) .. \"'\";\
                end\
\
                if cur_index == size then\
                    output_str = output_str .. \"\\n\" .. string.rep('\\t', depth - 1) .. \"}\";\
                else\
                    output_str = output_str .. \",\";\
                end\
            else\
                -- close the table\
                if cur_index == size then\
                    output_str = output_str .. \"\\n\" .. string.rep('\\t', depth - 1) .. \"}\";\
                end\
            end\
\
            cur_index = cur_index + 1;\
        end\
\
        if size == 0 then\
            output_str = output_str .. \"\\n\" .. string.rep('\\t', depth - 1) .. \"}\";\
        end\
\
        if #stack > 0 then\
            table_ = stack[#stack];\
            stack[#stack] = nil;\
            depth = cache[table_] == nil and depth + 1 or depth - 1;\
        else\
            break;\
        end\
    end\
\
    -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings\
    table.insert(output, output_str);\
    output_str = table.concat(output);\
\
    return output_str;\
end\
\
function this.table.tostringln(table_)\
\9return \"\\n\" .. table_tostring(table_);\
end\
\
function this.table.is_empty(table_)\
\9return next(table_) == nil;\
end\
\
function this.table.deep_copy(original, copies)\
\9copies = copies or {};\
\9local original_type = type(original);\
\9local copy;\
\9if original_type == \"table\" then\
\9\9if copies[original] then\
\9\9\9copy = copies[original];\
\9\9else\
\9\9\9copy = {};\
\9\9\9copies[original] = copy;\
\9\9\9for original_key, original_value in next, original, nil do\
\9\9\9\9copy[deep_copy(original_key, copies)] = deep_copy(original_value,copies);\
\9\9\9end\
\9\9\9setmetatable(copy, deep_copy(getmetatable(original), copies));\
\9\9end\
\9else -- number, string, boolean, etc\
\9\9copy = original;\
\9end\
\9return copy;\
end\
\
function this.table.find_index(table_, value, nullable)\
\9for i = 1, #table_ do\
\9\9if table_[i] == value then\
\9\9\9return i;\
\9\9end\
\9end\
\
\9if not nullable then\
\9\9return 1;\
\9end\
\
\9return nil;\
end\
\
function this.table.merge(...)\
\9local tables_to_merge = { ... };\
\9assert(#tables_to_merge > 1, \"There should be at least two tables to merge them\");\
\
\9for key, table_ in ipairs(tables_to_merge) do\
\9\9assert(type(table_) == \"table\", string.format(\"Expected a table as function parameter %d\", key));\
\9end\
\
\9local result = deep_copy(tables_to_merge[1]);\
\
\9for i = 2, #tables_to_merge do\
\9\9local from = tables_to_merge[i];\
\9\9for key, value in pairs(from) do\
\9\9\9if type(value) == \"table\" then\
\9\9\9\9result[key] = result[key] or {};\
\9\9\9\9assert(type(result[key]) == \"table\", string.format(\"Expected a table: '%s'\", key));\
\9\9\9\9result[key] = merge(result[key], value);\
\9\9\9else\
\9\9\9\9result[key] = value;\
\9\9\9end\
\9\9end\
\9end\
\
\9return result;\
end\
\
function this.type.is_boolean(value)\
\9return value == true or value == false;\
end\
\
function this.type.is_REField(value)\
\9return \9value.get_return_type == nil;\
end\
\
function this.type.is_REMethodDefinition(value)\
\9return \9value.get_return_type ~= nil;\
end\
\
function this.number.is_NaN(value)\
\9return tostring(value) == tostring(0/0);\
end\
\
function this.number.round(value)\
\9return math.floor(value + 0.5);\
end\
\
function this.number.is_odd(value)\
\9return value % 2 ~= 0;\
end\
\
function this.number.is_even(value)\
\9return value % 2 == 0;\
end\
\
function this.number.is_equal(value1, value2)\
\9if math.abs(value1 - value2) < epsilon then\
\9\9return true;\
\9end\
\
\9return false;\
end\
\
function this.string.trim(str)\
\9return str:match(\"^%s*(.-)%s*$\");\
end\
\
function this.string.starts_with(str, pattern)\
\9return str:find(\"^\" .. pattern) ~= nil;\
end\
\
function this.vec2.tostring(vector2f)\
\9return string.format(\"<%f, %f>\", vector2f.x, vector2f.y);\
end\
\
function this.vec2.random(distance)\
\9distance = distance or 1;\
\9local radians = math.random() * math.pi * 2;\
\9return modules.reframework_globals.Vector2f.new(\
\9\9distance * math.cos(radians),\
\9\9distance * math.sin(radians)\
\9);\
end\
\
function this.vec3.tostring(vector3f)\
\9return string.format(\"<%f, %f, %f>\", vector3f.x, vector3f.y, vector3f.z);\
end\
\
function this.vec4.tostring(vector4f)\
\9return string.format(\"<%f, %f, %f, %f>\", vector4f.x, vector4f.y, vector4f.z, vector4f.w);\
end\
\
--- When called without arguments, returns a pseudo-random float with uniform distribution in the range [0,1). When called with two floats min and max, math.random returns a pseudo-random float with uniform distribution in the range [min, max). The call .random(max) is equivalent to .random(1, max)\
---@param min number?\
---@param max number?\
---@return number\
function this.math.random(min, max)\
\9if min == nil and max == nil then\
\9\9return math.random();\
\9end\
\
\9if max == nil then\
\9\9return 1 + (min - 1) * math.random();\
\9end\
\
\9return min + (max - min) * math.random();\
end\
\
function this.math.sign(value)\
\9return (value >= 0 and 1) or -1;\
end\
function this.math.round(value, bracket)\
\9bracket = bracket or 1;\
\9return math.floor(value / bracket + this.math.sign(value) * 0.5) * bracket;\
end\
\
-- https://github.com/blitmap/lua-utf8-simple/blob/master/utf8_simple.lua\
\
-- ABNF from RFC 3629\
--\
-- UTF8-octets = *( UTF8-char )\
-- UTF8-char = UTF8-1 / UTF8-2 / UTF8-3 / UTF8-4\
-- UTF8-1 = %x00-7F\
-- UTF8-2 = %xC2-DF UTF8-tail\
-- UTF8-3 = %xE0 %xA0-BF UTF8-tail / %xE1-EC 2( UTF8-tail ) /\
-- %xED %x80-9F UTF8-tail / %xEE-EF 2( UTF8-tail )\
-- UTF8-4 = %xF0 %x90-BF 2( UTF8-tail ) / %xF1-F3 3( UTF8-tail ) /\
-- %xF4 %x80-8F 2( UTF8-tail )\
-- UTF8-tail = %x80-BF\
\
-- 0xxxxxxx                            | 007F   (127)\
-- 110xxxxx\00910xxxxxx                   | 07FF   (2047)\
-- 1110xxxx\00910xxxxxx 10xxxxxx          | FFFF   (65535)\
-- 11110xxx\00910xxxxxx 10xxxxxx 10xxxxxx | 10FFFF (1114111)\
\
local pattern = \"[%z\\1-\\127\\194-\\244][\\128-\\191]*\";\
\
-- helper function\
function this.unicode.relative_position(position, length)\
\9if position < 0 then\
\9\9position = length + position + 1;\
\9end\
\9return position;\
end\
\
-- THE MEAT\
\
-- maps f over s's utf8 characters f can accept args: (visual_index, utf8_character, byte_index)\
function this.unicode.map(s, f, no_subs)\
\9local i = 0;\
\
\9if no_subs then\
\9\9for b, e in s:gmatch(\"()\" .. pattern .. \"()\") do\
\9\9\9i = i + 1;\
\9\9\9local c = e - b;\
\9\9\9f(i, c, b);\
\9\9end\
\9else\
\9\9for b, c in s:gmatch(\"()(\" .. pattern .. \")\") do\
\9\9\9i = i + 1;\
\9\9\9f(i, c, b);\
\9\9end\
\9end\
end\
\
-- THE REST\
\
-- returns the number of characters in a UTF-8 string\
function this.unicode.len(s)\
\9-- count the number of non-continuing bytes\
\9return select(2, s:gsub('[^\\128-\\193]', ''));\
end\
\
-- replace all utf8 chars with mapping\
function this.unicode.replace(s, map)\
\9return s:gsub(pattern, map);\
end\
\
-- reverse a utf8 string\
function this.unicode.reverse(s)\
\9-- reverse the individual greater-than-single-byte characters\
\9s = s:gsub(pattern, function (c)\
\9\9return #c > 1 and c:reverse()\
\9end);\
\
\9return s:reverse();\
end\
\
-- strip non-ascii characters from a utf8 string\
function this.unicode.strip(s)\
\9return s:gsub(pattern, function(c)\
\9\9return #c > 1 and '';\
\9end);\
end\
\
-- generator for the above -- to iterate over all utf8 chars\
function this.unicode.chars(s, no_subs)\
\9return coroutine.wrap(function()\
\9\9return unicode_map(s, coroutine.yield, no_subs);\
\9end);\
end\
\
-- like string.sub() but i, j are utf8 strings\
-- a utf8-safe string.sub()\
function this.unicode.sub(str, i, j)\
\9if coroutine == nil then\
\9\9return str;\
\9end\
\
\9local l = utf8.len(str);\
\
\9i = unicode_relative_position(i, l);\
\9j = j and unicode_relative_position(j, l) or l;\
\
\9if i < 1 then\
\9\9i = 1;\
\9end\
\
\9if j > l then\
\9\9j = l;\
\9end\
\
\9if i > j then\
\9\9return \"\";\
\9end\
\
\9local diff = j - i;\
\9local iterator = unicode_chars(str, true);\
\
\9-- advance up to i\
\9for _ = 1, i - 1 do\
\9\9iterator();\
\9end\
\
\9local c, b = select(2, iterator());\
\
\9-- i and j are the same, single-character sub\
\9if diff == 0 then\
\9\9if c == nil or b == nil then\
\9        return \"\";\
\9    end\
\9\9\
\9\9return string.sub(str, b, b + c - 1);\
\9end\
\
\9-- guard against exhausted iterator when diff > 0\
\9if b == nil then\
\9\9return string.sub(str, i);\
\9end\
\
\9i = b;\
\
\9-- advance up to j\
\9for _ = 1, diff - 1 do\
\9\9iterator();\
\9end\
\
\9c, b = select(2, iterator());\
\
\9-- guard against exhausted iterator\
\9if c == nil or b == nil then\
\9\9return string.sub(str, i);\
\9end\
\
\9return string.sub(str, i, b + c - 1);\
end\
\
function this.sdk.generate_enum(type_def)\
\9if not type_def then\
\9\9return {};\
\9end\
\
\9local fields = type_def:get_fields();\
\9local enum = {};\
\
\9for i, field in ipairs(fields) do\
\9\9if field:is_static() then\
\9\9\9local name = field:get_name();\
\9\9\9local raw_value = field:get_data(nil);\
\
\9\9\9local enum_entry = {\
\9\9\9\9name = name,\
\9\9\9\9value = raw_value;\
\9\9\9};\
\
\9\9\9table.insert(enum, enum_entry);\
\9\9end\
\9end\
\
\9return enum;\
end\
\
function this.sdk.generate_enum_by_typename(type_name)\
    local type_def = modules.reframework_globals.sdk.find_type_definition(type_name);\
    if not type_def then\
        return {};\
    end;\
\
    return this.sdk.generate_enum(type_def);\
end\
\
\
function this.imgui.label(label, ...)\
    local id_string = \"##\" .. tostring(modules.language.mod_name_underscore);\
    local ids = { ... };\
\9\
    if #ids == 0 then\
\9\9local chars = \"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789\";\
\9\9local random_id = \"\";\
\9\9for _ = 1, 32 do\
\9\9\9random_id = random_id .. chars:sub(math.random(1, #chars), 1);\
\9\9end\
\9\9id_string = id_string .. \".\" .. random_id;\
    else\
\9\9for _, id in ipairs(ids) do\
\9\9\9id_string = id_string .. \".\" .. tostring(id);\
\9\9end\
\9end\
\9\
\9return tostring(label) .. id_string;\
end\
\
function this.misc.scale_position(x, y)\
    local cached_config = modules.config.current_config;\
\
    local auto_scaled_x = x;\
    local auto_scaled_y = y;\
\
    if cached_config.global_modifiers.scale_position_modifier_with_resolution then\
        auto_scaled_x = x * modules.screen.auto_scale_modifier;\
        auto_scaled_y = y * modules.screen.auto_scale_modifier;\
    end\
\
    local scaled_x = auto_scaled_x * cached_config.global_modifiers.position_modifier;\
    local scaled_y = auto_scaled_y * cached_config.global_modifiers.position_modifier;\
\
    return scaled_x, scaled_y;\
end\
\
function this.misc.scale_size(width, height)\
\9local cached_config = modules.config.current_config;\
\
\9local auto_scaled_width = width;\
    local auto_scaled_height = height;\
\
    if cached_config.global_modifiers.scale_size_modifier_with_resolution then\
        auto_scaled_width = width * modules.screen.auto_scale_modifier;\
        auto_scaled_height = height * modules.screen.auto_scale_modifier;\
\9end\
\
    local scaled_x = auto_scaled_width * cached_config.global_modifiers.size_modifier;\
    local scaled_y = auto_scaled_height * cached_config.global_modifiers.size_modifier;\
\
\9return scaled_x, scaled_y;\
end\
\
function this.init_module()\
end\
\
table_tostring = this.table.tostring;\
deep_copy = this.table.deep_copy;\
merge = this.table.merge;\
is_empty = this.table.is_empty;\
unicode_map = this.unicode.map;\
unicode_relative_position = this.unicode.relative_position;\
unicode_chars = this.unicode.chars;\
\
return this;\
", '@'..".\\Health_Bars\\helpers\\utils.lua" ) )

package.preload[ "Health_Bars.infrastructure.config" ] = assert( (loadstring or load)( "local this = {};\
\
local modules = require(\"Health_Bars.modules\");\
\
local version = \"1.3\";\
\
this.current_config = nil;\
this.config_file_name = tostring(modules.language.default_language.customization_menu.mod_name) .. \"/config.json\";\
\
this.default_config = {};\
\
function this.init()\
\9this.default_config = {\
\9\9enabled = true,\
\9\9\
\9\9version = this.version,\
\9\9language = \"default\",\
\
\9\9customization_menu = {\
\9\9\9position = {\
\9\9\9\9x = 480,\
\9\9\9\9y = 200\
\9\9\9},\
\
\9\9\9size = {\
\9\9\9\9width = 650,\
\9\9\9\9height = 480\
\9\9\9},\
\
\9\9\9pivot = {\
\9\9\9\9x = 0,\
\9\9\9\9y = 0\
\9\9\9}\
\9\9},\
\
\9\9global_modifiers = {\
            size_modifier = 1,\
\9\9\9scale_size_modifier_with_resolution = true,\
            position_modifier = 1,\
\9\9\9scale_position_modifier_with_resolution = true\
\9\9},\
\
\9\9menu_font = {\
            size_scale_modifier = 1,\
\9\9\9scale_with_reframework_font_size = true,\
\9\9},\
\
\9\9ui_font = {\
\9\9\9dynamic_ui = {\
\9\9\9\9family = \"Consolas\",\
\9\9\9\9bold = true,\
\9\9\9\9italic = false,\
\9\9\9\9size_scale_modifier = 1,\
\9\9\9\9scale_with_reframework_font_size = true,\
\9\9\9},\
\9\9\9boss_ui = {\
\9\9\9\9family = \"Consolas\",\
\9\9\9\9bold = true,\
\9\9\9\9italic = false,\
\9\9\9\9size_scale_modifier = 1.75,\
\9\9\9\9scale_with_reframework_font_size = true,\
\9\9\9}\
\9\9},\
\
\9\9settings = {\
\9\9\9timer_delays = {\
\9\9\9\9update_singletons_delay = 0,\
\9\9\9\9update_window_size_delay = 0,\
\9\9\9\9update_game_data_delay = 0.1,\
\9\9\9\9update_player_data_delay = 0.1,\
\9\9\9\9update_enemy_data_delay = 0.5,\
\9\9\9},\
\9\9\9\
\9\9\9use_d2d_if_available = true,\
\
\9\9\9hide_if_no_update_function_is_being_called = true,\
\9\9},\
\
\9\9dynamic_ui = {\
\9\9\9visible = true,\
\
\9\9\9settings = {\
\9\9\9\9render_during_cutscenes = false,\
\9\9\9\9render_when_game_timer_is_paused = false,\
\9\9\9\9render_in_mercenaries = false,\
\9\9\9\9\
\9\9\9\9render_in_house_benevientos_basement = false,\
\
\9\9\9\9render_aim_target_enemy = true,\
\9\9\9\9render_damaged_enemies = true,\
\9\9\9\9render_everyone_else = true,\
\
\9\9\9\9render_when_normal = true,\
\9\9\9\9render_when_aiming = true,\
\9\9\9\9render_when_using_scope = true,\
\
\9\9\9\9hide_if_dead = true,\
\9\9\9\9hide_if_full_health = true,\
\9\9\9\9hide_if_enemy_model_is_not_being_rendered = true,\
\9\9\9\9hide_if_player_cant_take_damage = true,\
\9\9\9\9hide_if_player_cant_use_items = true,\
\
\9\9\9\9hide_urias = false,\
\9\9\9\9hide_urias_drac = false,\
\9\9\9\9hide_urias_strajer = false,\
\9\9\9\9hide_bela = false,\
\9\9\9\9hide_bela_invincible = true,\
\9\9\9\9hide_cassandra = false,\
\9\9\9\9hide_cassandra_invincible = true,\
\9\9\9\9hide_daniela = false,\
\9\9\9\9hide_daniela_invincible = true,\
\9\9\9\9hide_dimitrescu_chasing = true,\
\9\9\9\9hide_dimitrescu_boss = false,\
\9\9\9\9hide_angie = true,\
\9\9\9\9hide_varcolac = false,\
\9\9\9\9hide_varcolac_alfa = false,\
\9\9\9\9hide_moreau = false,\
\9\9\9\9hide_sturm = false,\
\9\9\9\9hide_heisenberg = false,\
\9\9\9\9hide_executioner = false,\
\9\9\9\9hide_miranda = false,\
\9\9\9\9hide_miranda_in_dlc = false,\
\
\9\9\9\9hide_leonardo = false,\
\9\9\9\9hide_duke = true,\
\
\9\9\9\9hide_blue_bird = true,\
\9\9\9\9hide_pigs = true,\
\9\9\9\9hide_chickens = true,\
\9\9\9\9hide_goats = true,\
\9\9\9\9hide_fish = true,\
\9\9\9\9hide_catfish = true,\
\9\9\9\9\
\9\9\9\9hide_rose_copies = false,\
\9\9\9\9hide_masked_duke = true,\
\9\9\9\9hide_mia_dolls = true,\
\9\9\9\9hide_dolls = true,\
\9\9\9\9hide_rose_illusion = false,\
\9\9\9\9hide_miranda_crows = true,\
\9\9\9\9hide_ethan_dlc = true,\
\
\9\9\9\9opacity_falloff = true,\
\9\9\9\9max_distance = 30,\
\9\9\9\9scope_opacity_falloff = true,\
\9\9\9\9scope_max_distance = 300,\
\
\9\9\9\9apply_time_duration_on_aiming = false,\
\9\9\9\9apply_time_duration_on_aim_target = false,\
\9\9\9\9apply_time_duration_on_using_scope = false,\
\9\9\9\9apply_time_duration_on_damage_dealt = false,\
\9\9\9\9reset_time_duration_on_aim_target_for_everyone = true,\
\9\9\9\9reset_time_duration_on_damage_dealt_for_everyone = true,\
\9\9\9\9time_duration = 15,\
\9\9\9},\
\
\9\9\9world_offset = {\
\9\9\9\9x = 0,\
\9\9\9\9y = 0.35,\
\9\9\9\9z = 0\
\9\9\9},\
\
\9\9\9offset = {\
\9\9\9\9x = -64,\
\9\9\9\9y = 0\
\9\9\9},\
\9\9\9\
\9\9\9health = {\
                visible = true,\
\9\9\9\9\
\9\9\9\9offset = {\
\9\9\9\9\9x = 0,\
\9\9\9\9\9y = 0\
                },\
\9\9\9\9\
\9\9\9\9value_label = {\
\9\9\9\9\9visible = true,\
\
\9\9\9\9\9settings = {\
\9\9\9\9\9\9alignment = \"Top-Right\",\
\9\9\9\9\9},\
\
\9\9\9\9\9include = {\
\9\9\9\9\9\9current_value = true,\
\9\9\9\9\9\9max_value = true\
\9\9\9\9\9},\
\
\9\9\9\9\9offset = {\
\9\9\9\9\9\9x = 123,\
\9\9\9\9\9\9y = 0\
\9\9\9\9\9},\
\9\9\9\9\9\
\9\9\9\9\9color = 0xFFFFFCC0,\
\
\9\9\9\9\9shadow = {\
\9\9\9\9\9\9visible = true,\
\9\9\9\9\9\9offset = {\
\9\9\9\9\9\9\9x = 1,\
\9\9\9\9\9\9\9y = 1\
\9\9\9\9\9\9},\
\9\9\9\9\9\9color = 0xFF000000\
\9\9\9\9\9}\
                },\
\
\9\9\9\9percentage_label = {\
\9\9\9\9\9visible = false,\
\
\9\9\9\9\9settings = {\
\9\9\9\9\9\9alignment = \"Top-Right\",\
\9\9\9\9\9},\
\
\9\9\9\9\9offset = {\
\9\9\9\9\9\9x = 123,\
\9\9\9\9\9\9y = 39\
\9\9\9\9\9},\
\9\9\9\9\9\
\9\9\9\9\9color = 0xFFFFFCC0,\
\
\9\9\9\9\9shadow = {\
\9\9\9\9\9\9visible = true,\
\9\9\9\9\9\9offset = {\
\9\9\9\9\9\9\9x = 1,\
\9\9\9\9\9\9\9y = 1\
\9\9\9\9\9\9},\
\9\9\9\9\9\9color = 0xFF000000\
\9\9\9\9\9}\
                },\
\9\9\9\9\
\9\9\9\9bar = {\
\9\9\9\9\9visible = true,\
\
\9\9\9\9\9settings = {\
                        fill_direction = \"Left to Right\",\
\9\9\9\9\9\9inverted = false\
\9\9\9\9\9},\
\
\9\9\9\9\9offset = {\
\9\9\9\9\9\9x = 0,\
\9\9\9\9\9\9y = 0\
\9\9\9\9\9},\
\
\9\9\9\9\9size = {\
\9\9\9\9\9\9width = 128,\
\9\9\9\9\9\9height = 8\
\9\9\9\9\9},\
\
\9\9\9\9\9outline = {\
\9\9\9\9\9\9visible = true,\
\9\9\9\9\9\9thickness = 2.5,\
\9\9\9\9\9\9offset = 0,\
\9\9\9\9\9\9style = \"Outside\"\
\9\9\9\9\9},\
\
                    colors = {\
\9\9\9\9\9\9foreground = 0x80A0FF71,\
\9\9\9\9\9\9background = 0x48000000,\
\9\9\9\9\9\9outline = 0x68000000\
\9\9\9\9\9}\
\9\9\9\9},\
\9\9\9},\
\9\9},\
\
\9\9boss_ui = {\
\9\9\9visible = true,\
\9\9\9\
            position = {\
\9\9\9\9x = 0,\
                y = 57,\
\9\9\9\9anchor = \"Top-Middle\"\
            },\
\
\9\9\9spacing = {\
\9\9\9\9x = 0,\
\9\9\9\9y = 64,\
\9\9\9},\
\
\9\9\9settings = {\
\9\9\9\9render_during_cutscenes = false,\
\9\9\9\9render_when_game_timer_is_paused = false,\
\9\9\9\9render_in_mercenaries = true,\
\
\9\9\9\9render_in_house_benevientos_basement = false,\
\
\9\9\9\9render_when_normal = true,\
\9\9\9\9render_when_aiming = true,\
\9\9\9\9render_when_using_scope = true,\
\
\9\9\9\9hide_if_dead = true,\
\9\9\9\9hide_if_full_health = false,\
\9\9\9\9hide_if_enemy_model_is_not_being_rendered = false,\
\9\9\9\9hide_if_player_cant_take_damage = true,\
\9\9\9\9hide_if_player_cant_use_items = true,\
\
\9\9\9\9hide_urias = false,\
\9\9\9\9hide_urias_drac = false,\
\9\9\9\9hide_urias_strajer = false,\
\9\9\9\9hide_bela = false,\
\9\9\9\9hide_bela_invincible = false,\
\9\9\9\9hide_cassandra = false,\
\9\9\9\9hide_cassandra_invincible = false,\
\9\9\9\9hide_daniela = false,\
\9\9\9\9hide_daniela_invincible = false,\
\9\9\9\9hide_dimitrescu_chasing = true,\
\9\9\9\9hide_dimitrescu_boss = false,\
\9\9\9\9hide_angie = false,\
\9\9\9\9hide_varcolac = true,\
\9\9\9\9hide_varcolac_alfa = false,\
\9\9\9\9hide_moreau = false,\
\9\9\9\9hide_sturm = false,\
\9\9\9\9hide_heisenberg = false,\
\9\9\9\9hide_executioner = false,\
\9\9\9\9hide_miranda = false,\
\9\9\9\9hide_miranda_in_dlc = false,\
\9\9\9},\
\
\9\9\9name_label = {\
\9\9\9\9visible = true,\
\
\9\9\9\9settings = {\
                    alignment = \"Center\",\
\9\9\9\9},\
\
\9\9\9\9offset = {\
\9\9\9\9\9x = 7,\
\9\9\9\9\9y = 21\
\9\9\9\9},\
\9\9\9\9\
\9\9\9\9color = 0xFFBCBCC5,\
\
\9\9\9\9shadow = {\
\9\9\9\9\9visible = true,\
\9\9\9\9\9offset = {\
\9\9\9\9\9\9x = 1,\
\9\9\9\9\9\9y = 1\
\9\9\9\9\9},\
\9\9\9\9\9color = 0xFF000000\
\9\9\9\9}\
            },\
\
\9\9\9health = {\
                visible = true,\
\9\9\9\9\
\9\9\9\9offset = {\
\9\9\9\9\9x = -405,\
\9\9\9\9\9y = 0\
                },\
\9\9\9\9\
\9\9\9\9value_label = {\
\9\9\9\9\9visible = true,\
\
\9\9\9\9\9settings = {\
\9\9\9\9\9\9alignment = \"Middle-Right\",\
\9\9\9\9\9},\
\
\9\9\9\9\9include = {\
\9\9\9\9\9\9current_value = true,\
\9\9\9\9\9\9max_value = true\
\9\9\9\9\9},\
\
\9\9\9\9\9offset = {\
\9\9\9\9\9\9x = 802,\
\9\9\9\9\9\9y = 21\
\9\9\9\9\9},\
\9\9\9\9\9\
\9\9\9\9\9color = 0xFFBCBCC5,\
\
\9\9\9\9\9shadow = {\
\9\9\9\9\9\9visible = true,\
\9\9\9\9\9\9offset = {\
\9\9\9\9\9\9\9x = 1,\
\9\9\9\9\9\9\9y = 1\
\9\9\9\9\9\9},\
\9\9\9\9\9\9color = 0xFF000000\
\9\9\9\9\9}\
                },\
\
\9\9\9\9percentage_label = {\
\9\9\9\9\9visible = false,\
\
\9\9\9\9\9settings = {\
\9\9\9\9\9\9alignment = \"Top-Right\",\
\9\9\9\9\9},\
\
\9\9\9\9\9offset = {\
\9\9\9\9\9\9x = 801,\
\9\9\9\9\9\9y = 39\
\9\9\9\9\9},\
\9\9\9\9\9\
\9\9\9\9\9color = 0xFFBCBCC5,\
\
\9\9\9\9\9shadow = {\
\9\9\9\9\9\9visible = true,\
\9\9\9\9\9\9offset = {\
\9\9\9\9\9\9\9x = 1,\
\9\9\9\9\9\9\9y = 1\
\9\9\9\9\9\9},\
\9\9\9\9\9\9color = 0xFF000000\
\9\9\9\9\9}\
                },\
\9\9\9\9\
\9\9\9\9bar = {\
\9\9\9\9\9visible = true,\
\
\9\9\9\9\9settings = {\
                        fill_direction = \"Left to Right\",\
\9\9\9\9\9\9inverted = false\
\9\9\9\9\9},\
\
\9\9\9\9\9offset = {\
\9\9\9\9\9\9x = 0,\
\9\9\9\9\9\9y = 0\
\9\9\9\9\9},\
\
\9\9\9\9\9size = {\
\9\9\9\9\9\9width = 810,\
\9\9\9\9\9\9height = 44\
\9\9\9\9\9},\
\
\9\9\9\9\9outline = {\
\9\9\9\9\9\9visible = true,\
\9\9\9\9\9\9thickness = 4.5,\
\9\9\9\9\9\9offset = 0,\
\9\9\9\9\9\9style = \"Inside\"\
\9\9\9\9\9},\
\
                    colors = {\
\9\9\9\9\9\9foreground = 0x80A0FF71,\
\9\9\9\9\9\9background = 0x48000000,\
\9\9\9\9\9\9outline = 0x68000000\
\9\9\9\9\9}\
\9\9\9\9},\
\9\9\9},\
\9\9},\
\
\
\9\9debug = {\
\9\9\9history_size = 64\
\9\9}\
\9};\
end\
\
function this.load()\
\9local loaded_config = modules.reframework_globals.json.load_file(this.config_file_name);\
\9if loaded_config ~= nil then\
\9\9modules.log.info(\"config.json loaded successfully\");\
\9\9this.current_config = modules.utils.table.merge(this.default_config, loaded_config);\
\9else\
\9\9modules.log.error(\"Failed to load config.json\");\
\9\9this.current_config = modules.utils.table.deep_copy(this.default_config);\
\9end\
end\
\
function this.save()\
\9-- save current config to disk, replacing any existing file\
\9local success = modules.reframework_globals.json.dump_file(this.config_file_name, this.current_config);\
\9if success then\
\9\9modules.log.info(\"config.json saved successfully\");\
\9else\
\9\9modules.log.error(\"Failed to save config.json\");\
\9end\
end\
\
function this.reset()\
\9this.current_config = modules.utils.table.deep_copy(this.default_config);\
\9this.current_config.version = version;\
end\
\
function this.init_module()\
\9this.init();\
\9this.load();\
\9this.current_config.version = version;\
\
\9modules.language.update(modules.utils.table.find_index(modules.language.language_names, this.current_config.language));\
end\
\
return this;\
", '@'..".\\Health_Bars\\infrastructure\\config.lua" ) )

package.preload[ "Health_Bars.infrastructure.language" ] = assert( (loadstring or load)( "local this = {};\
\
local modules = require(\"Health_Bars.modules\");\
\
this.current_language = {};\
\
--[[\
\9EXAMPLE: \
\9unicode_glyph_ranges = {\
\9\0090x0020, 0x00FF, -- Basic Latin + Latin Supplement\
\9\0090x2000, 0x206F, -- General Punctuation\
\9\0090x3000, 0x30FF, -- CJK Symbols and Punctuations, Hiragana, Katakana\
\9\0090x31F0, 0x31FF, -- Katakana Phonetic Extensions\
\9\0090x4e00, 0x9FAF, -- CJK Ideograms\
\9\0090xFF00, 0xFFEF, -- Half-width characters\
\9\0090\
\9},\
]]\
\
this.default_language = {\
\9font_name = \"\",\
\9unicode_glyph_ranges = {0},\
\9\
\9customization_menu = {\
\9\9mod_name = \"Health Bars\";\
\
\9\9enabled = \"Enabled\",\
\9\9reset_config = \"Reset Config\",\
\
\9\9menu_font_change_disclaimer = \"Changing Language and Menu Font Size several times will cause a crash!\",\
\9\9language = \"Language\",\
\
\9\9global_modifiers = \"Global Modifiers\",\
\9\9size_modifier = \"Size Modifier\",\
\9\9scale_size_modifier_with_resolution = \"Scale Size Modifier with Resolution\",\
\9\9position_modifier = \"Position Modifier\",\
\9\9scale_position_modifier_with_resolution = \"Scale Position Modifier with Resolution\",\
\
\9\9size_scale_modifier = \"Size Scale Modifier\",\
\9\9scale_with_reframework_font_size = \"Scale with REFramework Font Size\",\
\
\9\9ui_font = \"UI Font\",\
\9\9menu_font = \"Menu Font\",\
\9\9font_notice = \"Any changes to the font require script reload!\",\
\9\9family = \"Family\",\
\9\9bold = \"Bold\",\
\9\9italic = \"Italic\",\
\
\9\9settings = \"Settings\",\
\
\9\9timer_delays = \"Timer Delays\",\
\
\9\9update_singletons_delay = \"Update Singletons (sec)\",\
\9\9update_window_size_delay = \"Update Window Size (sec)\",\
\9\9update_game_data_delay = \"Update Game Data (sec)\",\
\9\9update_player_data_delay = \"Update Player Data (sec)\",\
\9\9update_enemy_data_delay = \"Update Enemy Data (sec)\",\
\
\9\9use_d2d_renderer_if_available = \"Use Direct2D Renderer if Available\",\
\
\9\9render_during_cutscenes = \"Render during Cutscenes\",\
\9\9render_when_game_timer_is_paused = \"Render when Game Timer is Paused\",\
\9\9render_in_mercenaries = \"Render in Mercenaries\",\
\9\9render_in_house_benevientos_basement = \"Render in House Beneviento's Basement\",\
\
\9\9render_aim_target_enemy = \"Render Aim Target Enemy\",\
\9\9render_damaged_enemies = \"Render Damaged Enemies\",\
\9\9render_everyone_else = \"Render Everyone Else\",\
\9\9\
\9\9render_when_normal = \"Render when Normal\",\
\9\9render_when_aiming = \"Render when Aiming\",\
\9\9render_when_using_scope = \"Render when using Scope\",\
\
\9\9hide_if_dead = \"Hide if Dead\",\
\9\9hide_if_full_health = \"Hide if Full Health\",\
\9\9hide_if_enemy_model_is_not_being_rendered = \"Hide if Enemy Model is not being Rendered\",\
\9\9hide_if_no_update_function_is_being_called = \"Hide if No Update Function is Being Called\",\
\9\9hide_if_player_cant_take_damage = \"Hide if Player can't take Damage\",\
\9\9hide_if_player_cant_use_items = \"Hide if Player can't use Items\",\
\
\9\9hide_leonardo = \"Hide Leonardo\",\
\9\9hide_duke = \"Hide Duke\",\
\
\9\9hide_blue_bird = \"Hide Blue Bird\",\
\9\9hide_pigs = \"Hide Pigs\",\
\9\9hide_chickens = \"Hide Chickens\",\
\9\9hide_goats = \"Hide Goats\",\
\9\9hide_fish = \"Hide Fish\",\
\9\9hide_catfish = \"Hide Catfish\",\
\9\9\
\9\9hide_rose_copies = \"Hide Rose Copies\",\
\9\9hide_masked_duke = \"Hide Masked Duke\",\
\9\9hide_mia_dolls = \"Hide Mia Dolls\",\
\9\9hide_dolls = \"Hide Dolls\",\
\9\9hide_rose_illusion = \"Hide Rose Illusion\",\
\9\9hide_miranda_crows = \"Hide Miranda Crows\",\
\9\9hide_ethan_in_dlc = \"Hide Ethan in DLC\",\
\
\9\9hide_urias = \"Hide Uriaș\",\
\9\9hide_urias_drac = \"Hide Uriaș Drac\",\
\9\9hide_urias_strajer = \"Hide Uriaș Străjer\",\
\9\9hide_bela = \"Hide Bela\",\
\9\9hide_bela_invincible = \"Hide Bela (Invincible)\",\
\9\9hide_cassandra = \"Hide Cassandra\",\
\9\9hide_cassandra_invincible = \"Hide Cassandra (Invincible)\",\
\9\9hide_daniela = \"Hide Daniela\",\
\9\9hide_daniela_invincible = \"Hide Daniela (Invincible)\",\
\9\9hide_dimitrescu_chasing = \"Hide Dimitrescu (Chasing)\",\
\9\9hide_dimitrescu_boss = \"Hide Dimitrescu (Boss)\",\
\9\9hide_angie = \"Hide Angie\",\
\9\9hide_varcolac = \"Hide Vârcolac\",\
\9\9hide_varcolac_alfa = \"Hide Vârcolac Alfa\",\
\9\9hide_moreau = \"Hide Moreau\",\
\9\9hide_sturm = \"Hide Sturm\",\
\9\9hide_heisenberg = \"Hide Heisenberg\",\
\9\9hide_executioner = \"Hide Executioner\",\
\9\9hide_miranda = \"Hide Miranda\",\
\9\9hide_miranda_in_dlc = \"Hide Miranda in DLC\",\
\
\9\9opacity_falloff = \"Opacity Falloff\",\
\9\9max_distance = \"Max Distance\",\
\9\9opacity_Falloff_scope = \"Opacity Falloff (Scope)\",\
\9\9max_distance_scope = \"Max Distance (Scope)\",\
\
\9\9apply_time_duration_on_aiming = \"Apply Time Duration on Aiming\",\
\9\9apply_time_duration_on_aim_target = \"Apply Time Duration on Aim Target\",\
\9\9apply_time_duration_on_using_scope = \"Apply Time Duration on using Scope\",\
\9\9apply_time_duration_on_damage_dealt = \"Apply Time Duration on Damage Dealt\",\
\9\9reset_time_duration_on_aim_target_for_everyone = \"Reset Time Duration on Aim Target for Everyone\",\
\9\9reset_time_duration_on_damage_dealt_for_everyone = \"Reset Time Duration on Damage Dealt for Everyone\",\
\9\9time_duration = \"Time Duration (sec)\",\
\
\9\9dynamic_ui = \"Dynamic UI\",\
\9\9boss_ui = \"Boss UI\",\
\
\9\9world_offset = \"World Offset\",\
\9\9x = \"X\",\
\9\9y = \"Y\",\
\9\9z = \"Z\",\
\
\9\9position = \"Position\",\
        anchor = \"Anchor\",\
\9\9spacing = \"Spacing\",\
\9\9\
\9\9alignment = \"Alignment\",\
\9\9top_left = \"Top-Left\",\
\9\9top_middle = \"Top-Middle\",\
\9\9top_right = \"Top-Right\",\
\9\9middle_left = \"Middle-Left\",\
\9\9middle_right = \"Middle-Right\",\
\9\9bottom_left = \"Bottom-Left\",\
\9\9bottom_middle = \"Bottom-Middle\",\
\9\9bottom_right = \"Bottom-Right\",\
\
\9\9name_label = \"Name Label\",\
\
\9\9health = \"Health\",\
\9\9value_label = \"Value Label\",\
\9\9percentage_label = \"Percentage Label\",\
\9\9bar = \"Bar\",\
\
\9\9visible = \"Visible\",\
\
\9\9include = \"Include\",\
\9\9current_value = \"Current Value\",\
\9\9max_value = \"Max Value\",\
\9\9\
\9\9offset = \"Offset\",\
\9\9color = \"Color\",\
\9\9shadow = \"Shadow\",\
\
\9\9fill_direction = \"Fill Direction\",\
\9\9left_to_right = \"Left to Right\",\
\9\9right_to_left = \"Right to Left\",\
\9\9top_to_bottom = \"Top to Bottom\",\
\9\9bottom_to_top = \"Bottom to Top\",\
\
\9\9inverted = \"Inverted\",\
\
\9\9size = \"Size\",\
\9\9width = \"Width\",\
\9\9height = \"Height\",\
\
\9\9outline = \"Outline\",\
\9\9thickness = \"Thickness\",\
\9\9style = \"Style\",\
\9\9inside = \"Inside\",\
\9\9center = \"Center\",\
\9\9outside = \"Outside\",\
\
\9\9colors = \"Colors\",\
\9\9foreground = \"Foreground\",\
\9\9background = \"Background\",\
\
\9\9debug = \"Debug\",\
\9\9current_time = \"Current Time\",\
\9\9everything_seems_to_be_ok = \"Everything seems to be OK!\",\
\9\9history = \"History\",\
\9\9history_size = \"History Size\",\
\9},\
\
\9ui = {\
\9\9urias = \"Uriaș\",\
\9\9urias_drac = \"Uriaș Drac\",\
\9\9urias_strajer = \"Uriaș Străjer\",\
\9\9bela = \"Bela\",\
\9\9cassandra = \"Cassandra\",\
\9\9daniela = \"Daniela\",\
\9\9dimitrescu = \"Dimitrescu\",\
\9\9angie = \"Angie\",\
\9\9varcolac = \"Vârcolac\",\
\9\9varcolac_alfa = \"Vârcolac Alfa\",\
\9\9moreau = \"Moreau\",\
\9\9sturm = \"Sturm\",\
\9\9heisenberg = \"Heisenberg\",\
\9\9executioner = \"Executioner\",\
\9\9miranda = \"Miranda\",\
\9}\
};\
\
this.language_folder = tostring(this.default_language.customization_menu.mod_name) .. \"\\\\languages\\\\\";\
this.mod_name_underscore = this.default_language.customization_menu.mod_name:gsub(\" \", \"_\");\
this.language_names = { \"default\" };\
this.languages = { this.default_language };\
\
function this.load()\
\9local language_files = modules.reframework_globals.fs.glob([[Health Bars\\\\languages\\\\.*json]]);\
\
\9if language_files == nil then\
\9\9return;\
\9end\
\
\9for i, language_file_name in ipairs(language_files) do\
\
\9\9local language_name = language_file_name:gsub(this.language_folder, \"\"):gsub(\".json\",\"\");\
\
\9\9local loaded_language = modules.reframework_globals.json.load_file(language_file_name);\
\9\9if loaded_language ~= nil then\
\
\9\9\9modules.log.info(tostring(language_file_name) .. \".json loaded successfully\");\
\9\9\9table.insert(this.language_names, language_name);\
\
\9\9\9local merged_language = modules.utils.table.merge(this.default_language, loaded_language);\
\9\9\9table.insert(this.languages, merged_language);\
\
\9\9\9this.save(language_file_name, merged_language);\
\9\9else\
\9\9\9modules.log.error(\"Failed to load \" .. tostring(language_file_name) .. \".json\");\
\9\9end\
\9end\
end\
\
function this.save(file_name, language_table)\
\9local success = modules.reframework_globals.json.dump_file(file_name, language_table);\
\9if success then\
\9\9modules.log.info(tostring(file_name) .. \" saved successfully\");\
\9else\
\9\9modules.log.error(\"Failed to saved \" .. tostring(file_name));\
\9end\
end\
\
function this.save_default()\
\9this.save(this.language_folder .. \"en-us.json\", this.default_language);\
end\
\
function this.update(index)\
\9this.current_language = this.languages[index];\
end\
\
function this.init_module()\
\9this.save_default();\
\9this.load();\
\9this.current_language = this.default_language;\
end\
\
return this;\
", '@'..".\\Health_Bars\\infrastructure\\language.lua" ) )

package.preload[ "Health_Bars.label_customization" ] = assert( (loadstring or load)( "local this = {};\
\
local utils;\
local config;\
local language;\
local screen;\
local customization_menu;\
\
local sdk = sdk;\
local tostring = tostring;\
local pairs = pairs;\
local ipairs = ipairs;\
local tonumber = tonumber;\
local require = require;\
local pcall = pcall;\
local table = table;\
local string = string;\
local Vector3f = Vector3f;\
local d2d = d2d;\
local math = math;\
local json = json;\
local log = log;\
local fs = fs;\
local next = next;\
local type = type;\
local setmetatable = setmetatable;\
local getmetatable = getmetatable;\
local assert = assert;\
local select = select;\
local coroutine = coroutine;\
local utf8 = utf8;\
local re = re;\
local imgui = imgui;\
local draw = draw;\
local Vector2f = Vector2f;\
local reframework = reframework;\
local os = os;\
\
local include_names = {};\
\
function this.init()\
\9local cached_current_language = language.current_language.customization_menu;\
\
\9include_names = {\
\9\9[\"current_value\"] = cached_current_language.current_value,\
\9\9[\"max_value\"] = cached_current_language.max_value\
\9};\
end\
\
function this.draw(label_name, label)\
\9local cached_language = language.current_language.customization_menu;\
\
\9local label_changed = false;\
\9local changed = false;\
\
\9if imgui.tree_node(label_name) then\
\9\9changed, label.visibility = imgui.checkbox(cached_language.visible, label.visibility);\
\9\9label_changed = label_changed or changed;\
\
\9\9if imgui.tree_node(cached_language.settings) then\
\9\9\9changed, label.settings.right_alignment_shift =imgui.slider_int(cached_language.right_alignment_shift, label.settings.right_alignment_shift, 0, 32);\
\9\9\9label_changed = label_changed or changed;\
\
\9\9\9imgui.tree_pop();\
\9\9end\
\
\
\9\9if label.include ~= nil then\
\9\9\9if imgui.tree_node(cached_language.include) then\
\9\9\9\9for include_name, include in pairs(label.include) do\
\9\9\9\9\9changed, label.include[include_name] = imgui.checkbox(include_names[include_name], include);\
\9\9\9\9\9label_changed = label_changed or changed;\
\9\9\9\9end\
\
\9\9\9\9imgui.tree_pop();\
\9\9\9end\
\9\9end\
\9\9\
\9\9-- add text format\
\
\9\9if imgui.tree_node(cached_language.offset) then\
\9\9\9changed, label.offset.x = imgui.drag_float(cached_language.x, label.offset.x, 0.1, -screen.width, screen.width, \"%.1f\");\
\9\9\9label_changed = label_changed or changed;\
\
\9\9\9changed, label.offset.y = imgui.drag_float(cached_language.y, label.offset.y, 0.1, -screen.height, screen.height, \"%.1f\");\
\9\9\9label_changed = label_changed or changed;\
\
\9\9\9imgui.tree_pop();\
\9\9end\
\
\9\9if imgui.tree_node(cached_language.color) then\
\9\9\9changed, label.color = imgui.color_picker_argb(\"\", label.color, customization_menu.color_picker_flags);\
\9\9\9label_changed = label_changed or changed;\
\
\9\9\9imgui.tree_pop();\
\9\9end\
\
\9\9if imgui.tree_node(cached_language.shadow) then\
\9\9\9changed, label.shadow.visibility = imgui.checkbox(cached_language.visible, label.shadow.visibility);\
\9\9\9label_changed = label_changed or changed;\
\
\9\9\9if imgui.tree_node(cached_language.offset) then\
\9\9\9\9changed, label.shadow.offset.x = imgui.drag_float(cached_language.x,\
\9\9\9\9\9label.shadow.offset.x, 0.1, -screen.width, screen.width, \"%.1f\");\
\9\9\9\9label_changed = label_changed or changed;\
\
\9\9\9\9changed, label.shadow.offset.y = imgui.drag_float(cached_language.y,\
\9\9\9\9\9label.shadow.offset.y, 0.1, -screen.height, screen.height, \"%.1f\");\
\9\9\9\9label_changed = label_changed or changed;\
\
\9\9\9\9imgui.tree_pop();\
\9\9\9end\
\
\9\9\9if imgui.tree_node(cached_language.color) then\
\9\9\9\9changed, label.shadow.color = imgui.color_picker_argb(\"\", label.shadow.color, customization_menu.color_picker_flags);\
\9\9\9\9label_changed = label_changed or changed;\
\
\9\9\9\9imgui.tree_pop();\
\9\9\9end\
\
\9\9\9imgui.tree_pop();\
\9\9end\
\
\9\9imgui.tree_pop();\
\9end\
\
\9return label_changed;\
end\
\
function this.init_module()\
\9utils = require(\"Health_Bars.utils\");\
\9config = require(\"Health_Bars.config\");\
\9language = require(\"Health_Bars.language\");\
\9screen = require(\"Health_Bars.screen\");\
\9customization_menu = require(\"Health_Bars.customization_menu\");\
end\
\
return this;", '@'..".\\Health_Bars\\label_customization.lua" ) )

package.preload[ "Health_Bars.language" ] = assert( (loadstring or load)( "local this = {};\
\
local utils;\
\
local sdk = sdk;\
local tostring = tostring;\
local pairs = pairs;\
local ipairs = ipairs;\
local tonumber = tonumber;\
local require = require;\
local pcall = pcall;\
local table = table;\
local string = string;\
local Vector3f = Vector3f;\
local d2d = d2d;\
local math = math;\
local json = json;\
local log = log;\
local fs = fs;\
local next = next;\
local type = type;\
local setmetatable = setmetatable;\
local getmetatable = getmetatable;\
local assert = assert;\
local select = select;\
local coroutine = coroutine;\
local utf8 = utf8;\
local re = re;\
local imgui = imgui;\
local draw = draw;\
local Vector2f = Vector2f;\
local reframework = reframework;\
local os = os;\
local ValueType = ValueType;\
local package = package;\
\
this.language_folder = \"Health Bars\\\\languages\\\\\";\
\
this.current_language = {};\
\
--[[\
\9EXAMPLE: \
\9unicode_glyph_ranges = {\
\9\0090x0020, 0x00FF, -- Basic Latin + Latin Supplement\
\9\0090x2000, 0x206F, -- General Punctuation\
\9\0090x3000, 0x30FF, -- CJK Symbols and Punctuations, Hiragana, Katakana\
\9\0090x31F0, 0x31FF, -- Katakana Phonetic Extensions\
\9\0090x4e00, 0x9FAF, -- CJK Ideograms\
\9\0090xFF00, 0xFFEF, -- Half-width characters\
\9\0090\
\9},\
]]\
\
this.default_language = {\
\9font_name = \"\",\
\9unicode_glyph_ranges = {0},\
\9\
\9customization_menu = {\
\9\9mod_name = \"Health Bars\";\
\
\9\9enabled = \"Enabled\",\
\9\9reset_config = \"Reset Config\",\
\9\9status = \"Status\",\
\
\9\9menu_font_change_disclaimer = \"Changing Language and Menu Font Size several times will cause a crash!\",\
\9\9language = \"Language\",\
\9\9apply = \"Apply\",\
\
\9\9ui_font = \"UI Font\",\
\9\9menu_font = \"Menu Font\",\
\9\9font_notice = \"Any changes to the font require script reload!\",\
\9\9family = \"Family\",\
\9\9size = \"Size\",\
\9\9bold = \"Bold\",\
\9\9italic = \"Italic\",\
\
\9\9settings = \"Settings\",\
\9\9use_d2d_renderer_if_available = \"Use Direct2D Renderer if Available\",\
\
\9\9render_during_cutscenes = \"Render during Cutscenes\",\
\9\9render_when_game_timer_is_paused = \"Render when Game Timer is Paused\",\
\9\9render_in_mercenaries = \"Render in Mercenaries\",\
\
\9\9render_aim_target_enemy = \"Render Aim Target Enemy\",\
\9\9render_damaged_enemies = \"Render Damaged Enemies\",\
\9\9render_everyone_else = \"Render Everyone Else\",\
\9\9\
\9\9render_when_normal = \"Render when Normal\",\
\9\9render_when_aiming = \"Render when Aiming\",\
\9\9render_when_using_scope = \"Render when using Scope\",\
\
\9\9hide_if_dead = \"Hide if Dead\",\
\9\9hide_if_full_health = \"Hide if Full Health\",\
\9\9hide_if_enemy_model_is_not_being_rendered = \"Hide if Enemy Model is not being Rendered\",\
\9\9hide_if_no_update_function_is_being_called = \"Hide if No Update Function is Being Called\",\
\
\9\9hide_leonardo = \"Hide Leonardo\",\
\9\9hide_duke = \"Hide Duke\",\
\
\9\9hide_blue_bird = \"Hide Blue Bird\",\
\9\9hide_pigs = \"Hide Pigs\",\
\9\9hide_chickens = \"Hide Chickens\",\
\9\9hide_goats = \"Hide Goats\",\
\9\9hide_fish = \"Hide Fish\",\
\9\9hide_catfish = \"Hide Catfish\",\
\9\9\
\9\9hide_rose_copies = \"Hide Rose Copies\",\
\9\9hide_masked_duke = \"Hide Masked Duke\",\
\9\9hide_mia_dolls = \"Hide Mia Dolls\",\
\9\9hide_dolls = \"Hide Dolls\",\
\9\9hide_rose_illusion = \"Hide Rose Illusion\",\
\9\9hide_miranda_crows = \"Hide Miranda Crows\",\
\9\9hide_ethan_in_dlc = \"Hide Ethan in DLC\",\
\
\9\9opacity_falloff = \"Opacity Falloff\",\
\9\9max_distance = \"Max Distance\",\
\9\9opacity_Falloff_scope = \"Opacity Falloff (Scope)\",\
\9\9max_distance_scope = \"Max Distance (Scope)\",\
\
\9\9apply_time_duration_on_aiming = \"Apply Time Duration on Aiming\",\
\9\9apply_time_duration_on_aim_target = \"Apply Time Duration on Aim Target\",\
\9\9apply_time_duration_on_using_scope = \"Apply Time Duration on using Scope\",\
\9\9apply_time_duration_on_damage_dealt = \"Apply Time Duration on Damage Dealt\",\
\9\9reset_time_duration_on_aim_target_for_everyone = \"Reset Time Duration on Aim Target for Everyone\",\
\9\9reset_time_duration_on_damage_dealt_for_everyone = \"Reset Time Duration on Damage Dealt for Everyone\",\
\9\9time_duration = \"Time Duration (sec)\",\
\
\9\9world_offset = \"World Offset\",\
\9\9x = \"X\",\
\9\9y = \"Y\",\
\9\9z = \"Z\",\
\
\9\9health_value_label = \"Health Value Label\",\
\9\9health_bar = \"Health Bar\",\
\
\9\9visible = \"Visible\",\
\9\9right_alignment_shift = \"Right Alignment Shift\",\
\
\9\9include = \"Include\",\
\9\9current_value = \"Current Value\",\
\9\9max_value = \"Max Value\",\
\9\9\
\9\9offset = \"Offset\",\
\9\9color = \"Color\",\
\9\9shadow = \"Shadow\",\
\
\9\9fill_type = \"Fill Type\",\
\9\9left_to_right = \"Left to Right\",\
\9\9right_to_left = \"Right to Left\",\
\9\9top_to_bottom = \"Top to Bottom\",\
\9\9bottom_to_top = \"Bottom to Top\",\
\
\9\9width = \"Width\",\
\9\9height = \"Height\",\
\
\9\9outline = \"Outline\",\
\9\9thickness = \"Thickness\",\
\9\9style = \"Style\",\
\9\9inside = \"Inside\",\
\9\9center = \"Center\",\
\9\9outside = \"Outside\",\
\
\9\9colors = \"Colors\",\
\9\9foreground = \"Foreground\",\
\9\9background = \"Background\",\
\
\9\9timer_delays = \"Timer Delays\",\
\
\9\9update_singletons_delay = \"Update Singletons (sec)\",\
\9\9update_window_size_delay = \"Update Window Size (sec)\",\
\9\9update_game_data_delay = \"Update Game Data (sec)\",\
\9\9update_player_data_delay = \"Update Player Data (sec)\",\
\9\9update_enemy_data_delay = \"Update Enemy Data (sec)\",\
\
\9\9debug = \"Debug\",\
\9\9current_time = \"Current Time\",\
\9\9everything_seems_to_be_ok = \"Everything seems to be OK!\",\
\9\9history = \"History\",\
\9\9history_size = \"History Size\",\
\9}\
};\
\
this.language_names = { \"default\" };\
this.languages = { this.default_language };\
\
function this.load()\
\9local language_files = fs.glob([[Health Bars\\\\languages\\\\.*json]]);\
\
\9if language_files == nil then\
\9\9return;\
\9end\
\
\9for i, language_file_name in ipairs(language_files) do\
\
\9\9local language_name = language_file_name:gsub(this.language_folder, \"\"):gsub(\".json\",\"\");\
\
\9\9local loaded_language = json.load_file(language_file_name);\
\9\9if loaded_language ~= nil then\
\
\9\9\9log.info(\"[Health Bars] \" .. language_file_name .. \".json loaded successfully\");\
\9\9\9table.insert(this.language_names, language_name);\
\
\9\9\9local merged_language = utils.table.merge(this.default_language, loaded_language);\
\9\9\9table.insert(this.languages, merged_language);\
\
\9\9\9this.save(language_file_name, merged_language);\
\9\9else\
\9\9\9log.error(\"[Health Bars] Failed to load \" .. language_file_name .. \".json\");\
\9\9end\
\9end\
end\
\
function this.save(file_name, language_table)\
\9local success = json.dump_file(file_name, language_table);\
\9if success then\
\9\9log.info(\"[Health Bars] \" .. file_name .. \" saved successfully\");\
\9else\
\9\9log.error(\"[Health Bars] Failed to save \" .. file_name);\
\9end\
end\
\
function this.save_default()\
\9this.save(this.language_folder .. \"en-us.json\", this.default_language);\
end\
\
function this.update(index)\
\9this.current_language = this.languages[index];\
end\
\
function this.init_module()\
\9utils = require(\"Health_Bars.utils\");\
\9\
\9this.save_default();\
\9this.load();\
\9this.current_language = this.default_language;\
end\
\
return this;\
", '@'..".\\Health_Bars\\language.lua" ) )

package.preload[ "Health_Bars.modules" ] = assert( (loadstring or load)( "---@diagnostic disable: undefined-global\
\
local this = {\
    lua_version = _VERSION,\
\9globals = _G,\
\9reframework_globals = {\
\9\9d2d = d2d,\
\9\9draw = draw,\
\9\9fs = fs,\
\9\9imgui = imgui,\
\9\9json = json,\
\9\9log = log,\
\9\9re = re,\
\9\9reframework = reframework,\
\9\9sdk = sdk,\
\9\9Vector2f = Vector2f,\
\9\9Vector3f = Vector3f,\
    },\
\9enemy_handler = {},\
    game_handler = {},\
    player_handler = {},\
\
    bar_customization = {},\
    color_customization = {},\
\9customization_menu = {},\
\9label_customization = {},\
\9offset_customization = {},\
\9position_customization = {},\
\9spacing_customization = {},\
\9world_offset_customization = {},\
\
\9drawing = {},\
\9error_handler = {},\
\9log = {},\
\9screen = {},\
    singletons = {},\
\9throttle = {},\
\9time = {},\
\9utils = {},\
\
\9config = {},\
    language = {},\
\9\
    bar = {},\
\9label = {},\
\9percentage_label = {},\
    value_label = {},\
    health_widget = {},\
\9dynamic_ui = {},\
\9boss_ui = {},\
\9ui = {},\
};\
\
function this.init_module()\
\9this.enemy_handler = require(\"Health_Bars.core.enemy_handler\");\
    this.game_handler = require(\"Health_Bars.core.game_handler\");\
    this.player_handler = require(\"Health_Bars.core.player_handler\");\
\
    this.bar_customization = require(\"Health_Bars.customization.customizations.bar_customization\");\
\9this.color_customization = require(\"Health_Bars.customization.customizations.color_customization\");\
    this.label_customization = require(\"Health_Bars.customization.customizations.label_customization\");\
    this.offset_customization = require(\"Health_Bars.customization.customizations.offset_customization\");\
    this.position_customization = require(\"Health_Bars.customization.customizations.position_customization\");\
\9this.spacing_customization = require(\"Health_Bars.customization.customizations.spacing_customization\");\
\9this.world_offset_customization = require(\"Health_Bars.customization.customizations.world_offset_customization\");\
\9this.customization_menu = require(\"Health_Bars.customization.customization_menu\");\
\
\9this.drawing = require(\"Health_Bars.helpers.drawing\");\
    this.error_handler = require(\"Health_Bars.helpers.error_handler\");\
\9this.log = require(\"Health_Bars.helpers.log\");\
\9this.screen = require(\"Health_Bars.helpers.screen\");\
    this.singletons = require(\"Health_Bars.helpers.singletons\");\
\9this.throttle = require(\"Health_Bars.helpers.throttle\");\
\9this.time = require(\"Health_Bars.helpers.time\");\
\9this.utils = require(\"Health_Bars.helpers.utils\");\
\
\9this.language = require(\"Health_Bars.infrastructure.language\");\
\9this.config = require(\"Health_Bars.infrastructure.config\");\
\9\
\9this.bar = require(\"Health_Bars.ui.0_elements.bar\");\
\9this.label = require(\"Health_Bars.ui.0_elements.label\");\
\9this.percentage_label = require(\"Health_Bars.ui.1_components.percentage_label\");\
\9this.value_label = require(\"Health_Bars.ui.1_components.value_label\");\
\9this.health_widget = require(\"Health_Bars.ui.2_widgets.health_widget\");\
\9this.dynamic_ui = require(\"Health_Bars.ui.3_uis.dynamic_ui\");\
\9this.boss_ui = require(\"Health_Bars.ui.3_uis.boss_ui\");\
\9this.ui = require(\"Health_Bars.ui.ui\");\
end\
\
return this;", '@'..".\\Health_Bars\\modules.lua" ) )

package.preload[ "Health_Bars.player_handler" ] = assert( (loadstring or load)( "local this = {};\
\
local utils;\
local singletons;\
local config;\
local customization_menu;\
local enemy_handler;\
local time;\
local error_handler;\
\
local sdk = sdk;\
local tostring = tostring;\
local pairs = pairs;\
local ipairs = ipairs;\
local tonumber = tonumber;\
local require = require;\
local pcall = pcall;\
local table = table;\
local string = string;\
local Vector3f = Vector3f;\
local d2d = d2d;\
local math = math;\
local json = json;\
local log = log;\
local fs = fs;\
local next = next;\
local type = type;\
local setmetatable = setmetatable;\
local getmetatable = getmetatable;\
local assert = assert;\
local select = select;\
local coroutine = coroutine;\
local utf8 = utf8;\
local re = re;\
local imgui = imgui;\
local draw = draw;\
local Vector2f = Vector2f;\
local reframework = reframework;\
local os = os;\
\
this.player = {};\
this.player.position = Vector3f.new(0, 0, 0);\
this.player.is_aiming = false;\
this.player.is_using_scope = false;\
this.player.aim_target_owner = nil;\
\
local enemy_manager_type_def = sdk.find_type_definition(\"app.EnemyManager\");\
local get_aim_target_enemy_method = enemy_manager_type_def:get_method(\"get_aimTargetEnemy\");\
\
local weapon_gun_core_type_def = sdk.find_type_definition(\"app.WeaponGunCore\");\
local on_aim_start_method = weapon_gun_core_type_def:get_method(\"onAimStart\");\
local on_aim_end_method = weapon_gun_core_type_def:get_method(\"onAimEnd\");\
local update_scope_method = weapon_gun_core_type_def:get_method(\"updateScope\");\
\
local player_core_base_type_def = sdk.find_type_definition(\"app.PlayerCoreBase\");\
local update_method = player_core_base_type_def:get_method(\"update\");\
\
local props_manager_type_def = sdk.find_type_definition(\"app.PropsManager\");\
local get_player_method = props_manager_type_def:get_method(\"get_Player\");\
\
local game_object_type_def = sdk.find_type_definition(\"via.GameObject\");\
local get_transform_method = game_object_type_def:get_method(\"get_Transform\");\
\
local transform_type_def = get_transform_method:get_return_type();\
local get_position_method = transform_type_def:get_method(\"get_Position\");\
\
local cast_result_type_def = sdk.find_type_definition(\"app.CollisionManager.CastResult\");\
local game_object_field = cast_result_type_def:get_field(\"GameObject\");\
\
function this.update_position()\
\9if singletons.props_manager == nil then\
\9\9error_handler.report(\"player.update_position\", \"No PropsManager\");\
\9\9return;\
\9end\
\
\9local player = get_player_method:call(singletons.props_manager);\
\9if player == nil then\
\9\9error_handler.report(\"player.update_position\", \"No Player\");\
\9\9return;\
\9end\
\
\9local player_transform = get_transform_method:call(player);\
\
\9if player_transform == nil then\
\9\9error_handler.report(\"player.update_position\", \"No Transform\");\
\9\9return;\
\9end\
\
\9local position = get_position_method:call(player_transform);\
\9if position == nil then\
\9\9error_handler.report(\"player.update_position\", \"No Position\");\
\9\9return;\
\9end\
\
\9this.player.position = position;\
end\
\
function this.update_aim_target()\
\9local cached_config = config.current_config.settings;\
\
\9local enemy_manager = singletons.enemy_manager;\
\
\9if enemy_manager == nil then\
\9\9error_handler.report(\"player.update_aim_target\", \"No EnemyManager\");\
\9\9return;\
\9end\
\
\9local aim_target_game_object = get_aim_target_enemy_method:call(enemy_manager);\
\
\9if aim_target_game_object == nil then\
\9\9this.player.aim_target_owner = nil;\
\9\9return;\
\9end\
\
\9this.player.aim_target_owner = aim_target_game_object;\
\
\9if cached_config.reset_time_duration_on_aim_target_for_everyone then\
\9\9for enemy_core, enemy in pairs(enemy_handler.enemy_list) do\
\9\9\9if time.total_elapsed_script_seconds - enemy.last_reset_time < cached_config.time_duration then\
\9\9\9\9enemy_handler.update_last_reset_time(enemy);\
\9\9\9end\
\
\9\9end\
\9end\
\9\
\9if cached_config.apply_time_duration_on_aim_target then\
\9\9enemy_handler.update_last_reset_time(enemy_handler.enemy_owner_list[aim_target_game_object]);\
\9end\
end\
\
function this.update()\
\9this.update_aim_target();\
end\
\
function this.on_aim_start(weapon_gun_core)\
\9local cached_config = config.current_config.settings;\
\
\9this.player.is_aiming = true;\
\9this.player.is_using_scope = false;\
\
\9if cached_config.apply_time_duration_on_aiming then\
\9\9for enemy_core, enemy in pairs(enemy_handler.enemy_list) do\
\9\9\9enemy_handler.update_last_reset_time(enemy);\
\9\9end\
\9end\
end\
\
function this.on_aim_end(weapon_gun_core)\
\9this.player.is_aiming = false;\
\9this.player.is_using_scope = false;\
end\
\
function this.on_update_scope(weapon_gun_core)\
\9local cached_config = config.current_config.settings;\
\
\9this.player.is_using_scope = true;\
\
\9if cached_config.apply_time_duration_on_using_scope then\
\9\9for enemy_core, enemy in pairs(enemy_handler.enemy_list) do\
\9\9\9enemy_handler.update_last_reset_time(enemy);\
\9\9end\
\9end\
end\
\
function this.init_module()\
\9utils = require(\"Health_Bars.utils\");\
\9config = require(\"Health_Bars.config\");\
\9singletons = require(\"Health_Bars.singletons\");\
\9customization_menu = require(\"Health_Bars.customization_menu\");\
\9enemy_handler = require(\"Health_Bars.enemy_handler\");\
\9time = require(\"Health_Bars.time\");\
\9error_handler = require(\"Health_Bars.error_handler\");\
\
\9sdk.hook(on_aim_start_method, function(args)\
\
\9\9local weapon_gun_core = sdk.to_managed_object(args[2]);\
\9\9this.on_aim_start(weapon_gun_core)\
\
\9end, function(retval)\
\9\9return retval;\
\9end);\
\
\9sdk.hook(on_aim_end_method, function(args)\
\
\9\9local weapon_gun_core = sdk.to_managed_object(args[2]);\
\9\9this.on_aim_end(weapon_gun_core)\
\
\9end, function(retval)\
\9\9return retval;\
\9end);\
\
\9sdk.hook(update_scope_method, function(args)\
\
\9\9local weapon_gun_core = sdk.to_managed_object(args[2]);\
\9\9this.on_update_scope(weapon_gun_core)\
\
\9end, function(retval)\
\9\9return retval;\
\9end);\
end\
\
return this;", '@'..".\\Health_Bars\\player_handler.lua" ) )

package.preload[ "Health_Bars.screen" ] = assert( (loadstring or load)( "local this = {};\
\
local config;\
local singletons;\
local utils;\
\
local sdk = sdk;\
local tostring = tostring;\
local pairs = pairs;\
local ipairs = ipairs;\
local tonumber = tonumber;\
local require = require;\
local pcall = pcall;\
local table = table;\
local string = string;\
local Vector3f = Vector3f;\
local d2d = d2d;\
local math = math;\
local json = json;\
local log = log;\
local fs = fs;\
local next = next;\
local type = type;\
local setmetatable = setmetatable;\
local getmetatable = getmetatable;\
local assert = assert;\
local select = select;\
local coroutine = coroutine;\
local utf8 = utf8;\
local re = re;\
local imgui = imgui;\
local draw = draw;\
local Vector2f = Vector2f;\
local reframework = reframework;\
local os = os;\
\
this.width = 1920;\
this.height = 1080;\
\
local scene_view;\
local scene_view_type = sdk.find_type_definition(\"via.SceneView\");\
local get_size_method = scene_view_type:get_method(\"get_Size\");\
\
local size_type = get_size_method:get_return_type();\
local width_field = size_type:get_field(\"w\");\
local height_field = size_type:get_field(\"h\");\
\
function this.update_window_size()\
\9local width;\
\9local height;\
\
\9--if d2d ~= nil and config.current_config.settings.use_d2d_if_available then\
\9--\9local success, d2d_width, d2d_height = pcall(d2d.surface_size);\
\9--\9if success then\
\9--\9\9width = d2d_width;\
\9--\9\9height = d2d_height;\
\9--\9else\
\9--\9\9width, height = this.get_game_window_size();\
\9--\9end\
\9--else\
\9--\9width, height = this.get_game_window_size();\
\9--end\
\
\9width, height = this.get_game_window_size();\
\
\9if width ~= nil then\
\9\9this.width = width;\
\9end\
\
\9if height ~= nil then\
\9\9this.height = height;\
\9end\
end\
\
function this.get_game_window_size()\
\9if scene_view == nil then\
\9\9if singletons.scene_manager == nil then\
\9\9\9return;\
\9\9end\
\
\9\9scene_view = sdk.call_native_func(singletons.scene_manager, sdk.find_type_definition(\"via.SceneManager\"), \"get_MainView\");\
\
\9\9if scene_view == nil then\
\9\9\9return;\
\9\9end\
\9end\
\
\9local size = get_size_method:call(scene_view);\
\9if size == nil then\
\9\9return;\
\9end\
\
\9local screen_width = width_field:get_data(size);\
\9if screen_width == nil then\
\9\9return;\
\9end\
\
\9local screen_height = height_field:get_data(size);\
\9if screen_height == nil then\
\9\9return;\
\9end\
\
\9return screen_width, screen_height;\
end\
\
function this.init_module()\
\9config = require(\"Health_Bars.config\");\
\9singletons = require(\"Health_Bars.singletons\");\
\9utils = require(\"Health_Bars.utils\");\
end\
\
return this;\
", '@'..".\\Health_Bars\\screen.lua" ) )

package.preload[ "Health_Bars.singletons" ] = assert( (loadstring or load)( "local this = {};\
\
local customization_menu;\
local error_handler;\
\
local sdk = sdk;\
local tostring = tostring;\
local pairs = pairs;\
local ipairs = ipairs;\
local tonumber = tonumber;\
local require = require;\
local pcall = pcall;\
local table = table;\
local string = string;\
local Vector3f = Vector3f;\
local d2d = d2d;\
local math = math;\
local json = json;\
local log = log;\
local fs = fs;\
local next = next;\
local type = type;\
local setmetatable = setmetatable;\
local getmetatable = getmetatable;\
local assert = assert;\
local select = select;\
local coroutine = coroutine;\
local utf8 = utf8;\
local re = re;\
local imgui = imgui;\
local draw = draw;\
local Vector2f = Vector2f;\
local reframework = reframework;\
local os = os;\
\
local enemy_manager_name = \"app.EnemyManager\";\
local content_timer_name = \"app.ContentTimer\";\
local event_system_app_name = \"app.EventSystemApp\";\
local props_manager_name = \"app.PropsManager\";\
local rogue_enemy_health_holder_name = \"app.RogueEnemyHealthHolder\";\
\
this.enemy_manager = nil;\
this.content_timer = nil;\
this.event_system_app = nil;\
this.props_manager = nil;\
this.rogue_enemy_health_holder = nil;\
\
function this.update()\
\9this.update_enemy_manager();\
\9this.update_content_timer();\
\9this.update_event_system_app();\
\9this.update_props_manager();\
\9this.update_rogue_enemy_health_holder();\
end\
\
function this.update_enemy_manager()\
\9this.enemy_manager = sdk.get_managed_singleton(enemy_manager_name);\
\9if this.enemy_manager == nil then\
\9\9error_handler.report(\"singletons.update_enemy_manager\", \"No EnemyManager\");\
\9end\
\
\9return this.character_manager;\
end\
\
function this.update_content_timer()\
\9this.content_timer = sdk.get_managed_singleton(content_timer_name);\
\9if this.content_timer == nil then\
\9\9error_handler.report(\"singletons.update_content_timer\", \"No ContentTimer\");\
\9end\
\
\9return this.content_timer;\
end\
\
function this.update_event_system_app()\
\9this.event_system_app = sdk.get_managed_singleton(event_system_app_name);\
\9if this.event_system_app == nil then\
\9\9error_handler.report(\"singletons.update_event_system_app\",\"No EventSystemApp\");\
\9end\
\
\9return this.event_system_app;\
end\
\
function this.update_props_manager()\
\9this.props_manager = sdk.get_managed_singleton(props_manager_name);\
\9if this.props_manager == nil then\
\9\9error_handler.report(\"singletons.update_props_manager\", \"No Props Manager\");\
\9end\
\
\9return this.props_manager;\
end\
\
function this.update_rogue_enemy_health_holder()\
\9this.rogue_enemy_health_holder = sdk.get_managed_singleton(rogue_enemy_health_holder_name);\
\9-- if this.rogue_enemy_health_holder == nil then\
\9\9-- error_handler.report(\"singletons.update_rogue_enemy_health_holder\", \"No RogueEnemyHealthHolder\");\
\9-- end\
\
\9return this.rogue_enemy_health_holder;\
end\
\
function this.init_module()\
\9customization_menu = require(\"Health_Bars.customization_menu\");\
\9error_handler = require(\"Health_Bars.error_handler\");\
\
\9this.update();\
end\
\
return this;\
", '@'..".\\Health_Bars\\singletons.lua" ) )

package.preload[ "Health_Bars.time" ] = assert( (loadstring or load)( "local this = {};\
\
local singletons;\
local customization_menu;\
local config;\
local utils;\
local screen;\
local game_handler;\
local enemy_handler;\
local player_handler;\
\
local sdk = sdk;\
local tostring = tostring;\
local pairs = pairs;\
local ipairs = ipairs;\
local tonumber = tonumber;\
local require = require;\
local pcall = pcall;\
local table = table;\
local string = string;\
local Vector3f = Vector3f;\
local d2d = d2d;\
local math = math;\
local json = json;\
local log = log;\
local fs = fs;\
local next = next;\
local type = type;\
local setmetatable = setmetatable;\
local getmetatable = getmetatable;\
local assert = assert;\
local select = select;\
local coroutine = coroutine;\
local utf8 = utf8;\
local re = re;\
local imgui = imgui;\
local draw = draw;\
local Vector2f = Vector2f;\
local reframework = reframework;\
local os = os;\
local ValueType = ValueType;\
local package = package;\
\
this.total_elapsed_script_seconds = 0;\
\
this.timer_list = {};\
this.delay_timer_list = {};\
\
function this.new_timer(callback, cooldown_seconds, start_offset_seconds)\
\9start_offset_seconds = start_offset_seconds or utils.math.random();\
\
\9if callback == nil or cooldown_seconds == nil then\
\9\9return;\
\9end\
\
\9local timer = {};\
\9timer.callback = callback;\
\9timer.cooldown = cooldown_seconds;\
\
\9timer.last_trigger_time = os.clock() + start_offset_seconds;\
\
\9this.timer_list[callback] =  timer;\
end\
\
function this.new_delay_timer(callback, delay_seconds)\
\9if callback == nil or delay_seconds == nil then\
\9\9return;\
\9end\
\
\9local delay_timer = {};\
\9delay_timer.callback = callback;\
\9delay_timer.delay = delay_seconds;\
\9\
\9delay_timer.init_time = os.clock();\
\
\9this.delay_timer_list[callback] = delay_timer;\
\
\9return delay_timer;\
end\
\
function this.remove_delay_timer(delay_timer)\
\9if delay_timer == nil then\
\9\9return;\
\9end\
\
\9this.delay_timer_list[delay_timer.callback] = nil; \
end\
\
function this.init_global_timers()\
\9local cached_config = config.current_config.settings.timer_delays;\
\
\9this.timer_list = {};\
\
\9this.new_timer(singletons.update, cached_config.update_singletons_delay);\
\9this.new_timer(screen.update_window_size, cached_config.update_window_size_delay);\
\9this.new_timer(game_handler.update, cached_config.update_game_data_delay);\
\9this.new_timer(player_handler.update, cached_config.update_player_data_delay);\
\9this.new_timer(enemy_handler.update_all_periodics, cached_config.update_enemy_data_delay);\
end\
\
function this.update_timers()\
\9this.update_script_time();\
\
\9for callback, timer in pairs(this.timer_list) do\
\9\9if this.total_elapsed_script_seconds - timer.last_trigger_time > timer.cooldown then\
\9\9\9timer.last_trigger_time = this.total_elapsed_script_seconds;\
\9\9\9callback();\
\9\9end\
\9end\
\
\9local remove_list = {};\
\
\9for callback, delay_timer in pairs(this.delay_timer_list) do\
\9\9if this.total_elapsed_script_seconds - delay_timer.init_time > delay_timer.delay then\
\9\9\9callback();\
\9\9\9table.insert(remove_list, callback);\
\9\9end\
\9end\
\
\9for i, callback in ipairs(remove_list) do\
\9\9this.delay_timer_list[callback] = nil;\
\9end\
end\
\
function this.update_script_time()\
\9this.total_elapsed_script_seconds = os.clock();\
end\
\
function this.init_module()\
\9singletons = require(\"Health_Bars.singletons\");\
\9screen = require(\"Health_Bars.screen\");\
\9customization_menu = require(\"Health_Bars.customization_menu\");\
\9config = require(\"Health_Bars.config\");\
\9utils = require(\"Health_Bars.utils\");\
\9game_handler = require(\"Health_Bars.game_handler\");\
\9enemy_handler = require(\"Health_Bars.enemy_handler\");\
\9player_handler = require(\"Health_Bars.player_handler\");\
end\
\
return this;", '@'..".\\Health_Bars\\time.lua" ) )

package.preload[ "Health_Bars.ui.0_elements.bar" ] = assert( (loadstring or load)( "local this = {};\
\
local modules = require(\"Health_Bars.modules\");\
\
function this.draw(bar, position, opacity_scale, percentage)\
    if not bar.visible then\
        return;\
    end\
\9\
    local scaled_offset_x, scaled_offset_y = modules.utils.misc.scale_position(bar.offset.x, bar.offset.y);\
\
\9local offset_position = {\
        x = position.x + scaled_offset_x,\
        y = position.y + scaled_offset_y\
    };\
\
\9modules.drawing.draw_bar(bar, offset_position, opacity_scale, percentage);\
end\
\
\
function this.init_module()\
end\
\
return this;", '@'..".\\Health_Bars\\ui\\0_elements\\bar.lua" ) )

package.preload[ "Health_Bars.ui.0_elements.label" ] = assert( (loadstring or load)( "local this = {};\
\
local modules = require(\"Health_Bars.modules\");\
\
function this.draw(label, position, opacity_scale, use_boss_ui_font, text)\
\9if not label.visible then\
\9\9return;\
\9end\
\9\
\9modules.drawing.draw_label(label, position, opacity_scale, use_boss_ui_font, text);\
end\
\
function this.init_module()\
end\
\
return this;", '@'..".\\Health_Bars\\ui\\0_elements\\label.lua" ) )

package.preload[ "Health_Bars.ui.1_components.percentage_label" ] = assert( (loadstring or load)( "local this = {};\
\
local modules = require(\"Health_Bars.modules\");\
\
function this.draw(enemy, label, position, opacity_scale, use_boss_ui_font)\
    if not label.visible then\
        return;\
    end\
\
    local percentage = enemy.health_percentage;\
    if enemy.is_angie and not modules.game_handler.game.is_mercenaries then\
        percentage = (3 - enemy.angie_stabbed_count) / 3;\
    end\
\
    local text = string.format(\"%.0f%%\", 100 * percentage);\
\
    modules.label.draw(label, position,opacity_scale, use_boss_ui_font, text);\
end\
\
function this.init_module()\
end\
\
return this;", '@'..".\\Health_Bars\\ui\\1_components\\percentage_label.lua" ) )

package.preload[ "Health_Bars.ui.1_components.value_label" ] = assert( (loadstring or load)( "local this = {};\
\
local modules = require(\"Health_Bars.modules\");\
\
function this.draw(enemy, label, position, opacity_scale, use_boss_ui_font)\
    if not label.visible then\
        return;\
    end\
\
    local text = \"\";\
\
    local health_text =\"\";\
    local max_health_text = \"\";\
\
    if enemy.is_angie and not modules.game_handler.game.is_mercenaries then\
        health_text = tostring(3 - enemy.angie_stabbed_count);\
        max_health_text = \"3\";\
    else\
        health_text = tostring(modules.utils.math.round(enemy.health));\
        max_health_text = tostring(modules.utils.math.round(enemy.max_health));\
    end\
\9\
    if label.include.current_value and label.include.max_value then\
        text = string.format(\"%s/%s\", health_text, max_health_text);\
    elseif label.include.current_value then\
        text = health_text;\
    elseif label.include.max_value then\
        text = max_health_text;\
    else\
        return;\
    end\
\
    modules.label.draw(label, position, opacity_scale, use_boss_ui_font, text);\
end\
\
function this.init_module()\
end\
\
return this;", '@'..".\\Health_Bars\\ui\\1_components\\value_label.lua" ) )

package.preload[ "Health_Bars.ui.2_widgets.health_widget" ] = assert( (loadstring or load)( "local this = {};\
\
local modules = require(\"Health_Bars.modules\");\
\
function this.draw(enemy, health, position, opacity_scale, use_boss_ui_font)\
    if not health.visible then\
        return;\
    end\
\
    local scaled_offset_x, scaled_offset_y = modules.utils.misc.scale_position(health.offset.x, health.offset.y);\
\
    local offset_position = {\
        x = position.x + scaled_offset_x,\
        y = position.y + scaled_offset_y\
    };\
\
    local percentage = enemy.health_percentage;\
    if enemy.is_angie and not modules.game_handler.game.is_mercenaries then\
        percentage = (3 - enemy.angie_stabbed_count) / 3;\
    end\
\
    modules.bar.draw( health.bar, offset_position, opacity_scale, percentage);\
    modules.percentage_label.draw(enemy, health.percentage_label, offset_position, opacity_scale, use_boss_ui_font);\
    modules.value_label.draw(enemy, health.value_label, offset_position, opacity_scale, use_boss_ui_font);\
end\
\
function this.init_module()\
end\
\
return this;", '@'..".\\Health_Bars\\ui\\2_widgets\\health_widget.lua" ) )

package.preload[ "Health_Bars.ui.3_uis.boss_ui" ] = assert( (loadstring or load)( "local this = {};\
\
local modules = require(\"Health_Bars.modules\");\
\
function this.get_anchored_position(index)\
    local cached_default_language = modules.language.default_language.customization_menu;\
    local cached_config = modules.config.current_config;\
\
    local anchor = cached_config.boss_ui.position.anchor;\
\
    local anchor_x = 0;\
    local anchor_y = 0;\
\
    if anchor == cached_default_language.top_left then\
        anchor_x = 0;\
        anchor_y = 0;\
    elseif anchor == cached_default_language.top_middle then\
        anchor_x = 0.5;\
        anchor_y = 0;\
    elseif anchor == cached_default_language.top_right then\
        anchor_x = 1;\
        anchor_y = 0;\
    elseif anchor == cached_default_language.middle_left then\
        anchor_x = 0;\
        anchor_y = 0.5;\
    elseif anchor == cached_default_language.center then\
        anchor_x = 0.5;\
        anchor_y = 0.5;\
    elseif anchor == cached_default_language.middle_right then\
        anchor_x = 1;\
        anchor_y = 0.5;\
    elseif anchor == cached_default_language.bottom_left then\
        anchor_x = 0;\
        anchor_y = 1;\
    elseif anchor == cached_default_language.bottom_middle then\
        anchor_x = 0.5;\
        anchor_y = 1;\
    elseif anchor == cached_default_language.bottom_right then\
        anchor_x = 1;\
        anchor_y = 1;\
    end\
\
    local base_x = anchor_x * modules.screen.width;\
    local base_y = anchor_y * modules.screen.height;\
\
    local position_x = cached_config.boss_ui.position.x;\
    local position_y = cached_config.boss_ui.position.y;\
\
    local spacing_x = index * cached_config.boss_ui.spacing.x;\
    local spacing_y = index * cached_config.boss_ui.spacing.y;\
\
\
    if anchor == cached_default_language.bottom_left\
    or anchor == cached_default_language.bottom_middle\
    or anchor == cached_default_language.bottom_right then\
        position_y = -position_y;\
        spacing_y = -spacing_y;\
    end\
\
    if anchor == cached_default_language.top_right\
    or anchor == cached_default_language.middle_right\
    or anchor == cached_default_language.bottom_right then\
        position_x = -position_x;\
        spacing_x = -spacing_x;\
    end\
    \
    local scaled_position_x, scaled_position_y = modules.utils.misc.scale_position(position_x, position_y);\
    local scaled_spacing_x, scaled_spacing_y = modules.utils.misc.scale_position(spacing_x, spacing_y);\
\
    return {\
        x = base_x + scaled_position_x + scaled_spacing_x,\
        y = base_y + scaled_position_y + scaled_spacing_y,\
    };\
end\
\
function this.draw()\
    local cached_config = modules.config.current_config;\
    local cached_language = modules.language.current_language.ui;\
\
    if not cached_config.boss_ui.visible then\
        return;\
    end\
\
    -- Game states\
\
    if not cached_config.boss_ui.settings.render_during_cutscenes and modules.game_handler.game.is_cutscene_playing then\
        return;\
    end\
\
\9if not cached_config.boss_ui.settings.render_when_game_timer_is_paused and modules.game_handler.game.is_paused then\
\9\9return;\
\9end\
\
    if not cached_config.boss_ui.settings.render_in_mercenaries and modules.game_handler.game.is_mercenaries then\
\9\9return;\
\9end\
\
    if not cached_config.boss_ui.settings.render_in_house_benevientos_basement and modules.game_handler.game.is_chapter_2_3 and modules.game_handler.game.is_house_benevientos_basement then\
        return;\
    end\
\
    if not modules.player_handler.player.is_aiming then\
\9\9if not cached_config.boss_ui.settings.render_when_normal then\
\9\9\9return;\
\9\9end\
\9elseif not modules.player_handler.player.is_using_scope then\
\9\9if not cached_config.boss_ui.settings.render_when_aiming then\
\9\9\9return;\
\9\9end\
\9else\
\9\9if not cached_config.boss_ui.settings.render_when_using_scope then\
\9\9\9return;\
\9\9end\
\9end\
\
\9if cached_config.boss_ui.settings.hide_if_player_cant_take_damage and not modules.player_handler.player.is_enable_damage then\
\9\9return;\
\9end\
\
\9if cached_config.boss_ui.settings.hide_if_player_cant_use_items and not modules.player_handler.player.is_enable_use_item then\
\9\9return;\
\9end\
\
\9local index = 0;\
\
\9for enemy_core, enemy in pairs(modules.enemy_handler.enemy_list) do\
\9\9do\
\9\9if not enemy.is_initialized then\
\9\9\9goto continue;\
\9\9end\
\
\9\9if enemy.is_boss_filtered_out then\
\9\9\9goto continue;\
\9\9end\
\
\9\9if cached_config.boss_ui.settings.hide_if_dead and enemy.is_dead then\
\9\9\9goto continue;\
\9\9end\
\
\9\9if cached_config.boss_ui.settings.hide_if_full_health and modules.utils.number.is_equal(enemy.health, enemy.max_health) then\
\9\9\9goto continue;\
\9\9end\
\
\9\9if cached_config.boss_ui.settings.hide_if_enemy_model_is_not_being_rendered and not enemy.is_visible then\
\9\9\9goto continue;\
\9\9end\
\
\9\9local anchored_position = this.get_anchored_position(index);\
\
        local name = \"\";\
\
        if enemy.is_urias then\
            name = cached_language.urias;\
        elseif enemy.is_urias_drac then\
            name = cached_language.urias_drac;\
        elseif enemy.is_urias_strajer then\
            name = cached_language.urias_strajer;\
        elseif enemy.is_bela then\
            name = cached_language.bela;\
        elseif enemy.is_cassandra then\
            name = cached_language.cassandra;\
        elseif enemy.is_daniela then\
            name = cached_language.daniela;\
        elseif enemy.is_dimitrescu or enemy.is_dimitrescu_boss then\
            name = cached_language.dimitrescu;\
        elseif enemy.is_angie then\
            name = cached_language.angie;\
        elseif enemy.is_varcolac then\
            name = cached_language.varcolac;\
        elseif enemy.is_varcolac_alfa then\
            name = cached_language.varcolac_alfa;\
        elseif enemy.is_moreau_boss then\
            name = cached_language.moreau;\
        elseif enemy.is_sturm then\
            name = cached_language.sturm;\
        elseif enemy.is_heisenberg_boss then\
            name = cached_language.heisenberg;\
        elseif enemy.is_executioner then\
            name = cached_language.executioner;\
        elseif enemy.is_miranda_boss or enemy.is_miranda_boss_dlc then\
            name = cached_language.miranda;\
        end\
\
        modules.health_widget.draw(enemy, cached_config.boss_ui.health, anchored_position, 1, true);\
\9\9modules.label.draw(cached_config.boss_ui.name_label, anchored_position, 1, true, name);\
\9\9\
\9\9index = index + 1;\
\9\9end\
\9\9::continue::\
\9end\
end\
\
function this.init_module()\
end\
\
return this;\
", '@'..".\\Health_Bars\\ui\\3_uis\\boss_ui.lua" ) )

package.preload[ "Health_Bars.ui.3_uis.dynamic_ui" ] = assert( (loadstring or load)( "local this = {};\
\
local modules = require(\"Health_Bars.modules\");\
\
function this.draw()\
\9local cached_config = modules.config.current_config;\
\
\9if not cached_config.dynamic_ui.visible then\
        return;\
    end\
\
\9if not cached_config.dynamic_ui.settings.render_during_cutscenes and modules.game_handler.game.is_cutscene_playing then\
\9\9return;\
\9end\
\
\9if not cached_config.dynamic_ui.settings.render_when_game_timer_is_paused and modules.game_handler.game.is_paused then\
\9\9return;\
\9end\
\
\9if not cached_config.dynamic_ui.settings.render_in_mercenaries and modules.game_handler.game.is_mercenaries then\
\9\9return;\
\9end\
\
\9if not cached_config.dynamic_ui.settings.render_in_house_benevientos_basement and modules.game_handler.game.is_chapter_2_3 and modules.game_handler.game.is_house_benevientos_basement then\
        return;\
    end\
\
\9if not modules.player_handler.player.is_aiming then\
\9\9if not cached_config.dynamic_ui.settings.render_when_normal then\
\9\9\9return;\
\9\9end\
\9elseif not modules.player_handler.player.is_using_scope then\
\9\9if not cached_config.dynamic_ui.settings.render_when_aiming then\
\9\9\9return;\
\9\9end\
\9else\
\9\9if not cached_config.dynamic_ui.settings.render_when_using_scope then\
\9\9\9return;\
\9\9end\
\9end\
\
\9if cached_config.dynamic_ui.settings.hide_if_player_cant_take_damage and not modules.player_handler.player.is_enable_damage then\
\9\9return;\
\9end\
\
\9if cached_config.dynamic_ui.settings.hide_if_player_cant_use_items and not modules.player_handler.player.is_enable_use_item then\
\9\9return;\
\9end\
\
\9local max_distance = 0;\
\9if modules.player_handler.player.is_using_scope then\
\9\9max_distance = cached_config.dynamic_ui.settings.scope_max_distance;\
\9else\
\9\9max_distance = cached_config.dynamic_ui.settings.max_distance;\
\9end\
\
\9for enemy_core, enemy in pairs(modules.enemy_handler.enemy_list) do\
\9\9do\
\9\9if not enemy.is_initialized then\
\9\9\9goto continue;\
\9\9end\
\
\9\9if enemy.is_filtered_out then\
\9\9\9goto continue;\
\9\9end\
\
\9\9local position = enemy.position;\
\9\9local distance = enemy.distance;\
\
\9\9if max_distance ~= 0 and distance > max_distance then\
\9\9\9goto continue;\
\9\9end\
\
\9\9local is_time_duration_on = false;\
\9\9\
\9\9if cached_config.dynamic_ui.settings.apply_time_duration_on_aiming\
\9\9or cached_config.dynamic_ui.settings.apply_time_duration_on_aim_target\
\9\9or cached_config.dynamic_ui.settings.apply_time_duration_on_using_scope\
\9\9or cached_config.dynamic_ui.settings.apply_time_duration_on_damage_dealt then\
\9\9\9if cached_config.dynamic_ui.settings.time_duration ~= 0 then\
\9\9\9\9if modules.time.total_elapsed_script_seconds - enemy.last_reset_time > cached_config.dynamic_ui.settings.time_duration then\
\9\9\9\9\9goto continue;\
\9\9\9\9else\
\9\9\9\9\9is_time_duration_on = true;\
\9\9\9\9end\
\9\9\9end\
\9\9end\
\
\9\9if not cached_config.dynamic_ui.settings.render_aim_target_enemy and enemy.owner == modules.player_handler.player.aim_target_owner and not is_time_duration_on then\
\9\9\9goto continue;\
\9\9end\
\
\9\9if not cached_config.dynamic_ui.settings.render_damaged_enemies and not modules.utils.number.is_equal(enemy.health, enemy.max_health) and not is_time_duration_on then\
\9\9\9if enemy.owner == modules.player_handler.player.aim_target_owner then\
\9\9\9\9if not cached_config.dynamic_ui.settings.render_aim_target_enemy then\
\9\9\9\9\9goto continue;\
\9\9\9\9end\
\9\9\9else\
\9\9\9\9goto continue;\
\9\9\9end\
\9\9end\
\
\9\9if not cached_config.dynamic_ui.settings.render_everyone_else and enemy.owner ~= modules.player_handler.player.aim_target_owner and modules.utils.number.is_equal(enemy.health, enemy.max_health) and not is_time_duration_on then\
\9\9\9goto continue;\
\9\9end\
\
\9\9if cached_config.dynamic_ui.settings.hide_if_dead and enemy.is_dead then\
\9\9\9goto continue;\
\9\9end\
\
\9\9if cached_config.dynamic_ui.settings.hide_if_full_health and modules.utils.number.is_equal(enemy.health, enemy.max_health) then\
\9\9\9goto continue;\
\9\9end\
\
\9\9if cached_config.dynamic_ui.settings.hide_if_enemy_model_is_not_being_rendered and not enemy.is_visible\
\9\9and not enemy.is_always_visible then\
\9\9\9goto continue;\
\9\9end\
\
\9\9local world_offset = modules.reframework_globals.Vector3f.new(cached_config.dynamic_ui.world_offset.x, cached_config.dynamic_ui.world_offset.y, cached_config.dynamic_ui.world_offset.z);\
\
\9\9local position_on_screen = modules.reframework_globals.draw.world_to_screen(position + world_offset);\
\9\9if position_on_screen == nil then\
\9\9\9goto continue;\
\9\9end\
\
\9\9local scaled_offset_x, scaled_offset_y = modules.utils.misc.scale_position(cached_config.dynamic_ui.offset.x, cached_config.dynamic_ui.offset.y);\
\
        local scaled_offset = modules.reframework_globals.Vector2f.new(scaled_offset_x, scaled_offset_y);\
        local scaled_offset_position_on_screen = position_on_screen + scaled_offset;\
\
\9\9local opacity_scale = 1;\
\9\9if modules.player_handler.player.is_using_scope then\
\9\9\9if cached_config.dynamic_ui.settings.scope_opacity_falloff and max_distance ~= 0 then\
\9\9\9\9opacity_scale = 1 - (distance / max_distance);\
\9\9\9end\
\9\9else\
\9\9\9if cached_config.dynamic_ui.settings.opacity_falloff and max_distance ~= 0 then\
\9\9\9\9opacity_scale = 1 - (distance / max_distance);\
\9\9\9end\
\9\9end\
\
\9\9modules.health_widget.draw(enemy, cached_config.dynamic_ui.health, scaled_offset_position_on_screen, opacity_scale, false);\
\
\9\9end\
\9\9::continue::\
\9end\
end\
\
function this.init_module()\
end\
\
return this;\
", '@'..".\\Health_Bars\\ui\\3_uis\\dynamic_ui.lua" ) )

package.preload[ "Health_Bars.ui.ui" ] = assert( (loadstring or load)( "local this = {};\
\
local modules = require(\"Health_Bars.modules\");\
\
function this.get_anchored_position()\
    local cached_default_language = modules.language.default_language.customization_menu;\
    local cached_config = modules.config.current_config;\
\
    local anchor = cached_config.ui.position.anchor;\
\
    local anchor_x = 0;\
    local anchor_y = 0;\
\
    if anchor == cached_default_language.top_left then\
        anchor_x = 0;\
        anchor_y = 0;\
    elseif anchor == cached_default_language.top_middle then\
        anchor_x = 0.5;\
        anchor_y = 0;\
    elseif anchor == cached_default_language.top_right then\
        anchor_x = 1;\
        anchor_y = 0;\
    elseif anchor == cached_default_language.middle_left then\
        anchor_x = 0;\
        anchor_y = 0.5;\
    elseif anchor == cached_default_language.center then\
        anchor_x = 0.5;\
        anchor_y = 0.5;\
    elseif anchor == cached_default_language.middle_right then\
        anchor_x = 1;\
        anchor_y = 0.5;\
    elseif anchor == cached_default_language.bottom_left then\
        anchor_x = 0;\
        anchor_y = 1;\
    elseif anchor == cached_default_language.bottom_middle then\
        anchor_x = 0.5;\
        anchor_y = 1;\
    elseif anchor == cached_default_language.bottom_right then\
        anchor_x = 1;\
        anchor_y = 1;\
    end\
\
    local base_x = anchor_x * modules.screen.width;\
    local base_y = anchor_y * modules.screen.height;\
\
    local offset_x = cached_config.ui.position.x;\
    local offset_y = cached_config.ui.position.y;\
\
    if anchor == cached_default_language.bottom_left\
    or anchor == cached_default_language.bottom_middle\
    or anchor == cached_default_language.bottom_right then\
        offset_y = -offset_y;\
    end\
\
    if anchor == cached_default_language.top_right\
        or anchor == cached_default_language.middle_right\
        or anchor == cached_default_language.bottom_right then\
        offset_x = -offset_x;\
    end\
    \
    local scaled_offset_x, scaled_offset_y = modules.utils.misc.scale_position(offset_x, offset_y);\
\
    return {\
        x = base_x + scaled_offset_x,\
        y = base_y + scaled_offset_y,\
    };\
end\
\
function this.draw()\
    modules.dynamic_ui.draw();\
    modules.boss_ui.draw();\
end\
\
function this.init_module()\
end\
\
return this;", '@'..".\\Health_Bars\\ui\\ui.lua" ) )

package.preload[ "Health_Bars.utils" ] = assert( (loadstring or load)( "local this = {};\
\
local sdk = sdk;\
local tostring = tostring;\
local pairs = pairs;\
local ipairs = ipairs;\
local tonumber = tonumber;\
local require = require;\
local pcall = pcall;\
local table = table;\
local string = string;\
local Vector3f = Vector3f;\
local d2d = d2d;\
local math = math;\
local json = json;\
local log = log;\
local fs = fs;\
local next = next;\
local type = type;\
local setmetatable = setmetatable;\
local getmetatable = getmetatable;\
local assert = assert;\
local select = select;\
local coroutine = coroutine;\
local utf8 = utf8;\
local re = re;\
local imgui = imgui;\
local draw = draw;\
local Vector2f = Vector2f;\
local reframework = reframework;\
local os = os;\
local ValueType = ValueType;\
local package = package;\
\
local table_tostring;\
local deep_copy;\
local merge;\
local is_empty;\
local unicode_map;\
local unicode_relative_position;\
local unicode_chars;\
local epsilon = 0.000001;\
\
this.table = {};\
this.type = {};\
this.number = {};\
this.string = {};\
this.vec2 = {};\
this.vec3 = {};\
this.vec4 = {};\
this.math = {};\
this.unicode = {};\
this.sdk = {};\
\
this.constants = {};\
this.constants.uninitialized_int = -420;\
this.constants.uninitialized_string = \"Uninitialized\";\
this.constants.epsilon = epsilon;\
\
function this.table.tostring(table_)\
\9if type(table_) == \"number\" or type(table_) == \"boolean\" or type(table_) == \"string\" then\
\9\9return tostring(table_);\
\9end\
\
\9if is_empty(table_) then\
\9\9return \"{}\"; \
\9end\
\
\9local cache = {};\
\9local stack = {};\
\9local output = {};\
    local depth = 1;\
    local output_str = \"{\\n\";\
\
    while true do\
        local size = 0;\
        for k,v in pairs(table_) do\
            size = size + 1;\
        end\
\
        local cur_index = 1;\
        for k,v in pairs(table_) do\
            if cache[table_] == nil or cur_index >= cache[table_] then\
\
                if string.find(output_str, \"}\", output_str:len()) then\
                    output_str = output_str .. \",\\n\";\
                elseif not string.find(output_str, \"\\n\", output_str:len()) then\
                    output_str = output_str .. \"\\n\";\
                end\
\
                -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings\
                table.insert(output,output_str);\
                output_str = \"\";\
\
                local key;\
                if type(k) == \"number\" or type(k) == \"boolean\" then\
                    key = \"[\" .. tostring(k) .. \"]\";\
                else\
                    key = \"['\" .. tostring(k) .. \"']\";\
                end\
\
                if type(v) == \"number\" or type(v) == \"boolean\" then\
                    output_str = output_str .. string.rep('\\t', depth) .. key .. \" = \" .. tostring(v);\
                elseif type(v) == \"table\" then\
                    output_str = output_str .. string.rep('\\t', depth) .. key .. \" = {\\n\";\
                    table.insert(stack, table_);\
                    table.insert(stack, v);\
                    cache[table_] = cur_index + 1;\
                    break;\
                else\
                    output_str = output_str .. string.rep('\\t', depth) .. key .. \" = '\" .. tostring(v) .. \"'\";\
                end\
\
                if cur_index == size then\
                    output_str = output_str .. \"\\n\" .. string.rep('\\t', depth - 1) .. \"}\";\
                else\
                    output_str = output_str .. \",\";\
                end\
            else\
                -- close the table\
                if cur_index == size then\
                    output_str = output_str .. \"\\n\" .. string.rep('\\t', depth - 1) .. \"}\";\
                end\
            end\
\
            cur_index = cur_index + 1;\
        end\
\
        if size == 0 then\
            output_str = output_str .. \"\\n\" .. string.rep('\\t', depth - 1) .. \"}\";\
        end\
\
        if #stack > 0 then\
            table_ = stack[#stack];\
            stack[#stack] = nil;\
            depth = cache[table_] == nil and depth + 1 or depth - 1;\
        else\
            break;\
        end\
    end\
\
    -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings\
    table.insert(output, output_str);\
    output_str = table.concat(output);\
\
    return output_str;\
end\
\
function this.table.tostringln(table_)\
\9return \"\\n\" .. table_tostring(table_);\
end\
\
function this.table.is_empty(table_)\
\9return next(table_) == nil;\
end\
\
function this.table.deep_copy(original, copies)\
\9copies = copies or {};\
\9local original_type = type(original);\
\9local copy;\
\9if original_type == \"table\" then\
\9\9if copies[original] then\
\9\9\9copy = copies[original];\
\9\9else\
\9\9\9copy = {};\
\9\9\9copies[original] = copy;\
\9\9\9for original_key, original_value in next, original, nil do\
\9\9\9\9copy[deep_copy(original_key, copies)] = deep_copy(original_value,copies);\
\9\9\9end\
\9\9\9setmetatable(copy, deep_copy(getmetatable(original), copies));\
\9\9end\
\9else -- number, string, boolean, etc\
\9\9copy = original;\
\9end\
\9return copy;\
end\
\
function this.table.find_index(table_, value, nullable)\
\9for i = 1, #table_ do\
\9\9if table_[i] == value then\
\9\9\9return i;\
\9\9end\
\9end\
\
\9if not nullable then\
\9\9return 1;\
\9end\
\
\9return nil;\
end\
\
function this.table.merge(...)\
\9local tables_to_merge = { ... };\
\9assert(#tables_to_merge > 1, \"There should be at least two tables to merge them\");\
\
\9for key, table_ in ipairs(tables_to_merge) do\
\9\9assert(type(table_) == \"table\", string.format(\"Expected a table as function parameter %d\", key));\
\9end\
\
\9local result = deep_copy(tables_to_merge[1]);\
\
\9for i = 2, #tables_to_merge do\
\9\9local from = tables_to_merge[i];\
\9\9for key, value in pairs(from) do\
\9\9\9if type(value) == \"table\" then\
\9\9\9\9result[key] = result[key] or {};\
\9\9\9\9assert(type(result[key]) == \"table\", string.format(\"Expected a table: '%s'\", key));\
\9\9\9\9result[key] = merge(result[key], value);\
\9\9\9else\
\9\9\9\9result[key] = value;\
\9\9\9end\
\9\9end\
\9end\
\
\9return result;\
end\
\
function this.type.is_boolean(value)\
\9return value == true or value == false;\
end\
\
function this.type.is_REField(value)\
\9return \9value.get_return_type == nil;\
end\
\
function this.type.is_REMethodDefinition(value)\
\9return \9value.get_return_type ~= nil;\
end\
\
function this.number.is_NaN(value)\
\9return tostring(value) == tostring(0/0);\
end\
\
function this.number.round(value)\
\9return math.floor(value + 0.5);\
end\
\
function this.number.is_odd(value)\
\9return value % 2 ~= 0;\
end\
\
function this.number.is_even(value)\
\9return value % 2 == 0;\
end\
\
function this.number.is_equal(value1, value2)\
\9if math.abs(value1 - value2) < epsilon then\
\9\9return true;\
\9end\
\
\9return false;\
end\
\
function this.string.trim(str)\
\9return str:match(\"^%s*(.-)%s*$\");\
end\
\
function this.string.starts_with(str, pattern)\
\9return str:find(\"^\" .. pattern) ~= nil;\
end\
\
function this.vec2.tostring(vector2f)\
\9return string.format(\"<%f, %f>\", vector2f.x, vector2f.y);\
end\
\
function this.vec2.random(distance)\
\9distance = distance or 1;\
\9local radians = math.random() * math.pi * 2;\
\9return Vector2f.new(\
\9\9distance * math.cos(radians),\
\9\9distance * math.sin(radians)\
\9);\
end\
\
function this.vec3.tostring(vector3f)\
\9return string.format(\"<%f, %f, %f>\", vector3f.x, vector3f.y, vector3f.z);\
end\
\
function this.vec4.tostring(vector4f)\
\9return string.format(\"<%f, %f, %f, %f>\", vector4f.x, vector4f.y, vector4f.z, vector4f.w);\
end\
\
--- When called without arguments, returns a pseudo-random float with uniform distribution in the range [0,1). When called with two floats min and max, math.random returns a pseudo-random float with uniform distribution in the range [min, max). The call .random(max) is equivalent to .random(1, max)\
---@param min number\
---@param max number\
---@return number\
function this.math.random(min, max)\
\9if min == nil and max == nil then\
\9\9return math.random();\
\9end\
\
\9if max == nil then\
\9\9return max * math.random();\
\9end\
\
\9return min + (max - min) * math.random();\
end\
\
function this.math.sign(value)\
\9return (value >= 0 and 1) or -1;\
end\
function this.math.round(value, bracket)\
\9bracket = bracket or 1;\
\9return math.floor(value / bracket + this.math.sign(value) * 0.5) * bracket;\
end\
\
-- https://github.com/blitmap/lua-utf8-simple/blob/master/utf8_simple.lua\
\
-- ABNF from RFC 3629\
--\
-- UTF8-octets = *( UTF8-char )\
-- UTF8-char = UTF8-1 / UTF8-2 / UTF8-3 / UTF8-4\
-- UTF8-1 = %x00-7F\
-- UTF8-2 = %xC2-DF UTF8-tail\
-- UTF8-3 = %xE0 %xA0-BF UTF8-tail / %xE1-EC 2( UTF8-tail ) /\
-- %xED %x80-9F UTF8-tail / %xEE-EF 2( UTF8-tail )\
-- UTF8-4 = %xF0 %x90-BF 2( UTF8-tail ) / %xF1-F3 3( UTF8-tail ) /\
-- %xF4 %x80-8F 2( UTF8-tail )\
-- UTF8-tail = %x80-BF\
\
-- 0xxxxxxx                            | 007F   (127)\
-- 110xxxxx\00910xxxxxx                   | 07FF   (2047)\
-- 1110xxxx\00910xxxxxx 10xxxxxx          | FFFF   (65535)\
-- 11110xxx\00910xxxxxx 10xxxxxx 10xxxxxx | 10FFFF (1114111)\
\
local pattern = \"[%z\\1-\\127\\194-\\244][\\128-\\191]*\";\
\
-- helper function\
function this.unicode.relative_position(position, length)\
\9if position < 0 then\
\9\9position = length + position + 1;\
\9end\
\9return position;\
end\
\
-- THE MEAT\
\
-- maps f over s's utf8 characters f can accept args: (visual_index, utf8_character, byte_index)\
function this.unicode.map(s, f, no_subs)\
\9local i = 0;\
\
\9if no_subs then\
\9\9for b, e in s:gmatch(\"()\" .. pattern .. \"()\") do\
\9\9\9i = i + 1;\
\9\9\9local c = e - b;\
\9\9\9f(i, c, b);\
\9\9end\
\9else\
\9\9for b, c in s:gmatch(\"()(\" .. pattern .. \")\") do\
\9\9\9i = i + 1;\
\9\9\9f(i, c, b);\
\9\9end\
\9end\
end\
\
-- THE REST\
\
-- returns the number of characters in a UTF-8 string\
function this.unicode.len(s)\
\9-- count the number of non-continuing bytes\
\9return select(2, s:gsub('[^\\128-\\193]', ''));\
end\
\
-- replace all utf8 chars with mapping\
function this.unicode.replace(s, map)\
\9return s:gsub(pattern, map);\
end\
\
-- reverse a utf8 string\
function this.unicode.reverse(s)\
\9-- reverse the individual greater-than-single-byte characters\
\9s = s:gsub(pattern, function (c)\
\9\9return #c > 1 and c:reverse()\
\9end);\
\
\9return s:reverse();\
end\
\
-- strip non-ascii characters from a utf8 string\
function this.unicode.strip(s)\
\9return s:gsub(pattern, function(c)\
\9\9return #c > 1 and '';\
\9end);\
end\
\
-- generator for the above -- to iterate over all utf8 chars\
function this.unicode.chars(s, no_subs)\
\9return coroutine.wrap(function()\
\9\9return unicode_map(s, coroutine.yield, no_subs);\
\9end);\
end\
\
-- like string.sub() but i, j are utf8 strings\
-- a utf8-safe string.sub()\
function this.unicode.sub(str, i, j)\
\9if coroutine == nil then\
\9\9return str;\
\9end\
\
\9local l = utf8.len(str);\
\
\9i = unicode_relative_position(i, l);\
\9j = j and unicode_relative_position(j, l) or l;\
\
\9if i < 1 then\
\9\9i = 1;\
\9end\
\
\9if j > l then\
\9\9j = l;\
\9end\
\
\9if i > j then\
\9\9return \"\";\
\9end\
\
\9local diff = j - i;\
\9local iterator = unicode_chars(str, true);\
\
\9-- advance up to i\
\9for _ = 1, i - 1 do\
\9\9iterator();\
\9end\
\
\9local c, b = select(2, iterator());\
\
\9-- i and j are the same, single-charaacter sub\
\9if diff == 0 then\
\9\9return string.sub(str, b, b + c - 1);\
\9end\
\
\9i = b;\
\
\9-- advance up to j\
\9for _ = 1, diff - 1 do\
\9\9iterator();\
\9end\
\
\9c, b = select(2, iterator());\
\
\9return string.sub(str, i, b + c - 1);\
end\
\
function this.sdk.generate_enum(type_def)\
\9if not type_def then\
\9\9return {};\
\9end\
\
\9local fields = type_def:get_fields();\
\9local enum = {};\
\
\9for i, field in ipairs(fields) do\
\9\9if field:is_static() then\
\9\9\9local name = field:get_name();\
\9\9\9local raw_value = field:get_data(nil);\
\
\9\9\9local enum_entry = {\
\9\9\9\9name = name,\
\9\9\9\9value = raw_value;\
\9\9\9};\
\
\9\9\9table.insert(enum, enum_entry);\
\9\9end\
\9end\
\
\9return enum;\
end\
\
function this.sdk.generate_enum_by_typename(type_name)\
\9local type_def = sdk.find_type_definition(type_name);\
\9if not type_def then\
\9\9return {};\
\9end;\
\
\9return this.sdk.generate_enum(type_def);\
end\
\
function this.init_module()\
end\
\
table_tostring = this.table.tostring;\
deep_copy = this.table.deep_copy;\
merge = this.table.merge;\
is_empty = this.table.is_empty;\
unicode_map = this.unicode.map;\
unicode_relative_position = this.unicode.relative_position;\
unicode_chars = this.unicode.chars;\
\
return this;", '@'..".\\Health_Bars\\utils.lua" ) )

assert( (loadstring or load)( "local modules = require(\"Health_Bars.modules\");\
\
------------------------INIT MODULES-------------------------\
-- #region\
modules.init_module();\
modules.log.init_module();\
modules.time.init_module();\
modules.throttle.init_module();\
modules.drawing.init_module();\
modules.utils.init_module();\
modules.language.init_module();\
modules.config.init_module();\
modules.error_handler.init_module();\
modules.screen.init_module();\
modules.singletons.init_module();\
\
modules.position_customization.init_module();\
modules.offset_customization.init_module();\
modules.color_customization.init_module();\
modules.label_customization.init_module();\
modules.bar_customization.init_module();\
modules.spacing_customization.init_module();\
modules.world_offset_customization.init_module();\
modules.customization_menu.init_module();\
\
modules.bar.init_module();\
modules.label.init_module();\
modules.percentage_label.init_module();\
modules.value_label.init_module();\
modules.health_widget.init_module();\
modules.boss_ui.init_module();\
modules.dynamic_ui.init_module();\
modules.ui.init_module();\
\
modules.game_handler.init_module();\
modules.player_handler.init_module();\
modules.enemy_handler.init_module();\
\
modules.log.info(\"Loaded\");\
-- #endregion\
------------------------INIT MODULES-------------------------\
\
----------------------------LOOP-----------------------------\
-- #region\
modules.reframework_globals.re.on_pre_application_entry(\"UpdateBehavior\", function()\
\9if not modules.config.current_config.enabled then\
\9\9return;\
\9end\
\
    local cached_config = modules.config.current_config;\
\
\9modules.time.update_timers();\
\9\
\9modules.enemy_handler.update_all_periodics();\
\9modules.throttle.throttle(modules.singletons.update, cached_config.settings.timer_delays.update_singletons_delay);\
\9modules.throttle.throttle(modules.screen.update_window_size, cached_config.settings.timer_delays.update_window_size_delay);\
\9modules.throttle.throttle(modules.game_handler.update, cached_config.settings.timer_delays.update_game_data_delay);\
\9modules.throttle.throttle(modules.player_handler.update, cached_config.settings.timer_delays.update_player_data_delay);\
end);\
\
local function main_loop()\
    if not modules.config.current_config.enabled then\
        return;\
    end\
\
\9modules.player_handler.update_position();\
\9modules.enemy_handler.update_all_positions();\
\9\
\9modules.ui.draw();\
end\
\
-- #endregion\
----------------------------LOOP-----------------------------\
\
--------------------------RE_IMGUI---------------------------\
-- #region\
modules.reframework_globals.re.on_draw_ui(function()\
\9local changed = false;\
\9local cached_config = modules.config.current_config;\
\
    if modules.reframework_globals.imgui.button(modules.utils.imgui.label(tostring(modules.language.default_language.customization_menu.mod_name) .. \" v\" .. tostring(modules.config.current_config.version), \"reframework_menu\")) then\
        modules.customization_menu.is_opened = not modules.customization_menu.is_opened;\
    end\
\9\
\9modules.reframework_globals.imgui.same_line();\
\
\9changed, cached_config.enabled = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label(\"Enabled\", \"reframework_menu\"), cached_config.enabled);\
\9if changed then\
\9\9modules.config.save();\
\9end\
end);\
\
modules.reframework_globals.re.on_frame(function()\
\9if not modules.reframework_globals.reframework:is_drawing_ui() then\
\9\9return;\
\9end\
\
\9if modules.customization_menu.is_opened then\
\9\9local success, error = pcall(modules.customization_menu.draw);\
\
\9\9if not success then\
\9\9\9modules.error_handler.report(\"re.on_frame\", error);\
\9\9end\
\9end\
end);\
-- #endregion\
--------------------------RE_IMGUI---------------------------\
\
----------------------------D2D------------------------------\
-- #region\
if modules.reframework_globals.d2d ~= nil then\
\9modules.reframework_globals.d2d.register(function()\
\9\9modules.drawing.init_font();\
\9end, function()\
\9\9if not modules.config.current_config.settings.use_d2d_if_available then\
\9\9\9return;\
\9\9end\
\
\9\9local success, error = pcall(main_loop);\
\
\9\9if not success then\
\9\9\9modules.error_handler.report(\"d2d.on_frame\", error);\
\9\9end\
\9end);\
end\
\
modules.reframework_globals.re.on_frame(function()\
\9if modules.reframework_globals.d2d ~= nil and modules.config.current_config.settings.use_d2d_if_available then\
\9\9return;\
\9end\
\
\9local success, error = pcall(main_loop);\
\
\9if not success then\
\9\9modules.error_handler.report(\"re.on_frame\", error);\
\9end\
end);\
-- #endregion\
----------------------------D2D------------------------------\
\
\
", '@'.."D:\\GitHub\\RE-Village-Health-Bars\\reframework\\autorun\\Health_Bars_dev.lua" ) )( ... )

