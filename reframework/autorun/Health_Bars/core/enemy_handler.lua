local this = {};

local modules = require("Health_Bars.modules");

this.enemy_list = {};
this.enemy_owner_list = {};

local minimal_update_time = 0.6;

local lowest_position = modules.reframework_globals.Vector3f.new(0, -1000000, 0);

local executioner_enemy_core = nil;

local enemy_core_type_def = modules.reframework_globals.sdk.find_type_definition("app.EnemyCore");
local enemy_core_update_method = enemy_core_type_def:get_method("update");
local enemy_core_on_damage_method = enemy_core_type_def:get_method("onDamage"); -- Possible alternative: app.CharacterCore.sendAttackHitResult()
local enemy_core_on_die_method = enemy_core_type_def:get_method("onDie");
local enemy_core_destroy_method = enemy_core_type_def:get_method("destroy");
local enemy_core_get_owner_method = enemy_core_type_def:get_method("get_owner");
local enemy_core_on_warp_method = enemy_core_type_def:get_method("onWarp");
local enemy_core_restart_method = enemy_core_type_def:get_method("restart");
local enemy_core_damage_controller_field = enemy_core_type_def:get_field("DamageController");
local enemy_core_character_status_field = enemy_core_type_def:get_field("CharacterStatus");

local em_1370_core_type_def = modules.reframework_globals.sdk.find_type_definition("app.Em1370.Em1370Core");
local get_stabbed_status_method = em_1370_core_type_def:get_method("get_stabbedStatus");
local update_sub_scenario_num_method = em_1370_core_type_def:get_method("updateSubScenarioNum");
local request_dead_clip_start_method = em_1370_core_type_def:get_method("requestDeadClipStart");

local damage_controller_type_def = enemy_core_damage_controller_field:get_type();
local get_health_method = damage_controller_type_def:get_method("get_health");
local get_max_health_method = damage_controller_type_def:get_method("get_maxHealth");

local enemy_status_type_def = modules.reframework_globals.sdk.find_type_definition("app.EnemyStatus");
local get_is_visible_method = enemy_status_type_def:get_method("get_isVisible");

local game_object_type_def = modules.reframework_globals.sdk.find_type_definition("via.GameObject");
local get_name_method = game_object_type_def:get_method("get_Name");
local get_transform_method = game_object_type_def:get_method("get_Transform");

local transform_type_def = get_transform_method:get_return_type();
local get_joint_by_name_method = transform_type_def:get_method("getJointByName");

local joint_type_def = get_joint_by_name_method:get_return_type();
local get_position_method = joint_type_def:get_method("get_Position");

local em_1260_core_type_def = modules.reframework_globals.sdk.find_type_definition("app.Em1260.Em1260Core");
local my_status_em_1260_field = em_1260_core_type_def:get_field("MyStatus");

local em_1260_status_type_def = modules.reframework_globals.sdk.find_type_definition("app.Em1260.Em1260Status");
local get_is_in_cold_area_method = em_1260_status_type_def:get_method("get_isInColdArea");



-- DLC

-- Executioner Boss
local em_1600_core_type_def = modules.reframework_globals.sdk.find_type_definition("app.Em1600.Em1600Core");
local em_1600_core_on_core_damage_method = em_1600_core_type_def:get_method("onCoreDamage");
local em_1600_core_on_core_die_method = em_1600_core_type_def:get_method("onCoreDie");
local core_list_field = em_1600_core_type_def:get_field("CoreList");

local core_list_type_def = core_list_field:get_type();
local core_list_get_count_method = core_list_type_def:get_method("get_Count");
local core_list_get_item_method = core_list_type_def:get_method("get_Item");

local em_1600_core_controller_type_def = modules.reframework_globals.sdk.find_type_definition("app.Em1600.Em1600CoreController");
local em_1600_core_controller_update_core_method = em_1600_core_controller_type_def:get_method("updateCore");
local em_1600_core_controller_is_permit_open_core_field = em_1600_core_controller_type_def:get_field("<isPermitOpenCore>k__BackingField");
local em_1600_core_controller_is_dead_field = em_1600_core_controller_type_def:get_field("<isDead>k__BackingField");
local em_1600_core_controller_damage_controller_field = em_1600_core_controller_type_def:get_field("DamageController");

function this.get_vital_state_name(index)
	for state_name, state_index in pairs(this.vital_states) do
		if state_index == index then
			return state_name;
		end
	end

	return "None";
end

