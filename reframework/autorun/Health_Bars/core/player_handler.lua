local this = {};

local modules = require("Health_Bars.modules");

this.player = {};
this.player.position = modules.reframework_globals.Vector3f.new(0, 0, 0);
this.player.is_aiming = false;
this.player.is_using_scope = false;
this.player.aim_target_owner = nil;
this.player.is_enable_damage = true;
this.player.is_enable_use_item = true;

local enemy_manager_type_def = modules.reframework_globals.sdk.find_type_definition("app.EnemyManager");
local get_aim_target_enemy_method = enemy_manager_type_def:get_method("get_aimTargetEnemy");

local weapon_gun_core_type_def = modules.reframework_globals.sdk.find_type_definition("app.WeaponGunCore");
local on_aim_start_method = weapon_gun_core_type_def:get_method("onAimStart");
local on_aim_end_method = weapon_gun_core_type_def:get_method("onAimEnd");
local update_scope_method = weapon_gun_core_type_def:get_method("updateScope");

local props_manager_type_def = modules.reframework_globals.sdk.find_type_definition("app.PropsManager");
local get_player_method = props_manager_type_def:get_method("get_Player");

local game_object_type_def = modules.reframework_globals.sdk.find_type_definition("via.GameObject");
local get_transform_method = game_object_type_def:get_method("get_Transform");

local transform_type_def = get_transform_method:get_return_type();
local get_position_method = transform_type_def:get_method("get_Position");

local player_core_fps_type_def = modules.reframework_globals.sdk.find_type_definition("app.PlayerCoreFPS");
local character_status_fps_field = player_core_fps_type_def:get_field("CharacterStatus");
local late_update_fps_method = player_core_fps_type_def:get_method("lateUpdate");
local get_is_enable_damage_fps_method = player_core_fps_type_def:get_method("get_IsEnableDamage");
local set_is_enable_damage_fps_method = player_core_fps_type_def:get_method("set_IsEnableDamage");

local player_core_tps_type_def = modules.reframework_globals.sdk.find_type_definition("app.PlayerCoreTPS");
local character_status_tps_field = player_core_tps_type_def:get_field("CharacterStatus");
local late_update_tps_method = player_core_tps_type_def:get_method("lateUpdate");
local get_is_enable_damage_tps_method = player_core_tps_type_def:get_method("get_IsEnableDamage");

local player_status_type_def = modules.reframework_globals.sdk.find_type_definition("app.PlayerStatus");
local get_is_player_method = player_status_type_def:get_method("get_isPlayer");
local get_is_enable_use_item_method = player_status_type_def:get_method("get_isEnableUseItem");

function this.update_position()
	if modules.singletons.props_manager == nil then
		modules.error_handler.report("player.update_position", "No PropsManager");
		return;
	end

	local player = get_player_method:call(modules.singletons.props_manager);
	if player == nil then
		modules.error_handler.report("player.update_position", "No Player");
		return;
	end

	local player_transform = get_transform_method:call(player);

	if player_transform == nil then
		modules.error_handler.report("player.update_position", "No Transform");
		return;
	end

	local position = get_position_method:call(player_transform);
	if position == nil then
		modules.error_handler.report("player.update_position", "No Position");
		return;
	end

	this.player.position = position;
end

function this.update_aim_target()
	local cached_config = modules.config.current_config.settings;

	local enemy_manager = modules.singletons.enemy_manager;

	if enemy_manager == nil then
		modules.error_handler.report("player.update_aim_target", "No EnemyManager");
		return;
	end

	local aim_target_game_object = get_aim_target_enemy_method:call(enemy_manager);

	if aim_target_game_object == nil then
		this.player.aim_target_owner = nil;
		return;
	end

	this.player.aim_target_owner = aim_target_game_object;

	if cached_config.reset_time_duration_on_aim_target_for_everyone then
		for enemy_core, enemy in pairs(modules.enemy_handler.enemy_list) do
			if modules.time.total_elapsed_script_seconds - enemy.last_reset_time < cached_config.time_duration then
				modules.enemy_handler.update_last_reset_time(enemy);
			end

		end
	end
	
	if cached_config.apply_time_duration_on_aim_target then
		modules.enemy_handler.update_last_reset_time(modules.enemy_handler.enemy_owner_list[aim_target_game_object]);
	end
end

function this.update()
	this.update_aim_target();
end

function this.on_aim_start(weapon_gun_core)
	local cached_config = modules.config.current_config.settings;

	this.player.is_aiming = true;
	this.player.is_using_scope = false;

	if cached_config.apply_time_duration_on_aiming then
		for enemy_core, enemy in pairs(modules.enemy_handler.enemy_list) do
			modules.enemy_handler.update_last_reset_time(enemy);
		end
	end
