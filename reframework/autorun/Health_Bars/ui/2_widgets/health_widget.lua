local this = {};

local modules = require("Health_Bars.modules");

function this.draw(enemy, health, position, opacity_scale, use_boss_ui_font)
    if not health.visible then
        return;
    end

    local scaled_offset_x, scaled_offset_y = modules.utils.misc.scale_position(health.offset.x, health.offset.y);

    local offset_position = {
        x = position.x + scaled_offset_x,
        y = position.y + scaled_offset_y
    };

    local percentage = enemy.health_percentage;
    if enemy.is_angie and not modules.game_handler.game.is_mercenaries then
        percentage = (3 - enemy.angie_stabbed_count) / 3;
    end

    modules.bar.draw( health.bar, offset_position, opacity_scale, percentage);
    modules.percentage_label.draw(enemy, health.percentage_label, offset_position, opacity_scale, use_boss_ui_font);
    modules.value_label.draw(enemy, health.value_label, offset_position, opacity_scale, use_boss_ui_font);
end

function this.init_module()
end

return this;