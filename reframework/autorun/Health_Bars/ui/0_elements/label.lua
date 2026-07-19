local this = {};

local modules = require("Health_Bars.modules");

function this.draw(label, position, opacity_scale, use_boss_ui_font, text)
	if not label.visible then
		return;
	end
	
	modules.drawing.draw_label(label, position, opacity_scale, use_boss_ui_font, text);
end

function this.init_module()
end

return this;