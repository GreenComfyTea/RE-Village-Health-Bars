local modules = require("Health_Bars.modules");

------------------------INIT MODULES-------------------------
-- #region
modules.init_module();
modules.log.init_module();
modules.time.init_module();
modules.throttle.init_module();
modules.drawing.init_module();
modules.utils.init_module();
modules.language.init_module();
modules.config.init_module();
modules.error_handler.init_module();
modules.screen.init_module();
modules.singletons.init_module();

modules.position_customization.init_module();
modules.offset_customization.init_module();
modules.color_customization.init_module();
modules.label_customization.init_module();
modules.bar_customization.init_module();
modules.spacing_customization.init_module();
modules.world_offset_customization.init_module();
modules.customization_menu.init_module();

modules.bar.init_module();
modules.label.init_module();
modules.percentage_label.init_module();
modules.value_label.init_module();
modules.health_widget.init_module();
modules.boss_ui.init_module();
modules.dynamic_ui.init_module();
modules.ui.init_module();

modules.game_handler.init_module();
modules.player_handler.init_module();
modules.enemy_handler.init_module();

modules.log.info("Loaded");
-- #endregion
------------------------INIT MODULES-------------------------

----------------------------LOOP-----------------------------
-- #region
modules.reframework_globals.re.on_pre_application_entry("UpdateBehavior", function()
	if not modules.config.current_config.enabled then
		return;
	end

    local cached_config = modules.config.current_config;

	modules.time.update_timers();
	
	modules.enemy_handler.update_all_periodics();
	modules.throttle.throttle(modules.singletons.update, cached_config.settings.timer_delays.update_singletons_delay);
	modules.throttle.throttle(modules.screen.update_window_size, cached_config.settings.timer_delays.update_window_size_delay);
	modules.throttle.throttle(modules.game_handler.update, cached_config.settings.timer_delays.update_game_data_delay);
	modules.throttle.throttle(modules.player_handler.update, cached_config.settings.timer_delays.update_player_data_delay);
end);

local function main_loop()
    if not modules.config.current_config.enabled then
        return;
    end

	modules.player_handler.update_position();
	modules.enemy_handler.update_all_positions();
	
	modules.ui.draw();
end

-- #endregion
----------------------------LOOP-----------------------------

--------------------------RE_IMGUI---------------------------
-- #region
modules.reframework_globals.re.on_draw_ui(function()
	local changed = false;
	local cached_config = modules.config.current_config;

    if modules.reframework_globals.imgui.button(modules.utils.imgui.label(tostring(modules.language.default_language.customization_menu.mod_name) .. " v" .. tostring(modules.config.current_config.version), "reframework_menu")) then
        modules.customization_menu.is_opened = not modules.customization_menu.is_opened;
    end
	
	modules.reframework_globals.imgui.same_line();

	changed, cached_config.enabled = modules.reframework_globals.imgui.checkbox(modules.utils.imgui.label("Enabled", "reframework_menu"), cached_config.enabled);
	if changed then
		modules.config.save();
	end
end);

modules.reframework_globals.re.on_frame(function()
	if not modules.reframework_globals.reframework:is_drawing_ui() then
		return;
	end

	if modules.customization_menu.is_opened then
		local success, error = pcall(modules.customization_menu.draw);

		if not success then
			modules.error_handler.report("re.on_frame", error);
		end
	end
end);
-- #endregion
--------------------------RE_IMGUI---------------------------

----------------------------D2D------------------------------
-- #region
if modules.reframework_globals.d2d ~= nil then
	modules.reframework_globals.d2d.register(function()
		modules.drawing.init_font();
	end, function()
		if not modules.config.current_config.settings.use_d2d_if_available then
			return;
		end

		local success, error = pcall(main_loop);

		if not success then
			modules.error_handler.report("d2d.on_frame", error);
		end
	end);
end

modules.reframework_globals.re.on_frame(function()
	if modules.reframework_globals.d2d ~= nil and modules.config.current_config.settings.use_d2d_if_available then
		return;
	end

	local success, error = pcall(main_loop);

	if not success then
		modules.error_handler.report("re.on_frame", error);
	end
end);
-- #endregion
----------------------------D2D------------------------------


