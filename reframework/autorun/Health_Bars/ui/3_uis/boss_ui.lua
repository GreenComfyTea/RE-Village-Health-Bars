local this = {};

local modules = require("Health_Bars.modules");

function this.get_anchored_position(index)
    local cached_default_language = modules.language.default_language.customization_menu;
    local cached_config = modules.config.current_config;

    local anchor = cached_config.boss_ui.position.anchor;

    local anchor_x = 0;
    local anchor_y = 0;

    if anchor == cached_default_language.top_left then
        anchor_x = 0;
        anchor_y = 0;
    elseif anchor == cached_default_language.top_middle then
        anchor_x = 0.5;
        anchor_y = 0;
    elseif anchor == cached_default_language.top_right then
        anchor_x = 1;
        anchor_y = 0;
    elseif anchor == cached_default_language.middle_left then
        anchor_x = 0;
        anchor_y = 0.5;
    elseif anchor == cached_default_language.center then
        anchor_x = 0.5;
        anchor_y = 0.5;
    elseif anchor == cached_default_language.middle_right then
        anchor_x = 1;
        anchor_y = 0.5;
    elseif anchor == cached_default_language.bottom_left then
        anchor_x = 0;
        anchor_y = 1;
    elseif anchor == cached_default_language.bottom_middle then
        anchor_x = 0.5;
        anchor_y = 1;
    elseif anchor == cached_default_language.bottom_right then
        anchor_x = 1;
        anchor_y = 1;
    end

    local base_x = anchor_x * modules.screen.width;
    local base_y = anchor_y * modules.screen.height;

    local position_x = cached_config.boss_ui.position.x;
    local position_y = cached_config.boss_ui.position.y;

    local spacing_x = index * cached_config.boss_ui.spacing.x;
    local spacing_y = index * cached_config.boss_ui.spacing.y;


    if anchor == cached_default_language.bottom_left
    or anchor == cached_default_language.bottom_middle
    or anchor == cached_default_language.bottom_right then
        position_y = -position_y;
        spacing_y = -spacing_y;
    end

    if anchor == cached_default_language.top_right
    or anchor == cached_default_language.middle_right
    or anchor == cached_default_language.bottom_right then
        position_x = -position_x;
        spacing_x = -spacing_x;
    end
    
    local scaled_position_x, scaled_position_y = modules.utils.misc.scale_position(position_x, position_y);
    local scaled_spacing_x, scaled_spacing_y = modules.utils.misc.scale_position(spacing_x, spacing_y);

    return {
        x = base_x + scaled_position_x + scaled_spacing_x,
        y = base_y + scaled_position_y + scaled_spacing_y,
    };
end

function this.draw()
    local cached_config = modules.config.current_config;
    local cached_language = modules.language.current_language.ui;

    if not cached_config.boss_ui.visible then
        return;
    end

    -- Game states

    if not cached_config.boss_ui.settings.render_during_cutscenes and modules.game_handler.game.is_cutscene_playing then
        return;
    end

	if not cached_config.boss_ui.settings.render_when_game_timer_is_paused and modules.game_handler.game.is_paused then
		return;
	end

    if not cached_config.boss_ui.settings.render_in_mercenaries and modules.game_handler.game.is_mercenaries then
		return;
	end

    if not cached_config.boss_ui.settings.render_in_house_benevientos_basement and modules.game_handler.game.is_chapter_2_3 and modules.game_handler.game.is_house_benevientos_basement then
        return;
    end

    if not modules.player_handler.player.is_aiming then
		if not cached_config.boss_ui.settings.render_when_normal then
			return;
		end
	elseif not modules.player_handler.player.is_using_scope then
		if not cached_config.boss_ui.settings.render_when_aiming then
			return;
		end
	else
		if not cached_config.boss_ui.settings.render_when_using_scope then
			return;
		end
	end

	if cached_config.boss_ui.settings.hide_if_player_cant_take_damage and not modules.player_handler.player.is_enable_damage then
		return;
	end

	if cached_config.boss_ui.settings.hide_if_player_cant_use_items and not modules.player_handler.player.is_enable_use_item then
		return;
	end

	local index = 0;

	for enemy_core, enemy in pairs(modules.enemy_handler.enemy_list) do
		do
		if not enemy.is_initialized then
			goto continue;
		end

		if enemy.is_boss_filtered_out then
			goto continue;
		end

		if cached_config.boss_ui.settings.hide_if_dead and enemy.is_dead then
			goto continue;
		end

		if cached_config.boss_ui.settings.hide_if_full_health and modules.utils.number.is_equal(enemy.health, enemy.max_health) then
			goto continue;
		end

		if cached_config.boss_ui.settings.hide_if_enemy_model_is_not_being_rendered and not enemy.is_visible then
			goto continue;
		end

		local anchored_position = this.get_anchored_position(index);

        local name = "";

        if enemy.is_urias then
            name = cached_language.urias;
        elseif enemy.is_urias_drac then
            name = cached_language.urias_drac;
        elseif enemy.is_urias_strajer then
            name = cached_language.urias_strajer;
        elseif enemy.is_bela then
            name = cached_language.bela;
        elseif enemy.is_cassandra then
            name = cached_language.cassandra;
        elseif enemy.is_daniela then
            name = cached_language.daniela;
        elseif enemy.is_dimitrescu or enemy.is_dimitrescu_boss then
            name = cached_language.dimitrescu;
        elseif enemy.is_angie then
            name = cached_language.angie;
        elseif enemy.is_varcolac then
            name = cached_language.varcolac;
        elseif enemy.is_varcolac_alfa then
            name = cached_language.varcolac_alfa;
        elseif enemy.is_moreau_boss then
            name = cached_language.moreau;
        elseif enemy.is_sturm then
            name = cached_language.sturm;
        elseif enemy.is_heisenberg_boss then
            name = cached_language.heisenberg;
        elseif enemy.is_executioner then
            name = cached_language.executioner;
        elseif enemy.is_miranda_boss or enemy.is_miranda_boss_dlc then
            name = cached_language.miranda;
        end

        modules.health_widget.draw(enemy, cached_config.boss_ui.health, anchored_position, 1, true);
		modules.label.draw(cached_config.boss_ui.name_label, anchored_position, 1, true, name);
		
		index = index + 1;
		end
		::continue::
	end
end

function this.init_module()
end

return this;