end

function this.on_aim_end(weapon_gun_core)
	this.player.is_aiming = false;
	this.player.is_using_scope = false;
end

function this.on_update_scope(weapon_gun_core)
	local cached_config = modules.config.current_config.settings;

	this.player.is_using_scope = true;

	if cached_config.apply_time_duration_on_using_scope then
		for enemy_core, enemy in pairs(modules.enemy_handler.enemy_list) do
			modules.enemy_handler.update_last_reset_time(enemy);
		end
	end
end

function this.on_late_update_fps(player_core_fps)
    local character_status = character_status_fps_field:get_data(player_core_fps);
    if character_status == nil then
        modules.error_handler.report("player_handler.on_late_update_fps", "No Character Status");
        return;
    end

    local is_player = get_is_player_method:call(character_status);
    if is_player == nil then
        modules.error_handler.report("player_handler.on_late_update_fps", "No IsPlayer");
        return;
    end

    if not is_player then
        return;
    end

	local is_enable_damage = get_is_enable_damage_fps_method:call(player_core_fps);
    if is_enable_damage == nil then
        modules.error_handler.report("player_handler.on_late_update_fps", "No IsEnableDamage");
        return;
    end

	local is_enable_use_item = get_is_enable_use_item_method:call(character_status);
	if is_enable_use_item == nil then
		modules.error_handler.report("player_handler.on_late_update_fps", "No IsEnableUseItem");
		return;
	end

    this.player.is_enable_damage = is_enable_damage;
	this.player.is_enable_use_item = is_enable_use_item;
end

function this.on_late_update_tps(player_core_tps)
    local character_status = character_status_tps_field:get_data(player_core_tps);
    if character_status == nil then
        modules.error_handler.report("player_handler.on_late_update_tps", "No Character Status");
        return;
    end

    local is_player = get_is_player_method:call(character_status);
    if is_player == nil then
        modules.error_handler.report("player_handler.on_late_update_tps", "No IsPlayer");
        return;
    end

    if not is_player then
        return;
    end

    local is_enable_damage = get_is_enable_damage_tps_method:call(player_core_tps);
    if is_enable_damage == nil then
        modules.error_handler.report("player_handler.on_late_update_tps", "No IsEnableDamage");
        return;
    end

    local is_enable_use_item = get_is_enable_use_item_method:call(character_status);
	if is_enable_use_item == nil then
		modules.error_handler.report("player_handler.on_late_update_tps", "No IsEnableUseItem");
		return;
	end

    this.player.is_enable_damage = is_enable_damage;
	this.player.is_enable_use_item = is_enable_use_item;
end

function this.on_set_is_enable_damage_fps(is_enable_damage)
    this.player.is_enable_damage = is_enable_damage;
end

function this.init_module()
	modules.reframework_globals.sdk.hook(on_aim_start_method, function(args)
		local weapon_gun_core = modules.reframework_globals.sdk.to_managed_object(args[2]);
		
		this.on_aim_start(weapon_gun_core)
	end, function(retval)
		return retval;
	end);

	modules.reframework_globals.sdk.hook(on_aim_end_method, function(args)
		local weapon_gun_core = modules.reframework_globals.sdk.to_managed_object(args[2]);
		
		this.on_aim_end(weapon_gun_core)
	end, function(retval)
		return retval;
	end);

	modules.reframework_globals.sdk.hook(update_scope_method, function(args)
        local weapon_gun_core = modules.reframework_globals.sdk.to_managed_object(args[2]);
		
		this.on_update_scope(weapon_gun_core)
	end, function(retval)
		return retval;
	end);

	modules.reframework_globals.sdk.hook(late_update_fps_method, function(args)
        local player_core_fps = modules.reframework_globals.sdk.to_managed_object(args[2]);

		modules.throttle.throttle(this.on_late_update_fps, modules.config.current_config.settings.timer_delays.update_player_data_delay, player_core_fps);
	end, function(retval)
		return retval;
    end);

    modules.reframework_globals.sdk.hook(late_update_tps_method, function(args)
        local player_core_tps = modules.reframework_globals.sdk.to_managed_object(args[2]);

		modules.throttle.throttle(this.on_late_update_tps, modules.config.current_config.settings.timer_delays.update_player_data_delay, player_core_tps);
	end, function(retval)
		return retval;
    end);

	-- Works for TPS as well
	modules.reframework_globals.sdk.hook(set_is_enable_damage_fps_method, function(args)
        local is_enable_damage = (modules.reframework_globals.sdk.to_int64(args[3]) & 1) == 1;

        this.on_set_is_enable_damage_fps(is_enable_damage);
	end, function(retval)
		return retval;
    end);
end

return this;