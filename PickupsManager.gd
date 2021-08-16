extends Node2D


var pickups: Array = []

onready var tile_map = $"../TileMap"


func _ready() -> void:
	for child in get_children():
		if child is Pickup:
			yield(get_tree(), "idle_frame")
			child.position = tile_map.map_to_world(tile_map.map[randi() % tile_map.map.size()])
	
	
