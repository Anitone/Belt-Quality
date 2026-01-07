--local Data = require("__stdlib2__/stdlib/data/data")
local serpent = require("serpent")
local scaling_factor = settings.startup["conveyor-speed-scaling-factor"].value/100
belt_types = {}
underground_belt_types = {}
splitter_types = {}
loader_types = {}
global_things = {}
for _,i in pairs(data.raw["transport-belt"]) do
	--log(i.name)
	if i.name then
		table.insert(belt_types,i.name)
		table.insert(global_things,i.name)
	end
end
for _,i in pairs(data.raw["underground-belt"]) do
	--log(i.name)
	if i.name then
		table.insert(underground_belt_types,i.name)
		table.insert(global_things,i.name)
	end
end
for _,i in pairs(data.raw["splitter"]) do
	--log(i.name)
	if i.name then
		table.insert(splitter_types,i.name)
		table.insert(global_things,i.name)
	end
end
if data.raw["loader-1x1"] then	
	--log(serpent.block(data.raw["loader-1x1"]))
	for _,i in pairs(data.raw["loader-1x1"]) do
		--log(i.name)
		if i.name then
			table.insert(loader_types,i.name)
			table.insert(global_things,i.name)
		end
	end
end
--log("All belt things:"..serpent.block(global_things))
local function create_transport_prototypes(belt_types)
	for _,belt_name in ipairs(belt_types) do
		local base_belt = data.raw["transport-belt"][belt_name]
		local base_belt_item = data.raw["item"][belt_name]
		
		for _,q in pairs(data.raw["quality"]) do
			if q.name == "quality-unknown" then
	
			else
				if q.level > 0 then	
					local tbelt = table.deepcopy(base_belt)
					tbelt.localised_name =  {"entity-name."..tbelt.name}
					tbelt.name = tbelt.name.."-quality-"..q.level
					if settings.startup["enable-conveyor-speed-scaling"].value == true then
						tbelt.speed = tbelt.speed * (q.level*scaling_factor+1)
					else
						tbelt.speed = tbelt.speed
					end
					tbelt.localised_description = q.name
					if not settings.startup["mqs-belt-changes"] or not settings.startup["mqs-belt-changes"].value then
						data:extend{tbelt}
					end
					local tbelt_item = {
						type = "item",
						name = tbelt.name,
						localised_name = tbelt.localised_name,
						icon = base_belt_item.icon,
						icon_size = base_belt_item.icon_size,
						order = base_belt_item.order.."-quality-"..q.level,
						stack_size = base_belt_item.stack_size,
						place_result = tbelt.name
					}
					if settings.startup["mqs-belt-changes"] and settings.startup["mqs-belt-changes"].value then
						tbelt_item.name = q.name.."-"..belt_name
						tbelt_item.place_result = q.name.."-"..belt_name
						data:extend{tbelt_item}
					else
						data:extend{tbelt_item}
					end
				end
				--log("[Belt Quality] Created transport belt prototype: Quality: "..q.name.." Name: "..tbelt.name)
			end
		end
	end
end
local function create_underground_prototypes(underground_belt_types)
	for _,belt_name in ipairs(underground_belt_types) do
		local base_belt = data.raw["underground-belt"][belt_name]
		local base_belt_item = data.raw["item"][belt_name]
		
		for _,q in pairs(data.raw["quality"]) do
			if q.name == "quality-unknown" then
	
			else
				if q.level > 0 then	
					local tbelt = table.deepcopy(base_belt)
					tbelt.localised_name =  {"entity-name."..tbelt.name}
					tbelt.name = tbelt.name.."-quality-"..q.level
					if settings.startup["enable-conveyor-speed-scaling"].value == true then
						tbelt.speed = tbelt.speed * (q.level*scaling_factor+1)
					else
						tbelt.speed = tbelt.speed
					end
					tbelt.localised_description = q.name
					if not settings.startup["mqs-belt-changes"] or not settings.startup["mqs-belt-changes"].value then
						data:extend{tbelt}
					end
					local tbelt_item = {
						type = "item",
						name = tbelt.name,
						localised_name = tbelt.localised_name,
						icon = base_belt_item.icon,
						icon_size = base_belt_item.icon_size,
						order = base_belt_item.order.."-quality-"..q.level,
						stack_size = base_belt_item.stack_size,
						place_result = tbelt.name
					}
					if settings.startup["mqs-belt-changes"] and settings.startup["mqs-belt-changes"].value then
						tbelt_item.name = q.name.."-"..belt_name
						tbelt_item.place_result = q.name.."-"..belt_name
						data:extend{tbelt_item}
					else
						data:extend{tbelt_item}
					end
				end
				--log("[Belt Quality] Created underground belt prototype: Quality: "..q.name.." Name: "..tbelt.name)
			end
		end
	end
