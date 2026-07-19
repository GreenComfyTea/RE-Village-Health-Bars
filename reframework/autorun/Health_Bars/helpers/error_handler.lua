local this = {};

local modules = require("Health_Bars.modules");

this.list = {};
this.is_empty = true;

this.history = {};

function this.report(error_key, error_message)
	if error_key == nil or error_key == ""
	or error_message == nil or error_message == "" then
		return;
	end

	local error_time = modules.time.total_elapsed_script_seconds;

	if modules.utils.number.is_equal(error_time, 0) then
		return;
	end

	local error = {
		key = error_key,
		time = error_time,
		message = error_message
	};

	this.list[error_key] = error;
	this.is_empty = false;

	this.add_to_history(error_key, error);
end

function this.add_to_history(error_key, error)
	this.clear_history();

	table.insert(this.history, error);
end

function this.clear_history()
	local history_size = modules.config.current_config.debug.history_size;

	while #this.history >= history_size do
		table.remove(this.history, 1);
	end
end

function this.init_module()
end

return this;