function this.new(enemy_core)
	local enemy = {};
	enemy.enemy_core = enemy_core;

	enemy.is_initialized = false;

	enemy.health = -1;
	enemy.max_health = -100;
	enemy.health_percentage = 0;
	enemy.is_dead = false;

	enemy.is_dimitrescu_daughter_in_cold_area = false;
	enemy.angie_stabbed_count = 0;


	enemy.is_visible = false;
	enemy.is_filtered_out = false;
	enemy.is_boss_filtered_out = false;

	enemy.position = lowest_position;
	enemy.distance = 0;

	enemy.first_update_time = 0;
	enemy.last_reset_time = 0;
	enemy.last_update_time = 0;

	enemy.owner = nil;

	enemy.type = enemy.enemy_core:get_type_definition():get_name();

	enemy.is_duke = enemy.type == "Em4070Core"; -- works normally
	
	enemy.is_urias_type = enemy.type == "Em1060Core"; -- works normally
	enemy.is_leonardo = enemy.type == "Em1360Core";
	enemy.is_dimitrescu_daughter_type = enemy.type == "Em1260Core";
	enemy.is_dimitrescu = enemy.type == "Em1000Core";
	enemy.is_dimitrescu_boss = enemy.type == "Em1230Core";
	enemy.is_angie = enemy.type == "Em1370Core";
	enemy.is_baby = enemy.type == "Em1380Core";
	enemy.is_varcolac_type = enemy.type == "Em1280Core";
	enemy.is_mutated_moreau = enemy.type == "Em1301Core"; -- no coordinates
	enemy.is_moreau_boss = enemy.type == "Em1302Core";
	enemy.is_sturm = enemy.type == "Em1040Core"; -- works normally
	enemy.is_heisenberg_boss = enemy.type == "Em1310Core";
	enemy.is_miranda_boss = enemy.type == "Em1320Core";

	enemy.is_blue_bird = enemy.type == "Em3000Core";
	enemy.is_pig = enemy.type == "Em3020Core";
	enemy.is_chicken = enemy.type == "Em3070Core";
	enemy.is_goat = enemy.type == "Em3080Core";
	enemy.is_fish = enemy.type == "Em3090Core";
	enemy.is_catfish = enemy.type == "Em3100Core";

	enemy.is_k = enemy.type == "Em4470Core";
	enemy.is_rose_copy = enemy.type == "Em4440Core";
	enemy.is_masked_duke = enemy.type == "Em4450Core";
	enemy.is_executioner = enemy.type == "Em1600Core";
	enemy.is_mia_doll = enemy.type == "Em1400Core";
	enemy.is_doll = enemy.type == "Em1390Core";
	enemy.is_eveline = enemy.type == "Em1800Core";
	enemy.is_eveline_doll = enemy.type == "Em1810Core";
	enemy.is_miranda_crow = enemy.type == "Em3002Core";
	enemy.is_rose_illusion = enemy.type == "Em4490Core";
	enemy.is_miranda_boss_dlc = enemy.type == "Em1900Core";
	enemy.is_ethan_dlc = enemy.type == "Em4460Core";

	enemy.is_urias = false;
	enemy.is_urias_drac = false;
	enemy.is_urias_strajer = false;

	enemy.is_bela = false;
	enemy.is_cassandra = false;
	enemy.is_daniela = false;

	enemy.is_varcolac = false;
	enemy.is_varcolac_alfa = false;

	enemy.is_always_visible =
		enemy.is_dimitrescu_boss
		-- or enemy.is_angie
		-- or enemy.is_baby
		-- or enemy.is_mutated_moreau
		or enemy.is_moreau_boss
		or enemy.is_heisenberg_boss
		or enemy.is_miranda_boss
		
		or enemy.is_blue_bird
		or enemy.is_pig
		or enemy.is_chicken
		or enemy.is_goat
		or enemy.is_fish
		or enemy.is_catfish

		or enemy.is_k
		or enemy.is_rose_copy
		or enemy.is_masked_duke
		or enemy.is_executioner
		or enemy.is_mia_doll
		or enemy.is_doll
		or enemy.is_eveline
		or enemy.is_miranda_crow
		or enemy.is_rose_illusion
		or enemy.is_miranda_boss_dlc
		or enemy.is_ethan_dlc
		or enemy.is_miranda_boss_dlc;

	this.update_health(enemy);

	if enemy.health == -1 or enemy.max_health == -1 then
		return nil;
	end

	this.update_owner(enemy);
	this.update_urias_type(enemy)
	this.update_dimitrescu_daughter_type(enemy);
	this.update_varcolac_type(enemy);
	this.update_head_joint(enemy);
	this.update_position(enemy);
	this.update_is_visible(enemy);
	this.update_is_filtered_out(enemy);
	this.update_is_boss_filtered_out(enemy);
	this.update_angie_stabbed_count(enemy);

	enemy.is_boss =
		enemy.is_urias
		or enemy.is_urias_drac
		or enemy.is_urias_strajer
		or enemy.is_dimitrescu_daughter_type
		or enemy.is_bela
		or enemy.is_cassandra
		or enemy.is_daniela
		or enemy.is_dimitrescu
		or enemy.is_dimitrescu_boss
		or enemy.is_angie
		or enemy.is_varcolac
		or enemy.is_varcolac_alfa
		or enemy.is_moreau_boss
		or enemy.is_sturm
		or enemy.is_heisenberg_boss
		or enemy.is_executioner
		or enemy.is_miranda_boss
		or enemy.is_miranda_boss_dlc;

		enemy.is_scripted_death_boss =
			enemy.is_dimitrescu
			or enemy.is_dimitrescu_boss
			or enemy.is_moreau_boss
			or enemy.is_heisenberg_boss;

	this.enemy_list[enemy_core] = enemy;
	
	return enemy;
