---@diagnostic disable: undefined-global

local this = {
    lua_version = _VERSION,
	globals = _G,
	reframework_globals = {
		d2d = d2d,
		draw = draw,
		fs = fs,
		imgui = imgui,
		json = json,
		log = log,
		re = re,
		reframework = reframework,
		sdk = sdk,
		Vector2f = Vector2f,
		Vector3f = Vector3f,
    },
	enemy_handler = {},
    game_handler = {},
    player_handler = {},

    bar_customization = {},
    color_customization = {},
	customization_menu = {},
	label_customization = {},
	offset_customization = {},
	position_customization = {},
	spacing_customization = {},
	world_offset_customization = {},

	drawing = {},
	error_handler = {},
	log = {},
	screen = {},
    singletons = {},
	throttle = {},
	time = {},
	utils = {},

	config = {},
    language = {},
	
    bar = {},
	label = {},
	percentage_label = {},
    value_label = {},
    health_widget = {},
	dynamic_ui = {},
	boss_ui = {},
	ui = {},
};

function this.init_module()
	this.enemy_handler = require("Health_Bars.core.enemy_handler");
    this.game_handler = require("Health_Bars.core.game_handler");
    this.player_handler = require("Health_Bars.core.player_handler");

    this.bar_customization = require("Health_Bars.customization.customizations.bar_customization");
	this.color_customization = require("Health_Bars.customization.customizations.color_customization");
    this.label_customization = require("Health_Bars.customization.customizations.label_customization");
    this.offset_customization = require("Health_Bars.customization.customizations.offset_customization");
    this.position_customization = require("Health_Bars.customization.customizations.position_customization");
	this.spacing_customization = require("Health_Bars.customization.customizations.spacing_customization");
	this.world_offset_customization = require("Health_Bars.customization.customizations.world_offset_customization");
	this.customization_menu = require("Health_Bars.customization.customization_menu");

	this.drawing = require("Health_Bars.helpers.drawing");
    this.error_handler = require("Health_Bars.helpers.error_handler");
	this.log = require("Health_Bars.helpers.log");
	this.screen = require("Health_Bars.helpers.screen");
    this.singletons = require("Health_Bars.helpers.singletons");
	this.throttle = require("Health_Bars.helpers.throttle");
	this.time = require("Health_Bars.helpers.time");
	this.utils = require("Health_Bars.helpers.utils");

	this.language = require("Health_Bars.infrastructure.language");
	this.config = require("Health_Bars.infrastructure.config");
	
	this.bar = require("Health_Bars.ui.0_elements.bar");
	this.label = require("Health_Bars.ui.0_elements.label");
	this.percentage_label = require("Health_Bars.ui.1_components.percentage_label");
	this.value_label = require("Health_Bars.ui.1_components.value_label");
	this.health_widget = require("Health_Bars.ui.2_widgets.health_widget");
	this.dynamic_ui = require("Health_Bars.ui.3_uis.dynamic_ui");
	this.boss_ui = require("Health_Bars.ui.3_uis.boss_ui");
	this.ui = require("Health_Bars.ui.ui");
end

return this;