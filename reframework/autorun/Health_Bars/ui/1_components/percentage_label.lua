local this = {};

local modules = require("Health_Bars.modules");

function this.draw(enemy, label, position, opacity_scale, use_boss_ui_font)
    if not label.visible then
        return;
    end

    local percentage = enemy.health_percentage;
    if enemy.is_angie and not modules.game_handler.game.is_mercenaries then
        percentage = (3 - enemy.angie_stabbed_count) / 3;
    end

    local text = string.format("%.0f%%", 100 * percentage);

    modules.label.draw(label, position,opacity_scale, use_boss_ui_font, text);
end

function this.init_module()
end

return this;