end

function this.get_enemy(enemy_core)
	local enemy = this.enemy_list[enemy_core];
	if enemy == nil then
		enemy = this.new(enemy_core);
	end
	
	return enemy;
end

function this.get_enemy_null(enemy_core, create_if_not_found)
	if create_if_not_found == nil then
		create_if_not_found = true;
	end

	local enemy = this.enemy_list[enemy_core];
	if enemy == nil and create_if_not_found then
		enemy = this.new(enemy_core);
	end

	return enemy;
end

function this.update_health(enemy)
	if enemy == nil then
		modules.error_handler.report("enemy.update_health", "No Enemy");
		return;
	end

	if enemy.is_executioner then
		local is_core = this.update_core_health_executioner(enemy);
		
		if is_core then
			return;
		end
	end

	local damage_controller = enemy_core_damage_controller_field:get_data(enemy.enemy_core);

	if damage_controller == nil then
		modules.error_handler.report("enemy.update_health", "No EnemyDamageController");
		return;
	end

	local health = get_health_method:call(damage_controller);
	local max_health = get_max_health_method:call(damage_controller);

	if health == nil then
		modules.error_handler.report("enemy.update_health", "No Health");
	else
		enemy.health = modules.utils.math.round(health);
	end

	if max_health == nil then
		modules.error_handler.report("enemy.update_health", "No MaxHealth");
	else
		enemy.max_health = modules.utils.math.round(max_health);
	end

	if enemy.max_health == 0 then
		enemy.health_percentage = 0;
	else
		enemy.health_percentage = enemy.health / enemy.max_health;
	end

	if enemy.is_boss and not enemy.is_scripted_death_boss and enemy.health < 1.1 then
		enemy.is_dead = true;
	end
end

function this.update_core_health_executioner(enemy)
	local is_core = false;

	local core_list = core_list_field:get_data(enemy.enemy_core);

	if core_list == nil then
		modules.error_handler.report("enemy.update_core_health_executioner", "No Core List");
		return is_core;
	end

	local core_list_count = core_list_get_count_method:call(core_list);

	if core_list_count == nil then
		modules.error_handler.report("enemy.update_core_health_executioner", "No Core List Count");
		return is_core;
	end

	if core_list_count == 0 then
		return is_core;
	end

	for i = 0, core_list_count - 1 do
		local core = core_list_get_item_method:call(core_list, i);

		if core == nil then
			modules.error_handler.report("enemy.update_core_health_executioner", string.format("No Core No. %d", i));
			goto continue;
		end
		
		local is_permit_open_core = em_1600_core_controller_is_permit_open_core_field:get_data(core);
		
		if is_permit_open_core == nil then
			modules.error_handler.report("enemy.update_core_health_executioner", string.format("No Core No. %d -> is_permit_open_core", i));
			goto continue;
		end

		if not is_permit_open_core then
			goto continue;
		end

		local is_dead = em_1600_core_controller_is_dead_field:get_data(core);
		
		if is_dead == nil then
			modules.error_handler.report("enemy.update_core_health_executioner", string.format("No Core No. %d -> is_dead", i));
			goto continue;
		end

		if is_dead then
			goto continue;
		end

		local damage_controller = em_1600_core_controller_damage_controller_field:get_data(core);

		if damage_controller == nil then
			modules.error_handler.report("enemy.update_core_health_executioner", string.format("No Core No. %d -> Damage Controller", i));
			goto continue;
		end

		local health = get_health_method:call(damage_controller);
		local max_health = get_max_health_method:call(damage_controller);

		if health == nil then
			modules.error_handler.report("enemy.update_core_health_executioner", string.format("No Core No. %d -> Health", i));
		else
			enemy.health = modules.utils.math.round(health);
		end

		if max_health == nil then
			modules.error_handler.report("enemy.update_core_health_executioner", string.format("No Core No. %d -> Max Health", i));
		else
			enemy.max_health = modules.utils.math.round(max_health);
		end

		if enemy.max_health == 0 then
			enemy.health_percentage = 0;
		else
			enemy.health_percentage = enemy.health / enemy.max_health;
		end

		is_core = true;
		break;

		::continue::
	end

	return is_core;
