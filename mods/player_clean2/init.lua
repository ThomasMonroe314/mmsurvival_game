--[[
This code is designed to clear admin items from a player
when they join and reset their privileges.
It can be overriden in minetest.conf using:
pclean.on_join = false
pclean.reset_privs = false
It adds a two commands /clean <player> for use afer a player joins'
and /pcwl [{add|remove} <player>]

by shivajiva101@hotmail.com

]]--

local pc = {}
local ticket_queue = {}
local tickets = false
local itype = {main = "main", craft = "craft"}
local whitelist = {}
local bad_strings = {"admin", "maptools:"} -- items containing these strings will be removed
local join = minetest.setting_get("pclean.on_join") or "true"
local clean_priv = minetest.setting_get("pclean.reset_privs") or "true"
local priv_set = {interact = true, shout = true } -- privs player is left with after clean
local ms = minetest.get_mod_storage() -- get a reference to the mod storage
local owner = minetest.setting_get("name")

pc.save_data = function()
    ms:set_string("wl", minetest.serialize(whitelist))
end

pc.load_data = function()
    local t = minetest.deserialize(ms:get_string("wl"))
    if type(t) == "table" then
        whitelist = t
    end
end
pc.load_data()

if not whitelist[owner] then
    whitelist[owner] = true
    pc.save_data()
end

pc.bad_item = function(item_string)
    for i = 1, #bad_strings do
        if string.find(item_string, bad_strings[i]) ~= nil then
            return true
        end
    end
end

pc.do_queue = function()

    -- any requests in the queue?
    if table.getn(ticket_queue) == 0 then
        tickets = false
        return
    end

    -- Process requests
    for t = table.getn(ticket_queue), 1, - 1 do

        local player = ticket_queue[t]
        local player_name = player:get_player_name()
        local player_inv = player:get_inventory()
        local player_inv_lists = player_inv:get_lists()

        -- remove privs
        if clean_priv == "true" then
            minetest.set_player_privs(player_name, priv_set)
        end

        -- do normal inventories
        minetest.log("action", "checking attached inventories...")
        for key, str in pairs(itype) do
            if not player_inv:is_empty(str) then
                for i, v in ipairs(player_inv_lists[key]) do
                    if pc.bad_item(v:get_name()) then
                        local taken = player_inv:remove_item(str, v)
                        minetest.log("action", "removed "..v:get_count().." "..v:get_name().." from "..player_name)
                    end
                end
            end
        end

        -- detached armor
        minetest.log("action", "checking armor inventory...")
        local armor_inv = minetest.get_inventory({type = "detached", name = player_name.."_armor"})
        local armor_inv_list = armor_inv:get_lists()
        for i, v in ipairs(armor_inv_list.armor) do
            if pc.bad_item(v:get_name()) then
                local taken = player_inv:remove_item("armor", v)
                taken = armor_inv:remove_item("armor", v)
                minetest.log("action", "removed "..v:get_count().." "..v:get_name().." from "..player_name)
                armor:set_player_armor(player) --refresh
            end
        end


        -- do bags
        minetest.log("action", "checking bag inventories...")
        for bag = 1, 4 do
            -- is the slot filled?
            if not player_inv:is_empty('bag'..bag) then
                -- iterate the bag inventory
                for i = 1, player_inv:get_size('bag'..bag..'contents') do
                    local stack = player_inv:get_stack('bag'..bag..'contents', i)
                    if pc.bad_item(stack:get_name()) then
                        local taken = player_inv:remove_item('bag'..bag..'contents', stack)
                        minetest.log("action", "removed "..stack:get_count().." "..stack:get_name().." from "..player_name)
                    end
                end
            end
        end

        -- remove ticket
        table.remove(ticket_queue, t)
    end

    -- set flag and escape timer if all tickets have been processed
    if table.getn(ticket_queue) == 0 then
        tickets = false
        return
    end

    -- schedule next call
    minetest.after(0.5, pc.do_queue)
end

pc.add_ticket = function(player)
    table.insert(ticket_queue, player)
    if tickets == false then
        tickets = true
        minetest.after(0.5, pc.do_queue)
    end
end

if join == "true" then
    minetest.register_on_joinplayer(function(player)
        local name = player:get_player_name()
        if whitelist[name] then return end -- exclude whitelisted player
        pc.add_ticket(player)
    end)
end

minetest.register_privilege("pcadmin", "Admin for player_clean")

minetest.register_chatcommand("pcwl", {
    params = "{add|remove} <nick>",
    help = "Administrate player_clean whitelist",
    privs = {pcadmin = true},
    func = function(name, param)
        local action, p = param:match("^([^ ]+) ([^ ]+)$")
        if action == "add" then
            if whitelist[p] then
                return false, p.." is already whitelisted."
            end
            whitelist[p] = true
            pc.save_data()
            return true, "Added "..p.." to the whitelist."
        elseif action == "remove" then
            if not whitelist[p] then
                return false, p.." is not on the whitelist."
            end
            whitelist[p] = nil
            pc.save_data()
            return true, "Removed "..p.." from the whitelist."
        else
            for k, v in pairs(whitelist) do
                minetest.chat_send_player(name, k)
            end
            return true
        end
    end,
})

minetest.register_chatcommand("clean", {
    params = "<text>",
    description = "cleans player inventories of restricted items",
    privs = {pcadmin = true},
    func = function(name, param)
        -- check for missing param
        if param == "" then
            return false, "Invalid usage, /clean <player>"
        end
        local player = minetest.get_player_by_name(param)
        -- exclude whitelisted player
        if whitelist[name] then return end
        add_ticket(player)
    end
})
