local this = {};

local utils;
local singletons;
local config;
local customization_menu;
local enemy_handler;
local time;

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

this.player = {};
this.player.position = Vector3f.new(0, 0, 0);
this.player.is_aiming = false;
this.player.is_using_scope = false;
this.player.aim_target_owner = nil;

local enemy_manager_type_def = sdk.find_type_definition("app.EnemyManager");
local get_aim_target_enemy_method = enemy_manager_type_def:get_method("get_aimTargetEnemy");

local weapon_gun_core_type_def = sdk.find_type_definition("app.WeaponGunCore");
local on_aim_start_method = weapon_gun_core_type_def:get_method("onAimStart");
local on_aim_end_method = weapon_gun_core_type_def:get_method("onAimEnd");
local update_scope_method = weapon_gun_core_type_def:get_method("updateScope");

local player_core_base_type_def = sdk.find_type_definition("app.PlayerCoreBase");
local update_method = player_core_base_type_def:get_method("update");

local props_manager_type_def = sdk.find_type_definition("app.PropsManager");
local get_player_method = props_manager_type_def:get_method("get_Player");

local game_object_type_def = sdk.find_type_definition("via.GameObject");
local get_transform_method = game_object_type_def:get_method("get_Transform");

local transform_type_def = get_transform_method:get_return_type();
local get_position_method = transform_type_def:get_method("get_Position");

local cast_result_type_def = sdk.find_type_definition("app.CollisionManager.CastResult");
local game_object_field = cast_result_type_def:get_field("GameObject");

function this.update_position()
	if singletons.props_manager == nil then
		customization_menu.status = "[player.update_position] No Props Manager";
		return;
	end

	local player = get_player_method:call(singletons.props_manager);

	if player == nil then
		customization_menu.status = "[player.update_position] No Player";
		return;
	end

	local player_transform = get_transform_method:call(player);

	if player_transform == nil then
		customization_menu.status = "[player.update_position] No Player Transform";
		return;
	end

	local position = get_position_method:call(player_transform);
	if position == nil then
		customization_menu.status = "[player.update_position] No Player Position";
		return;
	end

	this.player.position = position;
end

function this.update_aim_target()
	local cached_config = config.current_config.settings;

	local enemy_manager = singletons.enemy_manager;

	if enemy_manager == nil then
		customization_menu.status = "[player.update_aim_target] No Enemy Manager";
		return;
	end

	local aim_target_game_object = get_aim_target_enemy_method:call(enemy_manager);

	if aim_target_game_object == nil then
		this.player.aim_target_owner = nil;
		return;
	end

	this.player.aim_target_owner = aim_target_game_object;

	if cached_config.reset_time_duration_on_aim_target_for_everyone then
		for enemy_core, enemy in pairs(enemy_handler.enemy_list) do
			if time.total_elapsed_script_seconds - enemy.last_reset_time < cached_config.time_duration then
				enemy_handler.update_last_reset_time(enemy);
			end

		end
	end
	
	if cached_config.apply_time_duration_on_aim_target then
		enemy_handler.update_last_reset_time(enemy_handler.enemy_owner_list[aim_target_game_object]);
	end
end

function this.update()
	this.update_aim_target();
end

function this.on_aim_start(weapon_gun_core)
	local cached_config = config.current_config.settings;

	this.player.is_aiming = true;
	this.player.is_using_scope = false;

	if cached_config.apply_time_duration_on_aiming then
		for enemy_core, enemy in pairs(enemy_handler.enemy_list) do
			enemy_handler.update_last_reset_time(enemy);
		end
	end
end

function this.on_aim_end(weapon_gun_core)
	this.player.is_aiming = false;
	this.player.is_using_scope = false;
end

function this.on_update_scope(weapon_gun_core)
	local cached_config = config.current_config.settings;

	this.player.is_using_scope = true;

	if cached_config.apply_time_duration_on_using_scope then
		for enemy_core, enemy in pairs(enemy_handler.enemy_list) do
			enemy_handler.update_last_reset_time(enemy);
		end
	end
end

function this.init_module()
	utils = require("Health_Bars.utils");
	config = require("Health_Bars.config");
	singletons = require("Health_Bars.singletons");
	customization_menu = require("Health_Bars.customization_menu");
	enemy_handler = require("Health_Bars.enemy_handler");
	time = require("Health_Bars.time");

	sdk.hook(on_aim_start_method, function(args)

		local weapon_gun_core = sdk.to_managed_object(args[2]);
		this.on_aim_start(weapon_gun_core)

	end, function(retval)
		return retval;
	end);

	sdk.hook(on_aim_end_method, function(args)

		local weapon_gun_core = sdk.to_managed_object(args[2]);
		this.on_aim_end(weapon_gun_core)

	end, function(retval)
		return retval;
	end);

	sdk.hook(update_scope_method, function(args)

		local weapon_gun_core = sdk.to_managed_object(args[2]);
		this.on_update_scope(weapon_gun_core)

	end, function(retval)
		return retval;
	end);
end

return this;