end

function this.update_is_visible(enemy)
	if enemy == nil then
		modules.error_handler.report("enemy.is_visible", "No Enemy");
		return;
	end

	local character_status = enemy_core_character_status_field:get_data(enemy.enemy_core);

	if character_status == nil then
		modules.error_handler.report("enemy.is_visible", "No EnemyCharacterStatus");
		return;
	end

	local is_visible = get_is_visible_method:call(character_status);

	if is_visible == nil then
		modules.error_handler.report("enemy.is_visible", "No IsVisible");
		return;
	end

	enemy.is_visible = is_visible;
end

function this.update_is_filtered_out(enemy)
	local cached_config = modules.config.current_config.dynamic_ui.settings;

	enemy.is_filtered_out =
		(cached_config.hide_urias and enemy.is_urias)
		or (cached_config.hide_urias_drac and enemy.is_urias_drac)
		or (cached_config.hide_urias_strajer and enemy.is_urias_strajer)
		or (cached_config.hide_bela and enemy.is_bela and enemy.is_dimitrescu_daughter_in_cold_area)
		or (cached_config.hide_bela_invincible and enemy.is_bela and not enemy.is_dimitrescu_daughter_in_cold_area)
		or (cached_config.hide_cassandra and enemy.is_cassandra and enemy.is_dimitrescu_daughter_in_cold_area)
		or (cached_config.hide_cassandra_invincible and enemy.is_cassandra and not enemy.is_dimitrescu_daughter_in_cold_area)
		or (cached_config.hide_daniela and enemy.is_daniela and enemy.is_dimitrescu_daughter_in_cold_area)
		or (cached_config.hide_daniela_invincible and enemy.is_daniela and not enemy.is_dimitrescu_daughter_in_cold_area)
		or (cached_config.hide_dimitrescu_chasing and enemy.is_dimitrescu)
		or (cached_config.hide_dimitrescu_boss and enemy.is_dimitrescu_boss)
		or (cached_config.hide_angie and enemy.is_angie)
		or (cached_config.hide_varcolac and enemy.is_varcolac)
		or (cached_config.hide_varcolac_alfa and enemy.is_varcolac_alfa)
		or (cached_config.hide_moreau and enemy.is_moreau_boss)
		or (cached_config.hide_sturm and enemy.is_sturm)
		or (cached_config.hide_heisenberg and enemy.is_heisenberg_boss)
		or (cached_config.hide_executioner and enemy.is_executioner)
		or (cached_config.hide_miranda and enemy.is_miranda_boss)
		or (cached_config.hide_miranda_in_dlc and enemy.is_miranda_boss_dlc)
		or (cached_config.hide_leonardo and enemy.is_leonardo)
		or (cached_config.hide_duke and enemy.is_duke)
		or (cached_config.hide_blue_bird and enemy.is_blue_bird)
		or (cached_config.hide_pigs and enemy.is_pig)
		or (cached_config.hide_chickens and enemy.is_chicken)
		or (cached_config.hide_goats and enemy.is_goat)
		or (cached_config.hide_fish and enemy.is_fish)
		or (cached_config.hide_catfish and enemy.is_catfish)
		or (cached_config.hide_rose_copies and enemy.is_rose_copy)
		or (cached_config.hide_masked_duke and enemy.is_masked_duke)
		or (cached_config.hide_mia_dolls and enemy.is_mia_doll)
		or (cached_config.hide_dolls and enemy.is_doll)
		or (cached_config.hide_rose_illusion and enemy.is_rose_illusion)
		or (cached_config.hide_miranda_crows and enemy.is_miranda_crow)
		or (cached_config.hide_ethan_dlc and enemy.is_ethan_dlc);
end

