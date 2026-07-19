local this = {};

local modules = require("Health_Bars.modules");

this.width = 1920;
this.height = 1080;
this.auto_scale_modifier = 1;

local scene_view;
local scene_view_type = modules.reframework_globals.sdk.find_type_definition("via.SceneView");
local get_size_method = scene_view_type:get_method("get_Size");

local size_type = get_size_method:get_return_type();
local width_field = size_type:get_field("w");
local height_field = size_type:get_field("h");

function this.update_window_size()
	local width;
	local height;

    width, height = this.get_game_window_size();
	
	if width ~= nil then
		this.width = width;
	end

	if height ~= nil then
		this.height = height;
		this.auto_scale_modifier = this.height / 1080;
	end
end

function this.get_game_window_size()
    if scene_view == nil then
        if modules.singletons.scene_manager == nil then
            return;
        end

        scene_view = modules.reframework_globals.sdk.call_native_func(modules.singletons.scene_manager,
            modules.reframework_globals.sdk.find_type_definition("via.SceneManager"), "get_MainView");

        if scene_view == nil then
            return;
        end
    end

    local size = get_size_method:call(scene_view);
    if size == nil then
        return;
    end

    local screen_width = width_field:get_data(size);
    if screen_width == nil then
        return;
    end

    local screen_height = height_field:get_data(size);
    if screen_height == nil then
        return;
    end

    return screen_width, screen_height;
end

function this.init_module()
end

return this;
