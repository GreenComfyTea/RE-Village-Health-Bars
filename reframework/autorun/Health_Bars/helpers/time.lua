local this = {};

local modules = require("Health_Bars.modules");

this.total_elapsed_script_seconds = 0;

this.timer_list = {};
this.delay_timer_list = {};

function this.new_timer(callback, cooldown_seconds, start_offset_seconds)
	start_offset_seconds = start_offset_seconds or modules.utils.math.random();

	if callback == nil or cooldown_seconds == nil then
		return;
	end

	local timer = {};
	timer.callback = callback;
	timer.cooldown = cooldown_seconds;

	timer.last_trigger_time = this.total_elapsed_script_seconds + start_offset_seconds;

	this.timer_list[callback] =  timer;
end

function this.new_delay_timer(callback, delay_seconds)
	if callback == nil or delay_seconds == nil then
		return;
	end

	local delay_timer = {};
	delay_timer.callback = callback;
	delay_timer.delay = delay_seconds;

	delay_timer.init_time = this.total_elapsed_script_seconds;

	this.delay_timer_list[callback] = delay_timer;

	return delay_timer;
end

function this.remove_delay_timer(delay_timer)
	if delay_timer == nil then
		return;
	end

	this.delay_timer_list[delay_timer.callback] = nil;
end

function this.update_timers()
	this.update_script_time();

	for callback, timer in pairs(this.timer_list) do
		if this.total_elapsed_script_seconds - timer.last_trigger_time > timer.cooldown then
			timer.last_trigger_time = this.total_elapsed_script_seconds;
			callback();
		end
	end

	local remove_list = {};

	for callback, delay_timer in pairs(this.delay_timer_list) do
		if this.total_elapsed_script_seconds - delay_timer.init_time > delay_timer.delay then
			callback();
			table.insert(remove_list, callback);
		end
	end

	for i, callback in ipairs(remove_list) do
		this.delay_timer_list[callback] = nil;
	end
end

function this.update_script_time()
	this.total_elapsed_script_seconds = os.clock();
end

function this.init_module()
end

return this;