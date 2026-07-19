local this = {};

local modules = require("Health_Bars.modules");

function this.info(text)
    modules.reframework_globals.log.info("[" .. tostring(modules.language.default_language.customization_menu.mod_name) .."] " .. tostring(text));
end

function this.warn(text)
    modules.reframework_globals.log.warn("[" .. tostring(modules.language.default_language.customization_menu.mod_name) .."] " .. tostring(text));
end

function this.debug(text)
    modules.reframework_globals.log.debug("[" .. tostring(modules.language.default_language.customization_menu.mod_name) .."] " .. tostring(text));
end

function this.error(text)
    modules.reframework_globals.log.error("[" .. tostring(modules.language.default_language.customization_menu.mod_name) .."] " .. tostring(text));
end

function this.init_module()
end

return this;