end
local function create_splitter_prototypes(splitter_types)
	for _,belt_name in ipairs(splitter_types) do
		local base_belt = data.raw["splitter"][belt_name]
		local base_belt_item = data.raw["item"][belt_name]
		
		for _,q in pairs(data.raw["quality"]) do
			if q.name == "quality-unknown" then
	
			else
				if q.level > 0 then	
					local tbelt = table.deepcopy(base_belt)
					tbelt.localised_name =  {"entity-name."..tbelt.name}
					tbelt.name = tbelt.name.."-quality-"..q.level
					if settings.startup["enable-conveyor-speed-scaling"].value == true then
						tbelt.speed = tbelt.speed * (q.level*scaling_factor+1)
					else
						tbelt.speed = tbelt.speed
					end
					tbelt.localised_description = q.name
					if not settings.startup["mqs-belt-changes"] or not settings.startup["mqs-belt-changes"].value then
						data:extend{tbelt}
					end
					local tbelt_item = {
						type = "item",
						name = tbelt.name,
						localised_name = tbelt.localised_name,
						icon = base_belt_item.icon,
						icon_size = base_belt_item.icon_size,
						order = base_belt_item.order.."-quality-"..q.level,
						stack_size = base_belt_item.stack_size,
						place_result = tbelt.name
					}
					if settings.startup["mqs-belt-changes"] and settings.startup["mqs-belt-changes"].value then
						tbelt_item.name = q.name.."-"..belt_name
						tbelt_item.place_result = q.name.."-"..belt_name
						data:extend{tbelt_item}
					else
						data:extend{tbelt_item}
					end
				end
				--log("[Belt Quality] Created splitter prototype: Quality: "..q.name.." Name: "..tbelt.name)
			end
		end
	end
end
local function create_adv_furn_loader_prototypes()
	loader_list = {}
	iter = 0
	for _,i in pairs(data.raw["loader-1x1"]) do
		--log(serpent.block(i))
		if i.name:find("loader") and not i.name:find("quality") and not i.name:find("^loader$") and not i.name:find("fast") and not i.name:find("express") and not i.name:find("turbo") and not i.name:find("aai") then
			loader_list[iter] = i.name
			for _,q in pairs(data.raw["quality"]) do
				if q.name == unknown then 
				else
					--if q.level > 0 then
						local loader = table.deepcopy(i)
						--log(loader.name)
						loader.localised_name = {"entity-name."..loader.name}
						loader.name = loader.name.."-quality-"..q.level
						if settings.startup["enable-conveyor-speed-scaling"].value == true then
							loader.speed = loader.speed * (1+scaling_factor*q.level)
						else
							loader.speed = loader.speed
						end
						loader.localised_description = q.name
						data:extend{loader}
						--log("write "..i.name.."at iter "..iter)
					--end
				end
			end
			iter = iter + 1
		end
	end
	--log(serpent.block(loader_list))
	iter = 0
	for _,i in pairs(data.raw["item"]) do
		if i.name:find("loader") and not i.name:find("quality") and not i.name:find("^loader$") and not i.name:find("fast") and not i.name:find("express") and not i.name:find("turbo") and not i.name:find("^loader-1x1$") and not i.name:find("aai") then	
			local base_name = loader_list[iter]
			for _,q in pairs(data.raw["quality"]) do
				if q.name == "unknown" then
				else	
					if q.level > 0 then
						local loader_item = table.deepcopy(i)
						
						if loader_list[iter+1] == nil then
							loader_item.name = base_name.."-quality-"..q.level
							loader_item.place_result = base_name.."-quality-"..q.level
						else
							loader_item.name = loader_list[iter+1].."-quality-"..q.level
							loader_item.place_result = loader_list[iter+1].."-quality-"..q.level
						end
						loader_item.localised_name = i.localised_name
						--loader_item.place_result = base_name.."-quality-"..q.level
						loader_item.order = loader_item.order.."-quality-"..q.level
						--log(loader_item.name)
						data:extend{loader_item}
					end
				end
			end
			iter = iter + 1
		end
	end
