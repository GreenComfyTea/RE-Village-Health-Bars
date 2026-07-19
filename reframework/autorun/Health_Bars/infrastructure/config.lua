local this = {};

local modules = require("Health_Bars.modules");

local version = "1.3";

this.current_config = nil;
this.config_file_name = tostring(modules.language.default_language.customization_menu.mod_name) .. "/config.json";

this.default_config = {};

function this.init()
	this.default_config = {
		enabled = true,
		
		version = this.version,
		language = "default",

		customization_menu = {
			position = {
				x = 480,
				y = 200
			},

			size = {
				width = 650,
				height = 480
			},

			pivot = {
				x = 0,
				y = 0
			}
		},

		global_modifiers = {
            size_modifier = 1,
			scale_size_modifier_with_resolution = true,
            position_modifier = 1,
			scale_position_modifier_with_resolution = true
		},

		menu_font = {
            size_scale_modifier = 1,
			scale_with_reframework_font_size = true,
		},

		ui_font = {
			dynamic_ui = {
				family = "Consolas",
				bold = true,
				italic = false,
				size_scale_modifier = 1,
				scale_with_reframework_font_size = true,
			},
			boss_ui = {
				family = "Consolas",
				bold = true,
				italic = false,
				size_scale_modifier = 1.75,
				scale_with_reframework_font_size = true,
			}
		},

		settings = {
			timer_delays = {
				update_singletons_delay = 0,
				update_window_size_delay = 0,
				update_game_data_delay = 0.1,
				update_player_data_delay = 0.1,
				update_enemy_data_delay = 0.5,
			},
			
			use_d2d_if_available = true,

			hide_if_no_update_function_is_being_called = true,
		},

		dynamic_ui = {
			visible = true,

			settings = {
				render_during_cutscenes = false,
				render_when_game_timer_is_paused = false,
				render_in_mercenaries = false,
				
				render_in_house_benevientos_basement = false,

				render_aim_target_enemy = true,
				render_damaged_enemies = true,
				render_everyone_else = true,

				render_when_normal = true,
				render_when_aiming = true,
				render_when_using_scope = true,

				hide_if_dead = true,
				hide_if_full_health = true,
				hide_if_enemy_model_is_not_being_rendered = true,
				hide_if_player_cant_take_damage = true,
				hide_if_player_cant_use_items = true,

				hide_urias = false,
				hide_urias_drac = false,
				hide_urias_strajer = false,
				hide_bela = false,
				hide_bela_invincible = true,
				hide_cassandra = false,
				hide_cassandra_invincible = true,
				hide_daniela = false,
				hide_daniela_invincible = true,
				hide_dimitrescu_chasing = true,
				hide_dimitrescu_boss = false,
				hide_angie = true,
				hide_varcolac = false,
				hide_varcolac_alfa = false,
				hide_moreau = false,
				hide_sturm = false,
				hide_heisenberg = false,
				hide_executioner = false,
				hide_miranda = false,
				hide_miranda_in_dlc = false,

				hide_leonardo = false,
				hide_duke = true,

				hide_blue_bird = true,
				hide_pigs = true,
				hide_chickens = true,
				hide_goats = true,
				hide_fish = true,
				hide_catfish = true,
				
				hide_rose_copies = false,
				hide_masked_duke = true,
				hide_mia_dolls = true,
				hide_dolls = true,
				hide_rose_illusion = false,
				hide_miranda_crows = true,
				hide_ethan_dlc = true,

				opacity_falloff = true,
				max_distance = 30,
				scope_opacity_falloff = true,
				scope_max_distance = 300,

				apply_time_duration_on_aiming = false,
				apply_time_duration_on_aim_target = false,
				apply_time_duration_on_using_scope = false,
				apply_time_duration_on_damage_dealt = false,
				reset_time_duration_on_aim_target_for_everyone = true,
				reset_time_duration_on_damage_dealt_for_everyone = true,
				time_duration = 15,
			},

			world_offset = {
				x = 0,
				y = 0.35,
				z = 0
			},

			offset = {
				x = -64,
				y = 0
			},
			
			health = {
                visible = true,
				
				offset = {
					x = 0,
					y = 0
                },
				
				value_label = {
					visible = true,

					settings = {
						alignment = "Top-Right",
					},

					include = {
						current_value = true,
						max_value = true
					},

					offset = {
						x = 123,
						y = 0
					},
					
					color = 0xFFFFFCC0,

					shadow = {
						visible = true,
						offset = {
							x = 1,
							y = 1
						},
						color = 0xFF000000
					}
                },

				percentage_label = {
					visible = false,

					settings = {
						alignment = "Top-Right",
					},

					offset = {
						x = 123,
						y = 39
					},
					
					color = 0xFFFFFCC0,

					shadow = {
						visible = true,
						offset = {
							x = 1,
							y = 1
						},
						color = 0xFF000000
					}
                },
				
				bar = {
					visible = true,

					settings = {
                        fill_direction = "Left to Right",
						inverted = false
					},

					offset = {
						x = 0,
						y = 0
					},

					size = {
						width = 128,
						height = 8
					},

					outline = {
						visible = true,
						thickness = 2.5,
						offset = 0,
						style = "Outside"
					},

                    colors = {
						foreground = 0x80A0FF71,
						background = 0x48000000,
						outline = 0x68000000
					}
				},
			},
		},

		boss_ui = {
			visible = true,
			
            position = {
				x = 0,
                y = 57,
				anchor = "Top-Middle"
            },

			spacing = {
				x = 0,
				y = 64,
			},

			settings = {
				render_during_cutscenes = false,
				render_when_game_timer_is_paused = false,
				render_in_mercenaries = true,

				render_in_house_benevientos_basement = false,

				render_when_normal = true,
				render_when_aiming = true,
				render_when_using_scope = true,

				hide_if_dead = true,
				hide_if_full_health = false,
				hide_if_enemy_model_is_not_being_rendered = false,
				hide_if_player_cant_take_damage = true,
				hide_if_player_cant_use_items = true,

				hide_urias = false,
				hide_urias_drac = false,
				hide_urias_strajer = false,
				hide_bela = false,
				hide_bela_invincible = false,
				hide_cassandra = false,
				hide_cassandra_invincible = false,
				hide_daniela = false,
				hide_daniela_invincible = false,
				hide_dimitrescu_chasing = true,
				hide_dimitrescu_boss = false,
				hide_angie = false,
				hide_varcolac = true,
				hide_varcolac_alfa = false,
				hide_moreau = false,
				hide_sturm = false,
				hide_heisenberg = false,
				hide_executioner = false,
				hide_miranda = false,
				hide_miranda_in_dlc = false,
			},

			name_label = {
				visible = true,

				settings = {
                    alignment = "Center",
				},

				offset = {
					x = 7,
					y = 21
				},
				
				color = 0xFFBCBCC5,

				shadow = {
					visible = true,
					offset = {
						x = 1,
						y = 1
					},
					color = 0xFF000000
				}
            },

			health = {
                visible = true,
				
				offset = {
					x = -405,
					y = 0
                },
				
				value_label = {
					visible = true,

					settings = {
						alignment = "Middle-Right",
					},

					include = {
						current_value = true,
						max_value = true
					},

					offset = {
						x = 802,
						y = 21
					},
					
					color = 0xFFBCBCC5,

					shadow = {
						visible = true,
						offset = {
							x = 1,
							y = 1
						},
						color = 0xFF000000
					}
                },

				percentage_label = {
					visible = false,

					settings = {
						alignment = "Top-Right",
					},

					offset = {
						x = 801,
						y = 39
					},
					
					color = 0xFFBCBCC5,

					shadow = {
						visible = true,
						offset = {
							x = 1,
							y = 1
						},
						color = 0xFF000000
					}
                },
				
				bar = {
					visible = true,

					settings = {
                        fill_direction = "Left to Right",
						inverted = false
					},

					offset = {
						x = 0,
						y = 0
					},

					size = {
						width = 810,
						height = 44
					},

					outline = {
						visible = true,
						thickness = 4.5,
						offset = 0,
						style = "Inside"
					},

                    colors = {
						foreground = 0x80A0FF71,
						background = 0x48000000,
						outline = 0x68000000
					}
				},
			},
		},


		debug = {
			history_size = 64
		}
	};
end

function this.load()
	local loaded_config = modules.reframework_globals.json.load_file(this.config_file_name);
	if loaded_config ~= nil then
		modules.log.info("config.json loaded successfully");
		this.current_config = modules.utils.table.merge(this.default_config, loaded_config);
	else
		modules.log.error("Failed to load config.json");
		this.current_config = modules.utils.table.deep_copy(this.default_config);
	end
end

function this.save()
	-- save current config to disk, replacing any existing file
	local success = modules.reframework_globals.json.dump_file(this.config_file_name, this.current_config);
	if success then
		modules.log.info("config.json saved successfully");
	else
		modules.log.error("Failed to save config.json");
	end
end

function this.reset()
	this.current_config = modules.utils.table.deep_copy(this.default_config);
	this.current_config.version = version;
end

function this.init_module()
	this.init();
	this.load();
	this.current_config.version = version;

	modules.language.update(modules.utils.table.find_index(modules.language.language_names, this.current_config.language));
end

return this;