function this.update_is_boss_filtered_out(enemy)
	local cached_config = modules.config.current_config.boss_ui.settings;

	enemy.is_boss_filtered_out =
		(cached_config.hide_urias and enemy.is_urias)
		or (cached_config.hide_urias_drac and enemy.is_urias_drac)
		or (cached_config.hide_urias_strajer and enemy.is_urias_strajer)
		or (cached_config.hide_bela and enemy.is_bela and enemy.is_dimitrescu_daughter_in_cold_area)
		or (cached_config.hide_bela_invincible and enemy.is_bela and not enemy.is_dimitrescu_daughter_in_cold_area)
		or (cached_config.hide_cassandra and enemy.is_cassandra and enemy.is_dimitrescu_daughter_in_cold_area)
		or (cached_config.hide_cassandra_invincible and enemy.is_cassandra and not enemy.is_dimitrescu_daughter_in_cold_area)
		or (cached_config.hide_daniela and enemy.is_daniela and enemy.is_dimitrescu_daughter_in_cold_area)
		or (cached_config.hide_daniela_invincible and enemy.is_daniela and not enemy.is_dimitrescu_daughter_in_cold_area)
		or (cached_config.hide_dimitrescu_chasing and enemy.is_dimitrescu)
		or (cached_config.hide_dimitrescu_boss and enemy.is_dimitrescu_boss)
		or (cached_config.hide_angie and enemy.is_angie)
		or (cached_config.hide_varcolac and enemy.is_varcolac)
		or (cached_config.hide_varcolac_alfa and enemy.is_varcolac_alfa)
		or (cached_config.hide_moreau and enemy.is_moreau_boss)
		or (cached_config.hide_sturm and enemy.is_sturm)
		or (cached_config.hide_heisenberg and enemy.is_heisenberg_boss)
		or (cached_config.hide_executioner and enemy.is_executioner)
		or (cached_config.hide_miranda and enemy.is_miranda_boss)
		or (cached_config.hide_miranda_in_dlc and enemy.is_miranda_boss_dlc)
		or (not enemy.is_boss);
end

function this.update_dimitrescu_daughter(enemy)
	if enemy == nil then
		modules.error_handler.report("enemy.update_dimitrescu_daughter", "No Enemy");
		return;
	end

	if not enemy.is_dimitrescu_daughter_type then
		return;
	end

	local em_1260_status = my_status_em_1260_field:get_data(enemy.enemy_core);
	if em_1260_status == nil then
		modules.error_handler.report("enemy.update_dimitrescu_daughter", "No em1260Status");
		return;
	end

	local is_in_cold_area = get_is_in_cold_area_method:call(em_1260_status);
	if is_in_cold_area == nil then
		modules.error_handler.report("enemy.update_dimitrescu_daughter", "No IsInColdArea");
		return;
	end

	enemy.is_dimitrescu_daughter_in_cold_area = is_in_cold_area;
end

function this.update_last_reset_time(enemy)
	if enemy == nil then
		modules.error_handler.report("enemy.update_last_reset_time", "No Enemy");
		return;
	end
	
	enemy.last_reset_time = modules.time.total_elapsed_script_seconds;
end

function this.update_all_positions()
	for enemy_core, enemy in pairs(this.enemy_list) do
		this.update_head_joint(enemy);
		this.update_position(enemy);
	end
end

function this.update_position(enemy)
	if enemy.head_joint == nil then
		modules.error_handler.report("enemy_handler.update_position", "No Head Joint");
		return;
	end

	local head_joint_position = get_position_method:call(enemy.head_joint);
	if head_joint_position == nil then
		modules.error_handler.report("enemy_handler.update_position", "No Head Joint Position");
		return;
	end

	enemy.position = head_joint_position;
	enemy.distance = (modules.player_handler.player.position - head_joint_position):length();
end

function this.update_all_periodics()
	local cached_config = modules.config.current_config.settings.timer_delays;

	for enemy_core, enemy in pairs(this.enemy_list) do
		if modules.config.current_config.settings.hide_if_no_update_function_is_being_called and modules.time.total_elapsed_script_seconds - enemy.last_update_time > cached_config.update_enemy_data_delay then
			this.enemy_list[enemy_core] = nil;

			for enemy_owner, enemy_in_enemy_owner_list in pairs(this.enemy_owner_list) do
				if enemy_in_enemy_owner_list == enemy or (type(enemy_in_enemy_owner_list) == "table" and enemy_in_enemy_owner_list.enemy_core == enemy_core) then
					this.enemy_owner_list[enemy_owner] = nil;
				end
			end

			goto continue;
		end

		this.update_is_visible(enemy);
		this.update_dimitrescu_daughter(enemy);
		this.update_is_filtered_out(enemy);
		this.update_is_boss_filtered_out(enemy);
	
		::continue::
	end
