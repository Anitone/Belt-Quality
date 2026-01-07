local serpent = require("serpent")
belt_types = {}
quality_list = {}
quality_list_alt = {}
local function buildList()
	if next(belt_types)==nil and next(quality_list)==nil and next(quality_list_alt)==nil then
		for _,i in pairs(prototypes.entity) do
			if (i.name:find("belt") or i.name:find("loader") or i.name:find("splitter")) and not i.name:find("quality") and not i.name:find("remnants") and not i.name:find("explosion") and not i.name:find("%-pipe")  then
				table.insert(belt_types,i.name)
			end
		end
		for _,i in pairs(prototypes.quality) do 
			table.insert(quality_list,i)
			quality_list_alt[i.name] = true
	end
	end
end

script.on_init(buildList())
script.on_load(buildList())
script.on_configuration_changed(buildList())

conversion = false
script.on_event(defines.events.on_lua_shortcut, function(event)
	buildList()
	--game.print(serpent.block(belt_types))
	if event.prototype_name == "belt-conversion-toggle" then
		local player = game.get_player(event.player_index)
		if not player then return end
		conversion = not conversion
		game.print(conversion and "Belt conversion turned on" or "Belt conversion turned off")
	elseif event.prototype_name == "conversion-tool" then	
		local player = game.get_player(event.player_index)
		if not player then return end

		player.cursor_stack.set_stack{name = "conversion-tool", count = 1}
		player.play_sound{path = "utility/inventory_click"}
	elseif event.prototype_name == "un-conversion-tool" then	
		local player = game.get_player(event.player_index)
		if not player then return end

		player.cursor_stack.set_stack{name = "un-conversion-tool", count = 1}
		player.play_sound{path = "utility/inventory_click"}
	end
end)

script.on_event(defines.events.on_player_created, function(event)
	local player = game.get_player(event.player_index)
	if not player then return end

	buildList()

	player.set_shortcut_available("belt-conversion-toggle", true)
	player.set_shortcut_available("conversion-tool", true)
	player.set_shortcut_toggled("belt-conversion-toggle",false)
end)

script.on_event(defines.events.on_player_main_inventory_changed, function(event)
	if not conversion then return end
	if upgrading == true then return end
	upgrading = true
	
	buildList()

	local inventory = game.get_player(event.player_index).get_main_inventory()
	if not inventory then return end
	for i=1, #inventory do
		local stack = inventory[i]
		
		for _,belt_name in ipairs(belt_types) do
			if stack and stack.valid_for_read and stack.name == belt_name then
				log(stack.name)
				local quality = stack.quality.level
				if quality > 0 then
					local qname = stack.quality.name
					local count = stack.count
					for _,qobj in pairs(quality_list) do
						if stack.name:find(qobj.name) then return end
					end
					stack.clear()
					if settings.startup["mqs-belt-changes"] and settings.startup["mqs-belt-changes"].value then
							inventory.insert({
								localised_name = {"entity-name."..belt_name},
								name = qname.."-"..belt_name,
								quality = qname,
								count = count
							})
							game.print(belt_name)
					else
						inventory.insert({
							localised_name = {"entity-name."..belt_name},
							name = belt_name.."-quality-"..quality,
							quality = qname,
							count = count
						})
					end
				end
			end
		end
	end
	
	upgrading = false
end)

script.on_event(defines.events.on_player_selected_area, function(event)
	buildList()
	if event.item == "conversion-tool" then
		local player = game.get_player(event.player_index)
		if not player then return end
		local surface = player.surface
		local count = 0
		for _,entity in pairs(event.entities) do
			for _,qobj in pairs(quality_list) do 
				if entity.name:find(qobj.name) then return end
			end
			
				for _,obj in pairs(belt_types) do
					if entity.name == obj then
						if	entity.quality.level > 0 then
							local position = entity.position
							local force = entity.force
							local ename = entity.name
							local direction = entity.direction
							local quality = entity.quality
							local filters = nil
							local input_priority = nil
							local output_priority = nil
							if entity.type == "splitter" then
								filters = entity.splitter_filter
								input_priority = entity.splitter_input_priority
								output_priority = entity.splitter_output_priority
							end
							local btg = nil
							if entity.type == "underground-belt" then
								btg = entity.belt_to_ground_type
								if btg == "input" then
								elseif btg == "output" then
									if direction == defines.direction.north then
										direction = defines.direction.south
									elseif direction == defines.direction.south then
										direction = defines.direction.north
									elseif direction == defines.direction.east then
										direction = defines.direction.west
									elseif direction == defines.direction.west then
										direction = defines.direction.east
									end
								end
							end
							entity.destroy()
							local new_entity = surface.create_entity{
								localised_name = {"entity-name."..ename},
								name = ename.."-quality-"..quality.level,
								position = position,
								direction = direction,
								force = force,
								quality = quality.name,
								belt_to_ground = btg,
								--splitter_filter = filters,
								--input_priority = input_priority,
								--output_priority = output_priority,
								fast_replace = true,
								spill = false
							}
							if new_entity.type == "splitter" then
								new_entity.splitter_filter = filters
								new_entity.splitter_input_priority = input_priority
								new_entity.splitter_output_priority = output_priority
							end
							count = count+1
						end
						break
					end
				end
		end
		if settings.global["enable-debug-messages"].value then
			game.print("Converted "..count.." entities.")
		end
	elseif event.item == "un-conversion-tool" then
		local player = game.get_player(event.player_index)
		if not player then return end
		local surface = player.surface
		local count = 0
		for _,entity in pairs(event.entities) do
			for _,qobj in pairs(quality_list) do 
				if entity.name:find(qobj.name) then return end
			end
			local quality = entity.quality
				for _,obj in pairs(belt_types) do
					if entity.name == obj.."-quality-"..quality.level then
						if	entity.quality.level > 0 then
								local position = entity.position
								local direction = nil
								if entity.name:find("underground") then
									if entity.belt_to_ground_type == "output" then
										if entity.direction == defines.direction.north then
											direction = defines.direction.south
										elseif entity.direction == defines.direction.west then
											direction = defines.direction.east
										elseif entity.direction == defines.direction.south then
											direction = defines.direction.north
										elseif entity.direction == defines.direction.east then
											direction = defines.direction.west
										end
									else
										direction = entity.direction
									end
								else
									direction = entity.direction
								end
								local force = entity.force
								surface.create_entity{
									localised_name = {"entity-name."..obj},
									name = obj,
									position = position,
									direction = direction,
									force = force,
									quality = quality.name,
									fast_replace = true,
									spill = false
								}
								count = count + 1		
						end
						break
					end
				end
		end
		if settings.global["enable-debug-messages"].value then
			game.print("Un-converted "..count.." entities.")
		end
	end
end)

script.on_event(defines.events.on_player_mined_entity, function(event)
	buildList()
	log(serpent.block(belt_types))	
	local entity = event.entity
	if not entity then return end
	for _,obj in pairs(belt_types) do 
		if entity.name:find(obj) and not entity.name:find("explosion") and not entity.name:find("remnants") then
			local player = game.get_player(event.player_index)
			if not player then return end
			local inventory = player.get_main_inventory()
			if not inventory then return end
			local entity_name = entity.name
			--game.print(entity_name.." "..entity.quality)
			local quality = entity.quality
			event.buffer.clear()
			inventory.insert({name = entity_name, count = 1, quality = quality.name })
		end
	end
end)