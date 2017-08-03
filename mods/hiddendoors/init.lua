-- HiddenDoors

hiddendoors = {}

function hiddendoors.register_door(material, name)
	minetest.register_node("hiddendoors:" .. material, {
	description = name .. " Hidden Door",
	walkable = false,
	climbable = true,
	is_ground_content = false,
	inventory_image = "hiddendoors_" .. material .. "_inventory.png",
	tiles = {"default_" .. material .. ".png"},
	groups = {cracky = 2},
	})
	
	minetest.register_craft({
		output = "hiddendoors:" .. material .. " 2",
		recipe = {
		{"", "", ""},
		{"default:glass", "default:" .. material , ""},
		{"", "", ""}
		}
	})
end

hiddendoors.register_door("obsidian", "Obsidian")
hiddendoors.register_door("stone", "Stone")
hiddendoors.register_door("desert_stone_brick", "Desert Stone Brick")
hiddendoors.register_door("stone_brick", "Stone Brick")
hiddendoors.register_door("tree", "Tree")
hiddendoors.register_door("dirt", "Dirt")
hiddendoors.register_door("desert_stone", "Desert Stone")
hiddendoors.register_door("brick", "Brick")
hiddendoors.register_door("wood", "Wood")
