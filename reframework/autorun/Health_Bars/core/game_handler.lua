local this = {};

local modules = require("Health_Bars.modules");

this.game = {};
this.game.is_cutscene_playing = false;
this.game.is_paused = false;
this.game.is_mercenaries = false;

local update_time_limit = 0.6;

local pause_off_timer = nil;
local cutscene_off_timer = nil;

local content_timer_type_def = modules.reframework_globals.sdk.find_type_definition("app.ContentTimer");
local on_pause_method = content_timer_type_def:get_method("onPause");

local event_system_app_type_def = modules.reframework_globals.sdk.find_type_definition("app.EventSystemApp");
local is_running_event_method = event_system_app_type_def:get_method("isRunningEvent(System.Boolean)");

local mercenaries_utility_type_def = modules.reframework_globals.sdk.find_type_definition("app.MercenariesUtility");
local is_mercenaries_mode_method = mercenaries_utility_type_def:get_method("inMercenariesMode");

local map_manager_type_def = modules.reframework_globals.sdk.find_type_definition("app.MapManager");
local get_current_indoor_unit_method = map_manager_type_def:get_method("get_currentIndoorUnit");
local get_current_room_unit_method = map_manager_type_def:get_method("get_currentRoomUnit");

local indoor_unit_type_def = modules.reframework_globals.sdk.find_type_definition("app.MapManagerData.IndoorUnit");
local get_indoor_name_method = indoor_unit_type_def:get_method("get_indoorName");

local room_unit_type_def = modules.reframework_globals.sdk.find_type_definition("app.MapManagerData.RoomUnit");
local get_floor_no_method = room_unit_type_def:get_method("get_floorNo");

function this.update_is_cutscene()
	local event_system_app = modules.singletons.event_system_app;

	if event_system_app == nil then
		modules.error_handler.report("game_handler.update_is_cutscene", "No EventSystemApp");
        return;
    end

	local is_player_event_playing = is_running_event_method:call(event_system_app, true);
	local is_event_playing = is_running_event_method:call(event_system_app, false);

	if is_player_event_playing == nil then
		modules.error_handler.report("game_handler.update_is_cutscene",  "No IsPlayerEventPlaying");
		is_player_event_playing = false;
	end

	if is_event_playing == nil then
		modules.error_handler.report("game_handler.update_is_cutscene", "No IsEventPlaying");
		is_event_playing = false;
	end

	local is_cutscene_playing = is_player_event_playing or is_event_playing;

	-- Cutscene
	if is_cutscene_playing then
		this.game.is_cutscene_playing = true;
		modules.time.remove_delay_timer(cutscene_off_timer);
		cutscene_off_timer = nil;
		return;
	end

	-- Game No Cutscene, State No Cutscene
	if not this.game.is_cutscene_playing then
		modules.time.remove_delay_timer(cutscene_off_timer);
		cutscene_off_timer = nil;
		return;
	end

	-- Game No Cutscene, State Cutscene, Timer is On
	if cutscene_off_timer ~= nil then
		return;
	end

	-- Game No Cutscene, State Cutscene, Timer is Off
	cutscene_off_timer = modules.time.new_delay_timer(function()
		this.game.is_cutscene_playing = false;
		cutscene_off_timer = nil;
	end,
	update_time_limit);
end

function this.update_is_mercenaries()
	local is_mercenaries_mode = is_mercenaries_mode_method:call(nil);
	if is_mercenaries_mode == nil then
		modules.error_handler.report("game_handler.update_is_mercenaries", "No isMercenariesMode");
		return;
	end

	this.game.is_mercenaries = is_mercenaries_mode;
end

function this.update_map_indoor_info()
	local map_manager = modules.singletons.map_manager;
	if map_manager == nil then
		modules.error_handler.report("game_handler.update_map_indoor_info", "No MapManager");
		return;
	end

	this.game.is_house_benevientos_basement = false;

	local current_indoor_unit = get_current_indoor_unit_method:call(map_manager);
	if current_indoor_unit == nil then
		return;
	end

	local indoor_name = get_indoor_name_method:call(current_indoor_unit);
	if indoor_name == nil then
		modules.error_handler.report("game_handler.update_map_indoor_info", "No indoorName");
		return;
	end

	local current_room_unit = get_current_room_unit_method:call(map_manager);
	if current_room_unit == nil then
		modules.error_handler.report("game_handler.update_map_indoor_info", "No currentRoomUnit");
		return;
	end

	local floor_no = get_floor_no_method:call(current_room_unit);
	if floor_no == nil then
		modules.error_handler.report("game_handler.update_map_indoor_info", "No floorNo");
		return;
	end

	this.game.is_house_benevientos_basement = indoor_name == "Indoor2_3" and floor_no < 0;
end

function this.update()
	this.update_is_cutscene();
	this.update_is_mercenaries();
	this.update_map_indoor_info();
end

function this.on_pause(is_paused_int)
	if is_paused_int == nil then
		modules.error_handler.report("game_handler.on_pause", "No IsPaused Int");
		return;
	end

	local is_paused = (is_paused_int & 1) == 1;

	-- Pause
	if is_paused then
		this.game.is_paused = true;
		modules.time.remove_delay_timer(pause_off_timer);
		pause_off_timer = nil;
		return;
	end

	-- Game No Pause, State No Pause
	if not this.game.is_paused then
		modules.time.remove_delay_timer(pause_off_timer);
		pause_off_timer = nil;
		return;
	end

	-- Game No Pause, State Pause, Timer is On
	if pause_off_timer ~= nil then
		return;
	end

	-- Game No Pause, State Pause, Timer is Off
	pause_off_timer = modules.time.new_delay_timer(function()
		this.game.is_paused = false;
		pause_off_timer = nil;
	end,
	update_time_limit);
end

function this.init_module()
	modules.reframework_globals.sdk.hook(on_pause_method, function(args)
		local is_paused_int = modules.reframework_globals.sdk.to_int64(args[3]);
		
		this.on_pause(is_paused_int);
	end, function(retval)
		return retval;
	end);
end

return this;