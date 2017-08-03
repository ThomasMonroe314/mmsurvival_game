local old_nodes = {"vines:side_end", "vines:side_middle", "vines:root_middle", "vines:root_end", "vines:jungle_end", "vines:jungle_middle", "vines:vine_middle", "vines:vine_end", "cavestuff:desert_pebble_2", "xmas:leaves", "xmas:leaves_lit", "xmas:ball_1", "xmas:ball_2", "xmas:ball_3", "xmas:ball_4", "christmas_craft:snowman", "christmas_craft:christmas_lights", "christmas_craft:christmas_wreath", "christmas_craft:christmas_star", "christmas_craft:snow_block", "christmas_craft:christmas_leaves", "christmas_craft:Christmas_present_red", "caca:caca_source"}
local old_entities = {}

for _,node_name in ipairs(old_nodes) do
    minetest.register_node(":"..node_name, {
        groups = {old=1},
    })
end

minetest.register_abm({
    nodenames = {"group:old"},
    interval = 1,
    chance = 1,
    action = function(pos, node)
        minetest.env:remove_node(pos)
    end,
})

for _,entity_name in ipairs(old_entities) do
    minetest.register_entity(":"..entity_name, {
        on_activate = function(self, staticdata)
            self.object:remove()
        end,
    })
end