end
local function create_aai_loader_prototypes()
	--log(serpent.block(data.raw["loader-1x1"]))
	for _,i in pairs(data.raw["loader-1x1"]) do
		--log(i.name)
		if (i.name:find("aai") or i.name:find("ei")) and i.name:find("loader") and not i.name:find("quality") then
			for _,q in pairs(data.raw["quality"]) do
				if q.name == "unknown" then
				else
					if q.level > 0 then
						local loader = table.deepcopy(i)
						loader.localised_name = {"entity-name."..loader.name}
						loader.name = loader.name.."-quality-"..q.level
						if settings.startup["enable-conveyor-speed-scaling"].value == true then
							loader.speed = loader.speed * (1+scaling_factor*q.level)
						else
							loader.speed = loader.speed
						end
						loader.localised_description = q.name
						data:extend{loader}
						--log(loader.name)
					end
				end
			end
		end
	end
	for _,i in pairs(data.raw["storage-tank"]) do
		--log(i.name)
		if i.name:find("aai") and i.name:find("loader") and i.name:find("pipe") and not i.name:find("quality") then
			for _,q in pairs(data.raw["quality"]) do
				if q.name == "unknown" then
				else
					if q.level > 0 then
						local loader_pipe = table.deepcopy(i)
						loader_pipe.localised_name = {"entity-name."..loader_pipe.name}
						loader_pipe.name = loader_pipe.name:gsub("%-pipe","-quality-"..q.level.."-pipe")
						data:extend{loader_pipe}
						--log(loader_pipe.name)
					end
				end
			end
		end
	end
	for _,i in pairs(data.raw["item"]) do
		if (i.name:find("aai") or i.name:find("ei")) and i.name:find("loader") and not i.name:find("quality") and not i.name:find("pipe") then
			for _,q in pairs(data.raw["quality"]) do
				if q.name == "unknown" then
				else
					if q.level > 0 then
						local loader_item = table.deepcopy(i)
						loader_item.localised_name = i.localised_name
						loader_item.name = loader_item.name.."-quality-"..q.level
						loader_item.place_result = loader_item.name
						data:extend{loader_item}
					end
				end
			end
		end
	end
	--log(serpent.block(data.raw["storage-tank"]))
	--log(serpent.block(data.raw["loader-1x1"]))
end
create_transport_prototypes(belt_types)
create_underground_prototypes(underground_belt_types)
create_splitter_prototypes(splitter_types)
if mods["Load-Furn-2-SpaceAgeFix"] then
	create_adv_furn_loader_prototypes()
end
if mods["aai-loaders"] or mods["exotic-space-industries"] then
	create_aai_loader_prototypes()
end

data:extend({
  {
    type = "shortcut",
    name = "belt-conversion-toggle",
	localised_name = "Toggle belt conversion",
	tooltip = "Toggle belt conversion",
    action = "lua",
    associated_control_input = "belt-conversion-toggle",
    toggleable = true,
    icon = "__belt-quality__/icons/quality_belt_on.png",
	small_icon = "__belt-quality__/icons/quality_belt_on.png",
	disabled_icon = "__belt-quality__/icons/quality_belt_on.png",
	disabled_small_icon = "__belt-quality__/icons/quality_belt_on.png"
  }
})

data:extend({
	{
		type = "selection-tool",
		name = "conversion-tool",
		icon = "__base__/graphics/icons/blueprint.png",
		icon_size = 64,
		flags = {"only-in-cursor","not-stackable","spawnable"},
		hidden = true,
		select =
		{
			border_color = {0, 1, 0},
			mode = {"any-entity"},
			cursor_box_type = "copy",
			started_sound = { filename = "__core__/sound/blueprint-select.ogg" },
			ended_sound = { filename = "__core__/sound/blueprint-create.ogg" }
		},
		alt_select =
		{
			border_color = {0, 0, 1},
			mode = {"nothing"},
			cursor_box_type = "copy",
			started_sound = { filename = "__core__/sound/blueprint-select.ogg" },
			ended_sound = { filename = "__core__/sound/blueprint-create.ogg" }
		},
		pick_sound = "__base__/sound/copy-cursor.ogg",
		stack_size = 1
	}
})

data:extend({
	{
		type = "shortcut",
		name = "conversion-tool",
		localised_name = "Belt conversion tool",
		tooltip = "Converts all belts is selection zone in modded ones",
		action = "lua",
		icon = "__base__/graphics/icons/blueprint.png",
		small_icon = "__base__/graphics/icons/blueprint.png"
    }
})

data:extend({
	{
		type = "selection-tool",
		name = "un-conversion-tool",
		icon = "__base__/graphics/icons/deconstruction-planner.png",
		icon_size = 64,
		flags = {"only-in-cursor","not-stackable","spawnable"},
		hidden = true,
		select =
		{
			border_color = {1, 0, 0},
			mode = {"any-entity"},
			cursor_box_type = "copy",
			started_sound = { filename = "__core__/sound/blueprint-select.ogg" },
			ended_sound = { filename = "__core__/sound/blueprint-create.ogg" }
		},
		alt_select =
		{
			border_color = {0, 0, 1},
			mode = {"nothing"},
			cursor_box_type = "copy",
			started_sound = { filename = "__core__/sound/blueprint-select.ogg" },
			ended_sound = { filename = "__core__/sound/blueprint-create.ogg" }
		},
		pick_sound = "__base__/sound/copy-cursor.ogg",
		stack_size = 1
	}
})

data:extend({
	{
		type = "shortcut",
		name = "un-conversion-tool",
		localised_name = "Belt un-conversion tool",
		tooltip = "Un-converts all modded belts is selection zone into vanilla ones",
		action = "lua",
		icon = "__base__/graphics/icons/deconstruction-planner.png",
		small_icon = "__base__/graphics/icons/deconstruction-planner.png"
    }
})