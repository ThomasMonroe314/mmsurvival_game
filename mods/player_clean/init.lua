--[[
This code is designed to clear admin items from a player
when they join and reset their privileges.
It can be overriden in minetest.conf using:
pclean.on_join = false
pclean.reset_privs = false
It adds a single command /clean <player> for use afer a player joins'
by shivajiva101@hotmail.com
]]--

local mod_data = minetest.get_mod_storage()
local ticket_queue = {}
local tickets = false
local type = {main="main",craft="craft"}
-- whitelist is a table of player names i.e. {"c55","Krock","steve"}
local whitelist = {"Natechip","system32","linuxkernel","garywhite","Emerald","ChinaGraph","stormchaser3000","kovu2296","ThomasMonroe","Apaitijo","longerstaff13","hero8","Bobr","CalebDavis","sare","kennoath","luk3yx","Lord_Magikarp","Abramowitz971","Chem","X-men","Phoenix","AlexisCU","Sofianecafter","XgummybearsX","DeadlyDodo","NNOITRAK","Brocoli","shivajiva","yik","Shaker715","Almafa","Blop","Big3Force","CYBERJAM","Yuzuki_Airi","SGT_Pain"}
local bad_strings = {"admin","maptools:"} -- items containing these strings will be removed
local join = minetest.setting_get("pclean.on_join") or "true"
local clean_priv = minetest.setting_get("pclean.reset_privs") or "true"
local priv_set = {interact=true, shout=true, home=true, fast=true} -- privs player is left with after clean

local function bad_item(item_string)
    for i=1,#bad_strings do
        if string.find(item_string, bad_strings[i]) ~= nil then
            return true
        end
    end
end

local function do_queue()

  -- any requests in the queue?
  if table.getn(ticket_queue) == 0 then
  		tickets = false
  		return
  end

  -- Process requests
  for t = table.getn(ticket_queue),1,-1 do

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
    for key,str in pairs(type) do
        if not player_inv:is_empty(str) then
            for i,v in ipairs(player_inv_lists[key]) do
              if bad_item(v:get_name()) then
                local taken = player_inv:remove_item(str, v)
                minetest.log("action", "removed "..v:get_count().." "..v:get_name().." from "..player_name)
              end
            end
        end
    end

    -- detached armor
    minetest.log("action", "checking armor inventory...")
    local armor_inv = minetest.get_inventory({type="detached", name=player_name.."_armor"})
    local armor_inv_list = armor_inv:get_lists()
    for i,v in ipairs(armor_inv_list.armor) do
      if bad_item(v:get_name()) then
          local taken = player_inv:remove_item("armor", v)
          taken = armor_inv:remove_item("armor", v)
          minetest.log("action", "removed "..v:get_count().." "..v:get_name().." from "..player_name)
          armor:set_player_armor(player) --refresh
      end
    end


    -- do bags
    minetest.log("action", "checking bag inventories...")
    for bag=1,4 do
        -- is the slot filled?
        if not player_inv:is_empty('bag'..bag) then
            -- iterate the bag inventory
            for i=1,player_inv:get_size('bag'..bag..'contents') do
                local stack = player_inv:get_stack('bag'..bag..'contents', i)
                if bad_item(stack:get_name()) then
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
  minetest.after(0.5, do_queue)
end

local function add_ticket(player)
  table.insert(ticket_queue, player)
  if tickets == false then
    tickets = true
    minetest.after(0.5, do_queue)
  end
end

if join == "true" then
    minetest.register_on_joinplayer(function(player)
            local name = player:get_player_name()
            for i=1,#whitelist do
                if whitelist[i] == name then return end
            end
            add_ticket(player)
    end)
end

minetest.register_chatcommand("clean", {
    params = "<text>",
	description = "cleans player inventories of restricted items",
	privs = {server = true},
    func = function(name, param)
        -- check for missing param
        if param == "" then
          return false, "Invalid usage, /clean <player>"
        end
        local player = minetest.get_player_by_name(param)
        for i=1,#whitelist do
            if whitelist[i] == param then return end
        end
        add_ticket(player)
    end
})