end

function this.update_head_joint(enemy)
	if enemy.owner == nil then
		modules.error_handler.report("enemy_handler.update_head_joint", "No GameObject");
		return;
	end

	local enemy_transform = get_transform_method:call(enemy.owner);
	if enemy_transform == nil then
		modules.error_handler.report("enemy_handler.update_head_joint", "No Transform");
		return;
	end

	local joint = get_joint_by_name_method:call(enemy_transform, "Head_Human")
	or get_joint_by_name_method:call(enemy_transform, "HumanHead")
	or get_joint_by_name_method:call(enemy_transform, "Head")
	or get_joint_by_name_method:call(enemy_transform, "head")
	or get_joint_by_name_method:call(enemy_transform, "root");

	if joint == nil then
		modules.error_handler.report("enemy_handler.update_head_joint", "No Head Joint");
		return;
	end

	enemy.head_joint = joint;
end

function this.update_owner(enemy)
	if enemy == nil then
		modules.error_handler.report("enemy.update_owner", "No Enemy");
		return;
	end

	local owner = enemy_core_get_owner_method:call(enemy.enemy_core);

	if owner == nil then
		modules.error_handler.report("enemy.update_owner", "No Enemy Owner");
		return;
	end

	enemy.owner = owner;

	this.enemy_owner_list[owner] = enemy;
end

function this.update_urias_type(enemy)
	if enemy == nil then
		modules.error_handler.report("enemy.update_urias_type", "No Enemy");
		return;
	end

	if not enemy.is_urias_type then
		return;
	end

	if enemy.owner == nil then
		modules.error_handler.report("enemy.update_urias_type", "No Enemy Owner");
		return;
	end

	local owner_name = get_name_method:call(enemy.owner);
	if owner_name == nil then
		modules.error_handler.report("enemy.update_urias_type", "No Enemy Owner Name");
		return;
	end

	if owner_name == "em1060" then
		enemy.is_urias = true;
	elseif owner_name == "em1061" then
		enemy.is_urias_strajer = true;
	elseif owner_name == "em1062" then
		enemy.is_urias_drac = true;
	end
end

function this.update_dimitrescu_daughter_type(enemy)
	if enemy == nil then
		modules.error_handler.report("enemy.update_dimitrescu_daughter_type", "No Enemy");
		return;
	end

	if not enemy.is_dimitrescu_daughter_type then
		return;
	end

	if enemy.owner == nil then
		modules.error_handler.report("enemy.update_dimitrescu_daughter_type", "No Enemy Owner");
		return;
	end

	local owner_name = get_name_method:call(enemy.owner);
	if owner_name == nil then
		modules.error_handler.report("enemy.update_dimitrescu_daughter_type", "No Enemy Owner Name");
		return;
	end

	if owner_name == "em1260" then
		enemy.is_daniela = true;
	elseif owner_name == "em1261" then
		enemy.is_cassandra = true;
	elseif owner_name == "em1262" then
		enemy.is_bela = true;
	end
end

function this.update_varcolac_type(enemy)
	if enemy == nil then
		modules.error_handler.report("enemy.update_varcolac_type", "No Enemy");
		return;
	end

	if not enemy.is_varcolac_type then
		return;
	end

	if enemy.owner == nil then
		modules.error_handler.report("enemy.update_varcolac_type", "No Enemy Owner");
		return;
	end

	local owner_name = get_name_method:call(enemy.owner);
	if owner_name == nil then
		modules.error_handler.report("enemy.update_varcolac_type", "No Enemy Owner Name");
		return;
	end

	if owner_name == "em1280" then
		enemy.is_varcolac = true;
	elseif owner_name == "em1281" then
		enemy.is_varcolac_alfa = true;
	end
end

function this.update_angie_stabbed_count(enemy)
	if enemy == nil then
		modules.error_handler.report("enemy.update_angie_stabbed_count", "No Enemy");
		return;
	end

	if not enemy.is_angie then
		return;
	end

	local stabbed_status = get_stabbed_status_method:call(enemy.enemy_core);
	if stabbed_status == nil then
		modules.error_handler.report("enemy.update_angie_stabbed_count", "No Stabbed Status");
		return;
	end

	enemy.angie_stabbed_count = math.max(1, stabbed_status) - 1;
	if enemy.angie_stabbed_count == 3 then
		enemy.is_dead = true;
	end
end

