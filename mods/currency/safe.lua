function default.get_safe_formspec(pos)
	local spos = pos.x .. "," .. pos.y .. "," ..pos.z
	local formspec =
		"size[8,9]"..
		"list[nodemeta:".. spos .. ";main;1,1;6,2;]"..
		"list[current_player;main;0,5;8,4;]"
	return formspec
end

local function has_safe_privilege(meta, player)
	if player:get_player_name() == meta:get_string("owner") or minetest.check_player_privs(player:get_player_name(),"protection_bypass") then
		return true
	end
	return false
end

minetest.register_node("currency:safe", {
        description = "Safe",
	inventory_image = "safe_front.png",
	paramtype = "light",
	paramtype2 = "facedir",
	tiles = {"safe_side.png",
	                "safe_side.png",
			"safe_side.png",
			"safe_side.png",
			"safe_side.png",
			"safe_front.png",},
	is_ground_content = false,
	groups = {cracky=1},
	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("infotext", "Safe (owned by "..
				meta:get_string("owner")..")")
	end,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", "Safe")
		meta:set_string("owner", "")
		local inv = meta:get_inventory()
		inv:set_size("main", 6*2)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main") and has_safe_privilege(meta, player)
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.get_meta(pos)
		if not has_safe_privilege(meta, player) then
			minetest.log("action", player:get_player_name()..
					" tried to access a safe belonging to "..
					meta:get_string("owner").." at "..
					minetest.pos_to_string(pos))
			return 0
		end
		return count
	end,
    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		if not has_safe_privilege(meta, player) then
			minetest.log("action", player:get_player_name()..
					" tried to access a safe belonging to "..
					meta:get_string("owner").." at "..
					minetest.pos_to_string(pos))
			return 0
		end
		return stack:get_count()
	end,
    allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		if not has_safe_privilege(meta, player) then
			minetest.log("action", player:get_player_name()..
					" tried to access a safe belonging to "..
					meta:get_string("owner").." at "..
					minetest.pos_to_string(pos))
			return 0
		end
		return stack:get_count()
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff in safe at "..minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" moves stuff to safe at "..minetest.pos_to_string(pos))
	end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
		minetest.log("action", player:get_player_name()..
				" takes stuff from safe at "..minetest.pos_to_string(pos))
	end,
	on_rightclick = function(pos, node, clicker)
		local meta = minetest.get_meta(pos)
		if has_safe_privilege(meta, clicker) then
			minetest.show_formspec(
				clicker:get_player_name(),
				"currency:safe",
				default.get_safe_formspec(pos)
			)
		end
	end,
})
