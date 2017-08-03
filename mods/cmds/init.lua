minetest.register_privilege("invis", "Able to turn invisible.")

minetest.register_chatcommand("whereis", {
	params = "<playername>",
	description = "Shows a players location.",
	privs = {basic_privs=true},
	func = function(name, param)
		if not param or param == "" then 
			minetest.chat_send_player(name, "Usage: /whereis <playername> ")
			return 
		end
		local player = minetest.get_player_by_name(param)
		if player then
			local pos = player:getpos()
			local px = math.floor(pos.x, 1)
			local py = math.floor(pos.y, 1)
			local pz = math.floor(pos.z, 1)
			minetest.chat_send_player(name, "Location of "..param.." is ("..px.." "..py.." "..pz..")")
		else
			minetest.chat_send_player(name, param.." is not online.")
		end
	end
})

minetest.register_chatcommand("invis", {
	params = "<on/off>",
	description = "Become invisible",
	privs = {invis = true},
	func = function(name, param)
		local watcher = minetest.get_player_by_name(name)
		if param == "on" then
				watcher:set_nametag_attributes({color = {a=0}})
				watcher:set_properties({
					visual_size = {x=0, y=0},
					makes_footstep_sound = false,
					collisionbox = {0}			
				})
				minetest.chat_send_player(name,"You are now invisible!")
				return
		elseif param == "off" then
			watcher:set_nametag_attributes({color = {a=255, r=255, g=255, b=255}})
			watcher:set_properties({
				visual_size = {x=1, y=1},
				makes_footstep_sound = true,
				collisionbox = {-0.3, -1, -0.3, 0.3, 1, 0.3}
			})
			minetest.chat_send_player(name,"You are now visible!")
			return
		else
			minetest.chat_send_player(name,"Not a valid option")
			return
		end
	end,
})
