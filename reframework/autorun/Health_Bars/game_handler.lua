local this = {};

local singletons;
local customization_menu;
local time;
local enemy_handler;

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

this.game = {};
this.game.is_cutscene_playing = false;
this.game.is_paused = false;
this.game.is_mercenaries = false;

local pause_off_timer = nil;
local cutscene_off_timer = nil;

local content_timer_type_def = sdk.find_type_definition("app.ContentTimer");
local on_pause_method = content_timer_type_def:get_method("onPause");

local event_system_app_type_def = sdk.find_type_definition("app.EventSystemApp");
local is_running_event_method = event_system_app_type_def:get_method("isRunningEvent(System.Boolean)");

function this.update_is_cutscene()
	local event_system_app = singletons.event_system_app;

	if event_system_app == nil then
		customization_menu.status = "[game_handler.update_is_cutscene] No Event System App";
        return;
    end

	local is_player_event_playing = is_running_event_method:call(event_system_app, true);
	local is_event_playing = is_running_event_method:call(event_system_app, false);

	if is_player_event_playing == nil then
		customization_menu.status = "[game_handler.update_is_cutscene] No Is Player Event Playing";
		is_player_event_playing = false;
	end

	if is_event_playing == nil then
		customization_menu.status = "[game_handler.update_is_cutscene] No Is Event Playing";
		is_event_playing = false;
	end

	local is_cutscene_playing = is_player_event_playing or is_event_playing;

	-- Cutscene
	if is_cutscene_playing then
		this.game.is_cutscene_playing = true;
		time.remove_delay_timer(pause_off_timer);
		pause_off_timer = nil;
		return;
	end

	-- Game No Cutscene, State No Cutscene
	if not this.game.is_cutscene_playing then
		time.remove_delay_timer(cutscene_off_timer);
		cutscene_off_timer = nil;
		return;
	end

	-- Game No Cutscene, State Cutscene, Timer is On
	if cutscene_off_timer ~= nil then
		return;
	end


	-- Game No Cutscene, State Cutscene, Timer is Off
	cutscene_off_timer = time.new_delay_timer(function()
		this.game.is_cutscene_playing = false;
		cutscene_off_timer = nil;
	end,
	1.2 * enemy_handler.update_time_limit);
end

function this.update_is_mercenaries()
	this.game.is_mercenaries = singletons.rogue_enemy_health_holder ~= nil;
end

function this.update()
	this.update_is_cutscene();
	this.update_is_mercenaries();
end

function this.on_pause(is_paused_int)
	if is_paused_int == nil then
		customization_menu.status = "[game_handler.on_pause] No Is Paused Int";
		return;
	end

	local is_paused = (is_paused_int & 1) == 1;

	-- Pause
	if is_paused then
		this.game.is_paused = true;
		time.remove_delay_timer(pause_off_timer);
		pause_off_timer = nil;
		return;
	end

	-- Game No Pause, State No Pause
	if not this.game.is_paused then
		time.remove_delay_timer(pause_off_timer);
		pause_off_timer = nil;
		return;
	end

	-- Game No Pause, State Pause, Timer is On
	if pause_off_timer ~= nil then
		return;
	end

	-- Game No Pause, State Pause, Timer is Off
	pause_off_timer = time.new_delay_timer(function()
		this.game.is_paused = false;
		pause_off_timer = nil;
	end,
	1.2 * enemy_handler.update_time_limit);
end

function this.init_module()
	singletons = require("Health_Bars.singletons");
	customization_menu = require("Health_Bars.customization_menu");
	time = require("Health_Bars.time");
	enemy_handler = require("Health_Bars.enemy_handler");

	sdk.hook(on_pause_method, function(args)

		local is_paused_int = sdk.to_int64(args[3]);
		this.on_pause(is_paused_int);

	end, function(retval)
		return retval;
	end);
end

return this;