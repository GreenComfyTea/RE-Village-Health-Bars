local this = {};

local modules = require("Health_Bars.modules");

function this.draw(enemy, label, position, opacity_scale, use_boss_ui_font)
    if not label.visible then
        return;
    end

    local text = "";

    local health_text ="";
    local max_health_text = "";

    if enemy.is_angie and not modules.game_handler.game.is_mercenaries then
        health_text = tostring(3 - enemy.angie_stabbed_count);
        max_health_text = "3";
    else
        health_text = tostring(modules.utils.math.round(enemy.health));
        max_health_text = tostring(modules.utils.math.round(enemy.max_health));
    end
	
    if label.include.current_value and label.include.max_value then
        text = string.format("%s/%s", health_text, max_health_text);
    elseif label.include.current_value then
        text = health_text;
    elseif label.include.max_value then
        text = max_health_text;
    else
        return;
    end

    modules.label.draw(label, position, opacity_scale, use_boss_ui_font, text);
end

function this.init_module()
end

return this;