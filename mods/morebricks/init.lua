--Register Nodes
minetest.register_node("morebricks:clear", {
	description = "Clear Brick",
	tiles = {"morebricks_clear.png"},
	is_ground_content = true,
	groups = {cracky=3, stone=1}
})

minetest.register_node("morebricks:black", {
	description = "Black Brick",
	tiles = {"morebricks_black.png"},
	is_ground_content = true,
	groups = {cracky=3, stone=1}
})

minetest.register_node("morebricks:blue", {
	description = "Blue Brick",
	tiles = {"morebricks_blue.png"},
	is_ground_content = true,
	groups = {cracky=3, stone=1}
})

minetest.register_node("morebricks:brown", {
	description = "Brown Brick",
	tiles = {"morebricks_brown.png"},
	is_ground_content = true,
	groups = {cracky=3, stone=1}
})

minetest.register_node("morebricks:cyan", {
	description = "Cyan Brick",
	tiles = {"morebricks_cyan.png"},
	is_ground_content = true,
	groups = {cracky=3, stone=1}
})

minetest.register_node("morebricks:navy", {
	description = "Navy Brick",
	tiles = {"morebricks_navy.png"},
	is_ground_content = true,
	groups = {cracky=3, stone=1}
})

minetest.register_node("morebricks:green", {
	description = "Green Brick",
	tiles = {"morebricks_green.png"},
	is_ground_content = true,
	groups = {cracky=3, stone=1}
})

minetest.register_node("morebricks:red", {
	description = "Red Brick",
	tiles = {"morebricks_red.png"},
	is_ground_content = true,
	groups = {cracky=3, stone=1}
})

minetest.register_node("morebricks:grey", {
	description = "Grey Brick",
	tiles = {"morebricks_grey.png"},
	is_ground_content = true,
	groups = {cracky=3, stone=1}
})

minetest.register_node("morebricks:lime", {
	description = "Lime Brick",
	tiles = {"morebricks_lime.png"},
	is_ground_content = true,
	groups = {cracky=3, stone=1}
})

minetest.register_node("morebricks:navy", {
	description = "Navy Brick",
	tiles = {"morebricks_navy.png"},
	is_ground_content = true,
	groups = {cracky=3, stone=1}
})

minetest.register_node("morebricks:orange", {
	description = "Orange Brick",
	tiles = {"morebricks_orange.png"},
	is_ground_content = true,
	groups = {cracky=3, stone=1}
})

minetest.register_node("morebricks:peach", {
	description = "Peach Brick",
	tiles = {"morebricks_peach.png"},
	is_ground_content = true,
	groups = {cracky=3, stone=1}
})

minetest.register_node("morebricks:pink", {
	description = "Pink Brick",
	tiles = {"morebricks_pink.png"},
	is_ground_content = true,
	groups = {cracky=3, stone=1}
})

minetest.register_node("morebricks:purple", {
	description = "Purple Brick",
	tiles = {"morebricks_purple.png"},
	is_ground_content = true,
	groups = {cracky=3, stone=1}
})

minetest.register_node("morebricks:yellow", {
	description = "Yellow Brick",
	tiles = {"morebricks_yellow.png"},
	is_ground_content = true,
	groups = {cracky=3, stone=1}
})





--Register craft

minetest.register_craft({
	type = "shapeless",
	output = "morebricks:clear",
	recipe = {"default:clay_lump", "default:stone"}
})

minetest.register_craft({
	type = "shapeless",
	output = "morebricks:black",
	recipe = {"morebricks:clear", "dye:black"}
})

minetest.register_craft({
	type = "shapeless",
	output = "morebricks:blue",
	recipe = {"morebricks:clear", "dye:blue"}
})

minetest.register_craft({
	type = "shapeless",
	output = "morebricks:brown",
	recipe = {"morebricks:clear", "dye:brown"}
})

minetest.register_craft({
	type = "shapeless",
	output = "morebricks:cyan",
	recipe = {"morebricks:clear", "dye:cyan"}
})

minetest.register_craft({
	type = "shapeless",
	output = "morebricks:green",
	recipe = {"morebricks:clear", "dye:green"}
})

minetest.register_craft({
	type = "shapeless",
	output = "morebricks:red",
	recipe = {"morebricks:clear", "dye:red"}
})

minetest.register_craft({
	type = "shapeless",
	output = "morebricks:grey",
	recipe = {"morebricks:clear", "dye:grey"}
})

minetest.register_craft({
	type = "shapeless",
	output = "morebricks:lime",
	recipe = {"morebricks:clear", "dye:lime"}
})

minetest.register_craft({
	type = "shapeless",
	output = "morebricks:navy",
	recipe = {"morebricks:blue", "dye:blue"}
})

minetest.register_craft({
	type = "shapeless",
	output = "morebricks:orange",
	recipe = {"morebricks:clear", "dye:orange"}
})

minetest.register_craft({
	type = "shapeless",
	output = "morebricks:peach",
	recipe = {"morebricks:clear", "dye:yellow", "dye:white"}
})

minetest.register_craft({
	type = "shapeless",
	output = "morebricks:pink",
	recipe = {"morebricks:clear", "dye:pink"}
})

minetest.register_craft({
	type = "shapeless",
	output = "morebricks:purple",
	recipe = {"morebricks:clear", "dye:violet", "dye:pink"}
})

minetest.register_craft({
	type = "shapeless",
	output = "morebricks:yellow",
	recipe = {"morebricks:clear", "dye:yellow"}
})


