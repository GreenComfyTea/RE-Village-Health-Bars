local this = {};

local modules = require("Health_Bars.modules");

this.dynamic_font = nil;

function this.create_font(ui_font_config)
	local reframework_font_size = 16;

    if ui_font_config.scale_with_reframework_font_size then
        reframework_font_size = modules.reframework_globals.imgui.get_default_font_size();
    end

	local final_size = modules.utils.math.round(ui_font_config.size_scale_modifier * reframework_font_size);

	return modules.reframework_globals.d2d.Font.new(ui_font_config.family, final_size, ui_font_config.bold, ui_font_config.italic);
end

function this.init_font()
	local cached_config = modules.config.current_config.ui_font;

	this.dynamic_ui_font = this.create_font(cached_config.dynamic_ui);
	this.boss_ui_font = this.create_font(cached_config.boss_ui);
end

function this.argb_color_to_abgr_color(argb_color)
	local alpha = (argb_color >> 24) & 0xFF;
	local red = (argb_color >> 16) & 0xFF;
	local green = (argb_color >> 8) & 0xFF;
	local blue = argb_color & 0xFF;

	local abgr_color = 0x1000000 * alpha + 0x10000 * blue + 0x100 * green + red;

	return abgr_color;
end

function this.color_to_argb(color)
	local alpha = (color >> 24) & 0xFF;
	local red = (color >> 16) & 0xFF;
	local green = (color >> 8) & 0xFF;
	local blue = color & 0xFF;

	return alpha, red, green, blue;
end

function this.argb_to_color(alpha, red, green, blue)
	return 0x1000000 * alpha + 0x10000 * red + 0x100 * green + blue;
end

function this.scale_color_opacity(color, scale)
	local alpha, red, green, blue = this.color_to_argb(color);
	local new_alpha = math.floor(alpha * scale);
	if new_alpha < 0 then
		new_alpha = 0;
	end
	if new_alpha > 255 then
		new_alpha = 255;
	end

	return this.argb_to_color(new_alpha, red, green, blue);
end

function this.get_alignment_shifts(text, alignment, use_boss_ui_font)
	local cached_default_language = modules.language.default_language.customization_menu;

	if alignment == cached_default_language.top_left or alignment == nil then
		return 0, 0;
	end

	local width, height;

	local use_d2d = modules.reframework_globals.d2d ~= nil and modules.config.current_config.settings.use_d2d_if_available;

	local font;

	if use_boss_ui_font then
		font = this.boss_ui_font;
	else
		font = this.dynamic_ui_font;
	end

    if use_d2d and font ~= nil then
        width, height = modules.reframework_globals.d2d.Font.measure(font, text);
    else
        local text_size = modules.reframework_globals.imgui.calc_text_size(text);
        width = text_size.x;
        height = text_size.y;
    end

	if alignment == cached_default_language.top_middle then
		return -width / 2, 0;
	elseif alignment == cached_default_language.top_right then
		return -width, 0;
	elseif alignment == cached_default_language.middle_left then
		return 0, -height / 2;
	elseif alignment == cached_default_language.center then
		return -width / 2, -height / 2;
	elseif alignment == cached_default_language.middle_right then
		return -width, -height / 2;
	elseif alignment == cached_default_language.bottom_left then
		return 0, -height;
	elseif alignment == cached_default_language.bottom_middle then
		return -width / 2, -height;
	elseif alignment == cached_default_language.bottom_right then
		return -width, -height;
	end

	return 0, 0;
end

function this.draw_label(label, position, opacity_scale, use_boss_ui_font, ...)
	if label == nil or not label.visible then
		return;
	end

	local text = string.format("%s", table.unpack({...}));

    if text == "" then
        return;
    end

	local font;

	if use_boss_ui_font then
		font = this.boss_ui_font;
	else
		font = this.dynamic_ui_font;
	end

	local alignment_x, alignment_y = this.get_alignment_shifts(text, label.settings.alignment, use_boss_ui_font);

	local scaled_label_offset_x, scaled_label_offset_y = modules.utils.misc.scale_position(label.offset.x, label.offset.y);

	local position_x = position.x + scaled_label_offset_x + alignment_x;
	local position_y = position.y + scaled_label_offset_y + alignment_y;

	local use_d2d = modules.reframework_globals.d2d ~= nil and modules.config.current_config.settings.use_d2d_if_available;

	if label.shadow.visible then
		local new_shadow_color = label.shadow.color;

		if opacity_scale < 1 then
			new_shadow_color = this.scale_color_opacity(new_shadow_color, opacity_scale);
		end

		if use_d2d then
			modules.reframework_globals.d2d.text(font, text, position_x + label.shadow.offset.x, position_y + label.shadow.offset.y, new_shadow_color);
		else
			new_shadow_color = this.argb_color_to_abgr_color(new_shadow_color);
			modules.reframework_globals.draw.text(text, position_x + label.shadow.offset.x, position_y + label.shadow.offset.y, new_shadow_color);
		end
	end

	local new_color = label.color;
    if opacity_scale < 1 then
        new_color = this.scale_color_opacity(new_color, opacity_scale);
    end
	
	if use_d2d then
		modules.reframework_globals.d2d.text(font, text, position_x, position_y, new_color);
	else
		new_color = this.argb_color_to_abgr_color(new_color);
		modules.reframework_globals.draw.text(text, position_x, position_y, new_color);
	end
end

