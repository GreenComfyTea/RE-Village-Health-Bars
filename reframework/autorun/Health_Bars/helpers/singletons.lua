local this = {};

local modules = require("Health_Bars.modules");

local scene_manager_name = "via.SceneManager";
local enemy_manager_name = "app.EnemyManager";
local event_system_app_name = "app.EventSystemApp";
local props_manager_name = "app.PropsManager";
local map_manager_name = "app.MapManager";

this.scene_manager = nil;
this.enemy_manager = nil;
this.event_system_app = nil;
this.props_manager = nil;
this.map_manager = nil;

function this.update()
	this.update_scene_manager();
    this.update_enemy_manager();
    this.update_event_system_app();
    this.update_props_manager();
	this.update_map_manager();
end

function this.update_scene_manager()
	this.scene_manager = modules.reframework_globals.sdk.get_native_singleton(scene_manager_name);
    if this.scene_manager == nil then
        modules.error_handler.report("singletons.update_scene_manager", "No SceneManager");
    end
	
	return this.scene_manager;
end

function this.update_enemy_manager()
	this.enemy_manager = modules.reframework_globals.sdk.get_managed_singleton(enemy_manager_name);
	if this.enemy_manager == nil then
		modules.error_handler.report("singletons.update_enemy_manager", "No EnemyManager");
	end

	return this.enemy_manager;
end

function this.update_event_system_app()
	this.event_system_app = modules.reframework_globals.sdk.get_managed_singleton(event_system_app_name);
	if this.event_system_app == nil then
		modules.error_handler.report("singletons.update_event_system_app","No EventSystemApp");
	end

	return this.event_system_app;
end

function this.update_props_manager()
	this.props_manager = modules.reframework_globals.sdk.get_managed_singleton(props_manager_name);
	if this.props_manager == nil then
		modules.error_handler.report("singletons.update_props_manager", "No Props Manager");
	end

	return this.props_manager;
end

function this.update_map_manager()
	this.map_manager = modules.reframework_globals.sdk.get_managed_singleton(map_manager_name);
	if this.map_manager == nil then
		modules.error_handler.report("singletons.update_map_manager", "No MapManager");
	end

	return this.map_manager;
end

function this.init_module()
	this.update();
end

return this;