function this.update_angie_core_stabbed_count(enemy_core)
	if enemy_core == nil then
		modules.error_handler.report("enemy.update_angie_core_stabbed_count", "No EnemyCore");
		return;
	end

	local enemy = this.get_enemy(enemy_core);
	if enemy == nil then
		return;
	end

	this.update_angie_stabbed_count(enemy);
end

function this.on_angie_core_request_dead_clip_start(enemy_core)
	if enemy_core == nil then
		modules.error_handler.report("enemy.increase_angie_stabbed_count", "No EnemyCore");
		return;
	end

	local enemy = this.get_enemy(enemy_core);
	if enemy == nil then
		return;
	end

	enemy.is_dead = true;
end

function this.on_update(enemy_core)
	if enemy_core == nil then
		modules.error_handler.report("enemy.on_enemy_update", "No EnemyCore");
		return;
	end

	local enemy = this.get_enemy(enemy_core);
	if enemy == nil then
		return;
	end

	if modules.utils.number.is_equal(enemy.first_update_time, 0) then
		enemy.first_update_time = modules.time.total_elapsed_script_seconds;
	end

	enemy.last_update_time = modules.time.total_elapsed_script_seconds;

	if enemy.last_update_time - enemy.first_update_time > minimal_update_time then
		enemy.is_initialized = true;
	end
end

function this.on_damage(attacked_enemy_core)
	local cached_config = modules.config.current_config.settings;

	if attacked_enemy_core == nil then
		modules.error_handler.report("enemy.on_damage", "No EnemyCore");
		return;
	end

	local attacked_enemy = this.get_enemy(attacked_enemy_core);

	if attacked_enemy == nil then
		return;
	end

	this.update_health(attacked_enemy);

	if cached_config.reset_time_duration_on_damage_dealt_for_everyone then
		for enemy_core, enemy in pairs(this.enemy_list) do
			if modules.time.total_elapsed_script_seconds - enemy.last_reset_time < cached_config.time_duration then
				this.update_last_reset_time(enemy);
			end
		end
	end
	
	if cached_config.apply_time_duration_on_damage_dealt then
		this.update_last_reset_time(attacked_enemy);
	end
end

function this.on_die(enemy_core)
	if enemy_core == nil then
		modules.error_handler.report("enemy.on_die", "No EnemyCore");
		return;
	end

	local enemy = this.get_enemy(enemy_core);

	if enemy == nil then
		return;
	end

	this.update_health(enemy);
	enemy.is_dead = true;
end

function this.on_core_damage_executioner(attacked_enemy_core)
	local cached_config = modules.config.current_config.settings;

	if attacked_enemy_core == nil then
		modules.error_handler.report("enemy.on_core_damage_executioner", "No EnemyCore");
		return;
	end

	local attacked_enemy = this.get_enemy(attacked_enemy_core);

	if attacked_enemy == nil then
		return;
	end

	this.update_health(attacked_enemy);

	if cached_config.reset_time_duration_on_damage_dealt_for_everyone then
		for enemy_core, enemy in pairs(this.enemy_list) do
			if modules.time.total_elapsed_script_seconds - enemy.last_reset_time < cached_config.time_duration then
				this.update_last_reset_time(enemy);
			end
		end
	end
	
	if cached_config.apply_time_duration_on_damage_dealt then
		this.update_last_reset_time(attacked_enemy);
	end
end

function this.on_post_core_die_executioner(enemy_core)
	if enemy_core == nil then
		modules.error_handler.report("enemy.on_post_core_die_executioner", "No EnemyCore");
		return;
	end

	local enemy = this.get_enemy(enemy_core);

	if enemy == nil then
		return;
	end

	this.update_health(enemy);
end

function this.on_update_core_executioner(core_controller)
	if core_controller == nil then
		modules.error_handler.report("enemy.on_open_core_executioner", "No CoreController");
		return;
	end

	local core_controller_owner = core_controller:get_owner();

	if core_controller_owner == nil then
		modules.error_handler.report("enemy.on_open_core_executioner", "No CoreControllerOwner");
		return;
	end

	local attacked_enemy_core = this.enemy_owner_list[core_controller_owner];

	if attacked_enemy_core == nil then
		modules.error_handler.report("enemy.on_open_core_executioner", "No Attacked EnemyCore");
		return;
	end

	this.update_health(attacked_enemy_core);
end

