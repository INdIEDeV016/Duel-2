extends Node

signal generated

export var player = preload("res://DummyPlayer.tscn")

onready var main = $"/root/Main"
onready var tile_map: TileMap = get_parent()
onready var map_border_rect: Rect2 = tile_map.get_used_rect()

func _ready():
	randomize()
	generate_level()

func generate_level():
	for x in map_border_rect.size.x:
		for y in map_border_rect.size.y:
			tile_map.solid_area.append(Vector2(x, y))
	
	var walker = Walker.new(Vector2(map_border_rect.size.x / 2, map_border_rect.size.y / 2), map_border_rect)
	tile_map.map = walker.walk(map_border_rect.get_area() + 1000)
#	print(map_border_rect.get_area())
	
	walker.queue_free()
	
	
	for location in tile_map.map:
		tile_map.solid_area.erase(location)
	
	for location in tile_map.solid_area:
#		yield(get_tree(), "idle_frame") # This is a magic command. It can literally show how Godot is generating the map!
		tile_map.call_deferred("set_cellv", location, 0)
	
	emit_signal("generated")
	print("Map Generated | Total Area: %s | Movable Area: %s | Non-movable Area: %s" % [map_border_rect.get_area(), tile_map.map.size(), tile_map.solid_area.size()])

	owner.get_node("Players/DummyPlayer").global_position = tile_map.to_global(tile_map.map_to_world(tile_map.map[randi() % tile_map.map.size()], true))
