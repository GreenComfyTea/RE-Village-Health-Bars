local this = {};

local customization_menu;
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

local enemy_manager_name = "app.EnemyManager";
local content_timer_name = "app.ContentTimer";
local event_system_app_name = "app.EventSystemApp";
local props_manager_name = "app.PropsManager";
local rogue_enemy_health_holder_name = "app.RogueEnemyHealthHolder";

this.enemy_manager = nil;
this.content_timer = nil;
this.event_system_app = nil;
this.props_manager = nil;
this.rogue_enemy_health_holder = nil;

function this.update()
	this.update_enemy_manager();
	this.update_content_timer();
	this.update_event_system_app();
	this.update_props_manager();
	this.update_rogue_enemy_health_holder();
end

function this.update_enemy_manager()
	this.enemy_manager = sdk.get_managed_singleton(enemy_manager_name);
	if this.enemy_manager == nil then
		error_handler.report("singletons.update_enemy_manager", "No EnemyManager");
	end

	return this.character_manager;
end

function this.update_content_timer()
	this.content_timer = sdk.get_managed_singleton(content_timer_name);
	if this.content_timer == nil then
		error_handler.report("singletons.update_content_timer", "No ContentTimer");
	end

	return this.content_timer;
end

function this.update_event_system_app()
	this.event_system_app = sdk.get_managed_singleton(event_system_app_name);
	if this.event_system_app == nil then
		error_handler.report("singletons.update_event_system_app","No EventSystemApp");
	end

	return this.event_system_app;
end

function this.update_props_manager()
	this.props_manager = sdk.get_managed_singleton(props_manager_name);
	if this.props_manager == nil then
		error_handler.report("singletons.update_props_manager", "No Props Manager");
	end

	return this.props_manager;
end

function this.update_rogue_enemy_health_holder()
	this.rogue_enemy_health_holder = sdk.get_managed_singleton(rogue_enemy_health_holder_name);
	-- if this.rogue_enemy_health_holder == nil then
		-- error_handler.report("singletons.update_rogue_enemy_health_holder", "No RogueEnemyHealthHolder");
	-- end

	return this.rogue_enemy_health_holder;
end

function this.init_module()
	customization_menu = require("Health_Bars.customization_menu");
	error_handler = require("Health_Bars.error_handler");

	this.update();
end

return this;