function this.on_warp(enemy_core)
	if enemy_core == nil then
		modules.error_handler.report("enemy.on_warp", "No Enemy core");
		return;
	end

	local enemy = this.get_enemy_null(enemy_core, false);

	if enemy == nil then
		return;
	end

	if enemy.is_boss and not enemy.is_scripted_death_boss then
		if enemy.health < 1.1 then
			enemy.is_dead = true;
		end

		return;
	end

	this.update_health(enemy);
	enemy.is_dead = modules.utils.number.is_equal(enemy.health, 0);
end

function this.on_restart(enemy_core)
	if enemy_core == nil then
		modules.error_handler.report("enemy.on_restart", "No Enemy core");
		return;
	end

	local enemy = this.get_enemy(enemy_core);

	if enemy == nil then
		return;
	end

	if enemy.is_boss and not enemy.is_scripted_death_boss then
		if enemy.health < 1.1 then
			enemy.is_dead = true;
		end

		return;
	end

	this.update_health(enemy);
	enemy.is_dead = modules.utils.number.is_equal(enemy.health, 0);
end

function this.on_destroy(enemy_core)
	if enemy_core == nil then
		modules.error_handler.report("enemy.on_destroy", "No EnemyCore");
		return;
	end

	local destroyed_enemy = this.enemy_list[enemy_core];

	this.enemy_list[enemy_core] = nil;

	for enemy_owner, enemy in pairs(this.enemy_owner_list) do
		if enemy == destroyed_enemy or (type(enemy) == "table" and enemy.enemy_core == enemy_core) then
			this.enemy_owner_list[enemy_owner] = nil;
		end
	end
end

function this.init_module()
	modules.reframework_globals.sdk.hook(enemy_core_update_method, function(args)
		local enemy_core = modules.reframework_globals.sdk.to_managed_object(args[2]);
		
		this.on_update(enemy_core);
	end, function(retval)
		return retval;
	end);

	modules.reframework_globals.sdk.hook(enemy_core_on_damage_method, function(args)
		local enemy_core = modules.reframework_globals.sdk.to_managed_object(args[2]);
		
		this.on_damage(enemy_core);
	end, function(retval)
		return retval;
	end);

	modules.reframework_globals.sdk.hook(enemy_core_on_die_method, function(args)
		local enemy_core = modules.reframework_globals.sdk.to_managed_object(args[2]);
		
		this.on_die(enemy_core);
	end, function(retval)
		return retval;
	end);

	modules.reframework_globals.sdk.hook(enemy_core_on_warp_method, function(args)
		local enemy_core = modules.reframework_globals.sdk.to_managed_object(args[2]);
		
		this.on_warp(enemy_core);
	end, function(retval)
		return retval;
	end);

	modules.reframework_globals.sdk.hook(enemy_core_restart_method, function(args)
		local enemy_core = modules.reframework_globals.sdk.to_managed_object(args[2]);
		
		this.on_restart(enemy_core);
	end, function(retval)
		return retval;
	end);

	modules.reframework_globals.sdk.hook(enemy_core_destroy_method, function(args)
		local enemy_core = modules.reframework_globals.sdk.to_managed_object(args[2]);
		
		this.on_destroy(enemy_core);
	end, function(retval)
		return retval;
	end);

	-- DLC

	modules.reframework_globals.sdk.hook(em_1600_core_on_core_damage_method, function(args)
		local enemy_core = modules.reframework_globals.sdk.to_managed_object(args[2]);
		
		this.on_core_damage_executioner(enemy_core);
	end, function(retval)
		return retval;
	end);

	modules.reframework_globals.sdk.hook(em_1600_core_on_core_die_method, function(args)
		local enemy_core = modules.reframework_globals.sdk.to_managed_object(args[2]);
		
		executioner_enemy_core = enemy_core;
	end, function(retval)
		this.on_post_core_die_executioner(executioner_enemy_core);
		
		return retval;
	end);

	modules.reframework_globals.sdk.hook(em_1600_core_controller_update_core_method, function(args)
		local core_controller = modules.reframework_globals.sdk.to_managed_object(args[2]);
		
		this.on_update_core_executioner(core_controller);
	end, function(retval)
		return retval;
	end);

	modules.reframework_globals.sdk.hook(update_sub_scenario_num_method, function(args)
		local enemy_core = modules.reframework_globals.sdk.to_managed_object(args[2]);
		
		this.update_angie_core_stabbed_count(enemy_core);
	end, function(retval)
		return retval;
	end);

	modules.reframework_globals.sdk.hook(request_dead_clip_start_method, function(args)
		local enemy_core = modules.reframework_globals.sdk.to_managed_object(args[2]);
		
		this.on_angie_core_request_dead_clip_start(enemy_core);
	end, function(retval)
		return retval;
	end);
end

return this;
