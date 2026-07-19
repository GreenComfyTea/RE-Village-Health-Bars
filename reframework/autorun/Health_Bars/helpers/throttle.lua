local this = {};

local modules = require("Health_Bars.modules");

-- Registry: callback -> { delay, last_execution_time }
local throttle_registry = {};

--- Throttles a callback execution.
--- If enough time has passed since the last execution for this callback, executes immediately.
--- Otherwise, the call and its arguments are silently dropped.
--- @param callback function The function to throttle.
--- @param delay number The minimum time in seconds between executions.
--- @param ... any Arguments to pass to the callback when executed.
function this.throttle(callback, delay, ...)
	if callback == nil or delay == nil then
		return
	end

	local entry = throttle_registry[callback];

	if entry == nil then
		-- First call for this callback: always execute
		entry = {
			delay = delay,
			last_execution_time = 0,
		};
		throttle_registry[callback] = entry;
	end

	-- Update delay (user can change it at runtime)
	entry.delay = delay;

	local now = modules.time.total_elapsed_script_seconds;
	local elapsed = now - entry.last_execution_time;

	if elapsed > entry.delay then
		entry.last_execution_time = now;
		callback(...);
	end
end

--- Removes a throttle entry for a callback.
--- @param callback function The callback to remove.
function this.remove(callback)
	if callback ~= nil then
		throttle_registry[callback] = nil;
	end
end

--- Initializes the module.
function this.init_module()
end

return this;
