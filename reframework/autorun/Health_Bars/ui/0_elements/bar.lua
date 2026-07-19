local this = {};

local modules = require("Health_Bars.modules");

function this.draw(bar, position, opacity_scale, percentage)
    if not bar.visible then
        return;
    end
	
    local scaled_offset_x, scaled_offset_y = modules.utils.misc.scale_position(bar.offset.x, bar.offset.y);

	local offset_position = {
        x = position.x + scaled_offset_x,
        y = position.y + scaled_offset_y
    };

	modules.drawing.draw_bar(bar, offset_position, opacity_scale, percentage);
end


function this.init_module()
end

return this;