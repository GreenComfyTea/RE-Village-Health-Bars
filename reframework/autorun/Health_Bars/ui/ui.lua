local this = {};

local modules = require("Health_Bars.modules");

function this.get_anchored_position()
    local cached_default_language = modules.language.default_language.customization_menu;
    local cached_config = modules.config.current_config;

    local anchor = cached_config.ui.position.anchor;

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

    local offset_x = cached_config.ui.position.x;
    local offset_y = cached_config.ui.position.y;

    if anchor == cached_default_language.bottom_left
    or anchor == cached_default_language.bottom_middle
    or anchor == cached_default_language.bottom_right then
        offset_y = -offset_y;
    end

    if anchor == cached_default_language.top_right
        or anchor == cached_default_language.middle_right
        or anchor == cached_default_language.bottom_right then
        offset_x = -offset_x;
    end
    
    local scaled_offset_x, scaled_offset_y = modules.utils.misc.scale_position(offset_x, offset_y);

    return {
        x = base_x + scaled_offset_x,
        y = base_y + scaled_offset_y,
    };
end

function this.draw()
    modules.dynamic_ui.draw();
    modules.boss_ui.draw();
end

function this.init_module()
end

return this;