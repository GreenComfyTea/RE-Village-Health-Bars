local this = {};

local modules = require("Health_Bars.modules");

function this.draw()
	local cached_config = modules.config.current_config;

	if not cached_config.dynamic_ui.visible then
        return;
    end

	if not cached_config.dynamic_ui.settings.render_during_cutscenes and modules.game_handler.game.is_cutscene_playing then
		return;
	end

	if not cached_config.dynamic_ui.settings.render_when_game_timer_is_paused and modules.game_handler.game.is_paused then
		return;
	end

	if not cached_config.dynamic_ui.settings.render_in_mercenaries and modules.game_handler.game.is_mercenaries then
		return;
	end

	if not cached_config.dynamic_ui.settings.render_in_house_benevientos_basement and modules.game_handler.game.is_chapter_2_3 and modules.game_handler.game.is_house_benevientos_basement then
        return;
    end

	if not modules.player_handler.player.is_aiming then
		if not cached_config.dynamic_ui.settings.render_when_normal then
			return;
		end
	elseif not modules.player_handler.player.is_using_scope then
		if not cached_config.dynamic_ui.settings.render_when_aiming then
			return;
		end
	else
		if not cached_config.dynamic_ui.settings.render_when_using_scope then
			return;
		end
	end

	if cached_config.dynamic_ui.settings.hide_if_player_cant_take_damage and not modules.player_handler.player.is_enable_damage then
		return;
	end

	if cached_config.dynamic_ui.settings.hide_if_player_cant_use_items and not modules.player_handler.player.is_enable_use_item then
		return;
	end

	local max_distance = 0;
	if modules.player_handler.player.is_using_scope then
		max_distance = cached_config.dynamic_ui.settings.scope_max_distance;
	else
		max_distance = cached_config.dynamic_ui.settings.max_distance;
	end

	for enemy_core, enemy in pairs(modules.enemy_handler.enemy_list) do
		do
		if not enemy.is_initialized then
			goto continue;
		end

		if enemy.is_filtered_out then
			goto continue;
		end

		local position = enemy.position;
		local distance = enemy.distance;

		if max_distance ~= 0 and distance > max_distance then
			goto continue;
		end

		local is_time_duration_on = false;
		
		if cached_config.dynamic_ui.settings.apply_time_duration_on_aiming
		or cached_config.dynamic_ui.settings.apply_time_duration_on_aim_target
		or cached_config.dynamic_ui.settings.apply_time_duration_on_using_scope
		or cached_config.dynamic_ui.settings.apply_time_duration_on_damage_dealt then
			if cached_config.dynamic_ui.settings.time_duration ~= 0 then
				if modules.time.total_elapsed_script_seconds - enemy.last_reset_time > cached_config.dynamic_ui.settings.time_duration then
					goto continue;
				else
					is_time_duration_on = true;
				end
			end
		end

		if not cached_config.dynamic_ui.settings.render_aim_target_enemy and enemy.owner == modules.player_handler.player.aim_target_owner and not is_time_duration_on then
			goto continue;
		end

		if not cached_config.dynamic_ui.settings.render_damaged_enemies and not modules.utils.number.is_equal(enemy.health, enemy.max_health) and not is_time_duration_on then
			if enemy.owner == modules.player_handler.player.aim_target_owner then
				if not cached_config.dynamic_ui.settings.render_aim_target_enemy then
					goto continue;
				end
			else
				goto continue;
			end
		end

		if not cached_config.dynamic_ui.settings.render_everyone_else and enemy.owner ~= modules.player_handler.player.aim_target_owner and modules.utils.number.is_equal(enemy.health, enemy.max_health) and not is_time_duration_on then
			goto continue;
		end

		if cached_config.dynamic_ui.settings.hide_if_dead and enemy.is_dead then
			goto continue;
		end

		if cached_config.dynamic_ui.settings.hide_if_full_health and modules.utils.number.is_equal(enemy.health, enemy.max_health) then
			goto continue;
		end

		if cached_config.dynamic_ui.settings.hide_if_enemy_model_is_not_being_rendered and not enemy.is_visible
		and not enemy.is_always_visible then
			goto continue;
		end

		local world_offset = modules.reframework_globals.Vector3f.new(cached_config.dynamic_ui.world_offset.x, cached_config.dynamic_ui.world_offset.y, cached_config.dynamic_ui.world_offset.z);

		local position_on_screen = modules.reframework_globals.draw.world_to_screen(position + world_offset);
		if position_on_screen == nil then
			goto continue;
		end

		local scaled_offset_x, scaled_offset_y = modules.utils.misc.scale_position(cached_config.dynamic_ui.offset.x, cached_config.dynamic_ui.offset.y);

        local scaled_offset = modules.reframework_globals.Vector2f.new(scaled_offset_x, scaled_offset_y);
        local scaled_offset_position_on_screen = position_on_screen + scaled_offset;

		local opacity_scale = 1;
		if modules.player_handler.player.is_using_scope then
			if cached_config.dynamic_ui.settings.scope_opacity_falloff and max_distance ~= 0 then
				opacity_scale = 1 - (distance / max_distance);
			end
		else
			if cached_config.dynamic_ui.settings.opacity_falloff and max_distance ~= 0 then
				opacity_scale = 1 - (distance / max_distance);
			end
		end

		modules.health_widget.draw(enemy, cached_config.dynamic_ui.health, scaled_offset_position_on_screen, opacity_scale, false);

		end
		::continue::
	end
end

function this.init_module()
end

return this;
