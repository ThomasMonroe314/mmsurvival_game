local mod_storage = minetest.get_mod_storage()
--set's market to spawn on first load
if mod_storage:get_string("market")=="" then
    mod_storage:set_string("market",minetest.setting_get("static_spawnpoint"))
end
 
minetest.register_chatcommand("setmarket", {
    privs = {server = true},
    description = "Set the location market.",
    func = function(name, param)
        --Check for proper player [forbids console commands, not really needed]
        local player = minetest.env:get_player_by_name(name)
        if not player then
            return
        end
        --Get player position and set market just below that just because it looks cooler.
        local pos = player:getpos()
        pos.x = math.floor(0.5+pos.x)
        pos.z = math.floor(0.5+pos.z)
        mod_storage:set_string("market", minetest.pos_to_string(pos))
       
        --Notify admin who set market place.
        minetest.chat_send_player(name, "Market set at, "..minetest.setting_get("staff_place"));
    end,
})
 
minetest.register_chatcommand("market", {
    description = "Teleport to the market.",
    privs = {
        interact = true
    },
    func = function(name, param)
    local player = minetest.env:get_player_by_name(name)
        if not player then
            return
        end
        --teleport player to market
        player:setpos(minetest.string_to_pos(mod_storage:get_string("market")))
    end
})