function this.draw_bar(bar, position, opacity_scale, percentage)
	local cached_default_language = modules.language.default_language.customization_menu;

	if bar == nil or not bar.visible then
		return;
	end

	if percentage > 1 then
		percentage = 1;
	end

	if percentage < 0 then
		percentage = 0;
	end

	-- Apply inverted setting if enabled
	if bar.settings.inverted then
		percentage = 1 - percentage;
	end

	local outline_visible = bar.outline.visible;
	local style = bar.outline.style; -- Inside/Center/Outside
	local fill_direction = bar.settings.fill_direction; -- Left to Right/Right to Left/Top to Bottom/Bottom to Top
	local colors = bar.colors;

	-- Scale outline dimensions using resolution-aware scaling
	local scaled_outline_thickness, scaled_outline_offset = modules.utils.misc.scale_size(bar.outline.thickness, bar.outline.offset);

	-- Scale bar size using resolution-aware scaling
	local scaled_bar_width, scaled_bar_height = modules.utils.misc.scale_size(bar.size.width, bar.size.height);

	local outline_thickness = scaled_outline_thickness;
	if not outline_visible then
		outline_thickness = 0;
	end

	local half_outline_thickness = outline_thickness / 2;

	local outline_offset = scaled_outline_offset;

	if outline_thickness == 0 then
		outline_offset = 0;
	end
	local half_outline_offset = outline_offset / 2;

	local outline_position_x = 0;
	local outline_position_y = 0;

	local outline_width = 0;
	local outline_height = 0;

	local position_x = 0;
	local position_y = 0;

	local width = 0;
	local height = 0;

	local foreground_width = 0;
	local foreground_height = 0;

	local background_width = 0;
	local background_height = 0;

	local foreground_shift_x = 0;
	local foreground_shift_y = 0;

	local background_shift_x = 0;
	local background_shift_y = 0;

	if style == modules.language.default_language.customization_menu.inside then
		outline_position_x = position.x + half_outline_thickness;
		outline_position_y = position.y + half_outline_thickness;

		outline_width = scaled_bar_width - outline_thickness;
		outline_height = scaled_bar_height - outline_thickness;

		position_x = outline_position_x + half_outline_thickness + outline_offset;
		position_y = outline_position_y + half_outline_thickness + outline_offset;

		width = outline_width - outline_thickness - outline_offset - outline_offset;
		height = outline_height - outline_thickness - outline_offset - outline_offset;

	elseif style == modules.language.default_language.customization_menu.center then
		outline_position_x = position.x - half_outline_offset;
		outline_position_y = position.y - half_outline_offset;

		outline_width = scaled_bar_width + outline_offset;
		outline_height = scaled_bar_height + outline_offset;

		position_x = outline_position_x + half_outline_thickness + outline_offset;
		position_y = outline_position_y + half_outline_thickness + outline_offset;

		width = outline_width - outline_thickness - outline_offset - outline_offset;
		height = outline_height - outline_thickness - outline_offset - outline_offset;

	else -- Outside
		position_x = position.x;
		position_y = position.y;

		width = scaled_bar_width;
		height = scaled_bar_height;

		outline_position_x = position_x - half_outline_thickness - outline_offset;
		outline_position_y = position_y - half_outline_thickness - outline_offset;

		outline_width = width + outline_thickness + outline_offset + outline_offset;
		outline_height = height + outline_thickness + outline_offset + outline_offset;
	end

	if fill_direction == cached_default_language.right_to_left then
		foreground_width = width * percentage;
		foreground_height = height;

		background_width = width - foreground_width;
		background_height = height;

		foreground_shift_x = background_width;

	elseif fill_direction == cached_default_language.top_to_bottom then
		foreground_width = width;
		foreground_height = height * percentage;

		background_width = width;
		background_height = height - foreground_height;

		background_shift_y = foreground_height;

	elseif fill_direction == cached_default_language.bottom_to_top then
		foreground_width = width;
		foreground_height = height * percentage;

		background_width = width;
		background_height = height - foreground_height;

		foreground_shift_y = background_height;

	else -- Left to Right
		foreground_width = width * percentage;
		foreground_height = height;

		background_width = width - foreground_width;
		background_height = height;

		background_shift_x = foreground_width;
	end;
	
	local foreground_color = colors.foreground;
	local background_color = colors.background;
	local outline_color = colors.outline;

	if opacity_scale < 1 then
		foreground_color = this.scale_color_opacity(foreground_color, opacity_scale);
		background_color = this.scale_color_opacity(background_color, opacity_scale);
		outline_color = this.scale_color_opacity(outline_color, opacity_scale);
	end

	local use_d2d = modules.reframework_globals.d2d ~= nil and modules.config.current_config.settings.use_d2d_if_available;

	-- background
	if background_width ~= 0 then
		if use_d2d then
			modules.reframework_globals.d2d.fill_rect(position_x + background_shift_x, position_y + background_shift_y, background_width, background_height, background_color);
		else
			background_color = this.argb_color_to_abgr_color(background_color);
			modules.reframework_globals.draw.filled_rect(position_x + background_shift_x, position_y + background_shift_y, background_width, background_height, background_color)
		end
	end

	-- foreground
	if foreground_width ~= 0 then
		if use_d2d then
			modules.reframework_globals.d2d.fill_rect(position_x + foreground_shift_x, position_y + foreground_shift_y, foreground_width, foreground_height, foreground_color);
		else
			foreground_color = this.argb_color_to_abgr_color(foreground_color);
			modules.reframework_globals.draw.filled_rect(position_x + foreground_shift_x, position_y + foreground_shift_y, foreground_width, foreground_height, foreground_color)
		end
	end

	-- outline
	if outline_thickness ~= 0 then
		if use_d2d then
			modules.reframework_globals.d2d.outline_rect(outline_position_x, outline_position_y, outline_width, outline_height, outline_thickness, outline_color);
		else
			outline_color = this.argb_color_to_abgr_color(outline_color);
			modules.reframework_globals.draw.outline_rect(outline_position_x, outline_position_y, outline_width, outline_height, outline_color);
		end
	end
end

function this.init_module()
end

return this;
